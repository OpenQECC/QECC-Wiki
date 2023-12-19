module QECC_Decoders

export create_lookup_table, is_degenerate, create_lookup_table_3_errors, table_decode, belief_decode_X, belief_decode_Z, TableDecoder, BeliefPropDecoder

using QuantumClifford, QuantumClifford.ECC, CairoMakie, SparseArrays, LDPCDecoders
using Combinatorics: combinations

# stefan
function evaluate_decoder(d::AbstractSyndromeDecoder, nsamples, init_error, gate_error, syndrome_circuit_func, encoding_circuit_func)
    pre_X = [sHadamard(i) for i in n-k+1:n]
    X_error = evaluate_classical_decoder(d, nsamples, init_error, gate_error, syndrome_circuit_func, encoding_circuit_func, logicalxview, 1, d.k, pre_X)
    Z_error = evaluate_classical_decoder(d, nsamples, init_error, gate_error, syndrome_circuit_func, encoding_circuit_func, logicalzview, d.k + 1, 2 * d.k)
    return (X_error, Z_error)
end

function evaluate_classical_decoder(H, nsamples, init_error, gate_error, syndrome_circuit_func, encoding_circuit_func, logical_view_func, decoder_func, pre_circuit = nothing)
    decoded = 0

    H_stab = Stabilizer(fill(0x0, size(Hx, 2)), H, zeros(Bool, size(H)))

    O = faults_matrix(H_stab)
    syndrome_circuit = syndrome_circuit_func(H_stab)
    
    s, n = size(H)
    k = n - s

    errors = [PauliError(i, init_error) for i in 1:n];

    md = MixedDestabilizer(H_stab)
    
    full_circuit = []

    logview = logical_view_func(md)
    logcirc, _ = syndrome_circuit_func(logviews)

    noisy_syndrome_circuit = add_two_qubit_gate_noise(syndrome_circuit, gate_error);
    
    for gate in logcirc
        type = typeof(gate)
        if type == sMRZ
            push!(circuit, sMRZ(gate.qubit+s, gate.bit+s))
        else
            push!(circuit, type(gate.q1, gate.q2+s))
        end
    end

    ecirc = encoding_circuit_func(syndrome_circuit)
    if isnothing(pre_circuit)
        full_circuit = vcat(pre_circuits, ecirc, errors, noisy_syndrome_circuit)
    else
        full_circuit = vcat(ecirc, errors, noisy_syndrome_circuit)
    end

    frames = PauliFrame(nframes, n+s+k, s+k)
    pftrajectories(frames, full_circuit)
    syndromes = pfmeasurements(frames)[:, 1:s]
    logical_syndromes = pfmeasurements(frames)[:, s+1: s+k]

    for i in 1:nsamples
        guess = decode(decoder_obj, syndromes[i]) # TODO: replace 'decoder_obj' with proper object

        result = (O * (guess))
        
        if result == logical_syndromes[i]
            decoded += 1
        end
    end

    return (nsamples - decoded) / nsamples
end

function evaluate_classical_decoder(d::AbstractSyndromeDecoder, nsamples, init_error, gate_error, syndrome_circuit_func, encoding_circuit_func, logical_view_function, guess_start, guess_stop, pre_circuit = nothing)
    H = d.H
    O = d.faults_matrix
    syndrome_circuit = syndrome_circuit_func(H)

    n = d.n
    s = d.s
    k = d.k

    errors = [PauliError(i, init_error) for i in 1:n];

    md = MixedDestabilizer(H)
    
    full_circuit = []

    logview = logical_view_function(md)
    logcirc, _ = syndrome_circuit_func(logview)

    noisy_syndrome_circuit = add_two_qubit_gate_noise(syndrome_circuit, gate_error);
    
    for gate in logcirc
        type = typeof(gate)
        if type == sMRZ
            push!(syndrome_circuit, sMRZ(gate.qubit+s, gate.bit+s))
        else
            push!(syndrome_circuit, type(gate.q1, gate.q2+s))
        end
    end

    ecirc = encoding_circuit_func(syndrome_circuit)
    if isnothing(pre_circuit)
        full_circuit = vcat(pre_circuits, ecirc, errors, noisy_syndrome_circuit)
    else
        full_circuit = vcat(ecirc, errors, noisy_syndrome_circuit)
    end

    frames = PauliFrame(nframes, n+s+k, s+k)
    pftrajectories(frames, full_circuit)
    syndromes = pfmeasurements(frames)[:, 1:s]
    logical_syndromes = pfmeasurements(frames)[:, s+1: s+k]

    for i in 1:nsamples
        guess = decode(d, syndromes[i])

        result = (O * (guess))[guess_start:guess_stop]
        
        if result == logical_syndromes[i]
            decoded += 1
        end
    end

    return (nsamples - decoded) / nsamples
end


# function evaluate_classical_decoder(decoder_obj, nsamples, syndrome_samples, logical_samples)
#     decoded = 0
#     for i in 1:nsamples
#         guess = decode(decoder_obj, syndrome_samples[i])

#     end
#     return (nsamples - decoded) / nsamples
# end

abstract type AbstractClassicalSyndromeDecoder end # quantum version contains 2 of these

abstract type AbstractSyndromeDecoder end

"""
```,.
decoder_instance = BeliefPropDecoder(some_properties, more_pros, something_else)

#option 1:
guess = decoder_instance(syndrome_sample) # equivalent of decoder() in gen_benchmark()

#option 2:
guess = decode(decoder_instance, syndrome_sample)

```
"""

struct TableDecoder <: AbstractSyndromeDecoder
    H
    faults_matrix
    n
    s
    k
    lookup_table
    time
end

function TableDecoder(Hx, Hz)
    c = CSS(Hx, Hz)
    H = parity_checks(c)
    s, n = size(H)
    _, _, r = canonicalize!(Base.copy(H), ranks=true)
    k = n - r
    lookup_table, time, _ = @timed create_lookup_table(H)
    faults_matrix = faults_matrix(H)
    return TableDecoder(H, n, s, k, faults_matrix, lookup_table, time)
end

struct BeliefPropDecoder <: AbstractSyndromeDecoder
    H
    faults_matrix
    n
    s
    k
    log_probabs
    channel_probs
    numchecks_X
    b2c_X
    c2b_X
    numchecks_Z
    b2c_Z
    c2b_Z
    err
end

function faults_matrix(c)
    md = MixedDestabilizer(c)
    s, n = size(c)
    r = rank(md)
    k = n - r
    k == n-s || @warn "`faults_matrix` was called on an ECC that has redundant rows (is rank-deficient). `faults_matrix` corrected for that, however this is a frequent source of mistakes and inefficiencies. We advise you remove redundant rows from your ECC."
    O = falses(2k, 2n)
    logviews = [logicalxview(md); logicalzview(md)]
    errors = [one(Stabilizer,n; basis=:X);one(Stabilizer,n)]
    for i in 1:2k
        O[i, :] = comm(logviews[i]::PauliOperator, errors) # typeassert for JET
    end
    return O
end

function BeliefPropDecoder(Hx, Hz)
    c = CSS(Hx, Hz)
    H = parity_checks(c)
    s, n = size(H)
    _, _, r = canonicalize!(Base.copy(H), ranks=true)
    k = n - r
    println(typeof(H))
    faults_matrix = faults_matrix(H)
    log_probabs = zeros(n)
    channel_probs = fill(p_init, n)

    numchecks_X = size(Cx)[1]
    b2c_X = zeros(numchecks_X, n)
    c2b_X = zeros(numchecks_X, n)

    numchecks_Z = size(Cz)[1]
    b2c_Z = zeros(numchecks_Z, n)
    c2b_Z = zeros(numchecks_Z, n)
    err = zeros(n)
    return BeliefPropDecoder(H, faults_matrix, n, s, k, log_probabs, channel_probs, numchecks_X, b2c_X, c2b_X, numchecks_Z, b2c_Z, c2b_Z, err)
end

# option 1

# function (d::BeliefPropDecoder)(syndrome_sample)
#     d.H
#     syndrome_sample
# end

# function (d::TableDecoder)(syndrome_sample)
#     d.H
#     d.lookup_table
#     syndrome_sample
# end

# option 2
function decode end

function decode(d::TableDecoder, syndrome_sample)
    return get(d.lookup_table, syndrome_sample, nothing)
end

function decode(d::BeliefPropDecoder, syndrome_sample)
    row_x = syndrome_sample[1:d.numchecks_X]
    row_z = syndrome_sample[d.numchecks_X+1:d.numchecks_X+d.numchecks_Z]

    KguessX, success = syndrome_decode(sparse(d.Cx), sparse(d.Cx'), d.row_x, d.max_iters, d.channel_probs, d.b2c_X, d.c2b_X, d.log_probabs, Base.copy(d.err))
    KguessZ, success = syndrome_decode(sparse(d.Cz), sparse(d.Cz'), d.row_z, d.max_iters, d.channel_probs, d.b2c_Z, d.c2b_Z, d.log_probabs, Base.copy(d.err))
    guess = vcat(KguessZ, KguessX)
end

#

 function create_lookup_table(H)
    lookup_table = Dict()
    constraints, bits = size(H)
    # In the case of no errors
    # In the case of single bit errors
    for bit_to_be_flipped in 1:bits
        # Generate e⃗
        error = zeros(Int, bits)
        error[bit_to_be_flipped] = 1
        # Calculate s⃗
        syndrome = (H*error) .% 2
        # Store s⃗ → e⃗
        lookup_table[syndrome] = error
    end
    lookup_table[ zeros(Int, constraints) ] = zeros(Int, bits)
    lookup_table
 end;

 function create_lookup_table(code::Stabilizer)
    lookup_table = Dict()
    constraints, qubits = size(code)
    # In the case of single bit errors
    for bit_to_be_flipped in 1:qubits
        for error_type in [single_x, single_y, single_z]
            # Generate e⃗
            error = error_type(qubits, bit_to_be_flipped)
            # Calculate s⃗
            # (check which stabilizer rows do not commute with the Pauli error)
            syndrome = comm(error, code)
            # Store s⃗ → e⃗
            lookup_table[syndrome] = error
        end
    end
    # In the case of no errors
    lookup_table[ zeros(UInt8, constraints) ] = zero(PauliOperator, qubits)
    lookup_table
 end;

 function create_lookup_table_3_errors(H)
    lookup_table_three = Dict()
    constraints, bits = size(H)
    for num_errors in 1:3  # Looping for 1 to 3 errors
       for error_positions in combinations(1:bits, num_errors)
          error = zeros(Int, bits)
          for pos in error_positions
            error[pos] = 1
          end
          syndrome = (H * error) .% 2
          lookup_table_three[syndrome] = error
       end
    end
    lookup_table_three[zeros(Int, constraints)] = zeros(Int, bits)
    return lookup_table_three
 end

 function decode_using_table_decoder(syndrome, lookup_table)
   if haskey(lookup_table, syndrome)
       return lookup_table[syndrome]
   else
       error("Unknown syndrome encountered.")
   end
 end

 function table_decode(stab, error_rates, name = "", varargs...)
   lookup_table, lt_time1, _ = @timed create_lookup_table(stab)
   post_ec_error_rates = []
   lt_time2 = 0
   if is_degenerate(stab)
      post_ec_error_rates, lt_time2, _ = @timed [evaluate_degen_code_decoder(stab, lookup_table, p) for p in error_rates]
   else
      post_ec_error_rates, lt_time2, _ = @timed [evaluate_code_decoder(stab, lookup_table, p) for p in error_rates]
   end
   lt_time = round(lt_time1 + lt_time2, sigdigits=4)
   return plot_code_performance(error_rates, post_ec_error_rates, title="Lookup table: $name @$lt_time"*"s")
 end

 function belief_decode_X(stab, error_rates, name = "", varargs...)
   ecirc = varargs[1]
   scirc = varargs[2]
   post_ec_error_rates, time, _ = @timed [belief_decoder_eval_X(stab, ecirc, scirc, p) for p in error_rates]
   time = round(time, sigdigits=4)
   f_x = plot_code_performance(error_rates, post_ec_error_rates, title="Belief Decoder X: $name @$time"*"s")
   return f_x
 end

 function belief_decode_Z(stab, error_rates, name = "", varargs...)
   ecirc = varargs[1]
   scirc = varargs[2]
   post_ec_error_rates, time, _ = @timed [belief_decoder_eval_Z(stab, ecirc, scirc, p) for p in error_rates]
   time = round(time, sigdigits=4)
   f_z = plot_code_performance(error_rates, post_ec_error_rates, title="Belief Decoder Z: $name @$time"*"s")
   return f_z
 end

 function is_degenerate(H::Stabilizer, errors) # Described in https://quantumcomputing.stackexchange.com/questions/27279
    syndromes = comm.((H,), errors) # TODO This can be optimized by having something that always returns bitvectors
    return length(Set(syndromes)) != length(errors)
 end

 function is_degenerate(H::Stabilizer, d::Int=1)
    n = nqubits(H)
    errors = [begin p=zero(PauliOperator,n); for i in bits; p[i]=op; end; p end for bits in combinations(1:n, d) for op in ((true,false), (false,true))]
    return is_degenerate(H, errors)
 end

 function evaluate_code_decoder(H,lookup_table,p; samples=100_000)
   constraints, bits = size(H)
   decoded = 0 # Counts correct decodings
   for sample in 1:samples
       error = rand(bits) .< p                    # Generate random error
       syndrome = (H*error) .% 2                  # Apply that error to your physical system and get syndrome
       guess = get(lookup_table,syndrome,nothing) # Decode the syndrome
       if guess==error                            # Check if you were right
           decoded += 1
       end
   end
   return 1- (decoded / samples)
end;

function evaluate_code_decoder(code::Stabilizer,lookup_table,p; samples=100_000)
   constraints, qubits = size(code)
   decoded = 0                                           # Counts correct decodings
   for sample in 1:samples
       error = random_pauli(qubits,p/3,nophase=true)     # Generate random error
    #    println("Error: ", error)
       syndrome = comm(error, code)                      # Apply that error to your physical system and get syndrome
       guess = get(lookup_table,syndrome,nothing)        # Decode the syndrome
       if guess==error                                   # check if you were right
           decoded += 1
       end
   end
   return 1 - (decoded / samples)
end;

function plot_code_performance(error_rates, post_ec_error_rates; samples = 100_000, title="")
   f = Figure(resolution=(500,300))
   resolution = 1 / samples
   ax = f[1,1] = Axis(f, xlabel="single (qu)bit error rate", ylabel="Logical error rate", xscale = log10, yscale = log10, title=title)
   ax.aspect = DataAspect()
   lim = max(error_rates[end],post_ec_error_rates[end])
   lines!([resolution,lim], [resolution,lim], label="single bit", color=:black)
   plot!(error_rates, post_ec_error_rates, label="after decoding", color=:black)
   xlims!(resolution, lim)
   ylims!(resolution, lim)
   f[1,2] = Legend(f, ax, "Error Rates")
   return f
end;

function evaluate_degen_code_decoder(code::Stabilizer,lookup_table,p; samples=100_000)
   constraints, qubits = size(code)
   full_tableau = MixedDestabilizer(code)
   logicals = vcat(logicalxview(full_tableau),logicalzview(full_tableau))
   decoded = 0 # Counts correct decodings
   for sample in 1:samples
       # Generate random error
       error = random_pauli(qubits,p/3,nophase=true)
       # Apply that error to your physical system
       # and get syndrome
       syndrome = comm(error, code)
       # Decode the syndrome
       guess = get(lookup_table,syndrome,nothing)
       # Check if the suggested error correction
       # corrects the error or if it is equivalent
       # to a logical operation
       if !isnothing(guess) && all(==(0x0), comm(guess*error, code)) && all(==(0x0), comm(guess*error, logicals))
           decoded += 1
       end
   end
   return 1 - (decoded / samples)
end;

function belief_decoder_eval_X(checks::Stabilizer, ecirc, scirc, p_error; nframes=100_000, encoding_locs=nothing)
   s, n = size(checks)
   k = n-s

   pcm = stab_to_gf2(checks)
   pcm_X = pcm[1:Int(s/2), 1:n]

   O = faults_matrix(checks)
   circuit_X = Base.copy(scirc)

   # This is a where the bits to be encoded are, ecircs genereated by naive_encoding_circuit() will put those at the bottom
   # Thus, the default is to apply this to the bottom k qubits
   if isnothing(encoding_locs)
       pre_X = [sHadamard(i) for i in n-k+1:n]
   else
       pre_X = [sHadamard(i) for i in encoding_locs]
   end

   md = MixedDestabilizer(checks)
   logview_X = [ logicalxview(md);]
   logcirc_X, _ = naive_syndrome_circuit(logview_X)

  # X logic circuit
   for gate in logcirc_X
       type = typeof(gate)
       if type == sMRZ
           push!(circuit_X, sMRZ(gate.qubit+s, gate.bit+s))
       else
           push!(circuit_X, type(gate.q1, gate.q2+s))
       end
   end

   # X simulation
   errors = [PauliError(i,p_error) for i in 1:n]

   fullcircuit_X = vcat(pre_X, ecirc, errors, circuit_X)
   frames = PauliFrame(nframes, n+s+k, s+k)
   pftrajectories(frames, fullcircuit_X)
   syndromes = pfmeasurements(frames)[:, 1:s]
   logicalSyndromes = pfmeasurements(frames)[:, s+1: s+k]

   decoded = 0
   for i in 1:nframes
       row = syndromes[i,:]

       guess, success = syndrome_decode(sparse(pcm_X), sparse(pcm_X'), row[1:Int(s/2)], 50, fill(p_error, n), zeros(Int(s/2), n), zeros(Int(s/2), n), zeros(n), zeros(n))

       guess = vcat(convert(Vector{Bool}, guess), convert(Vector{Bool}, fill(0, n)))

       if isnothing(guess)
           continue
       else
           result_X = (O * guess)[1:k]
           if result_X == logicalSyndromes[i,:]
               decoded += 1
           end
       end
   end
   x_error = 1 - decoded / nframes

   return x_error
end

function belief_decoder_eval_Z(checks::Stabilizer, ecirc, scirc, p_error; nframes=100_000, encoding_locs=nothing)
   s, n = size(checks)
   k = n-s

   pcm = stab_to_gf2(checks)
   pcm_Z = pcm[Int(s/2) + 1:end, n + 1:end]

   O = faults_matrix(checks)
   circuit_Z = Base.copy(scirc)

   md = MixedDestabilizer(checks)
   logview_Z = [ logicalzview(md);]
   logcirc_Z, numLogBits, _ = naive_syndrome_circuit(logview_Z) # numLogBits shoudl equal k

   # Z logic circuit
   for gate in logcirc_Z
       type = typeof(gate)
       if type == sMRZ
           push!(circuit_Z, sMRZ(gate.qubit+s, gate.bit+s))
       else
           push!(circuit_Z, type(gate.q1, gate.q2+s))
       end
   end

   # Z simulation
   errors = [PauliError(i,p_error) for i in 1:n]

   fullcircuit_Z = vcat(ecirc, errors, circuit_Z)

   frames = PauliFrame(nframes, n+s+k, s+k)
   pftrajectories(frames, fullcircuit_Z)
   syndromes = pfmeasurements(frames)[:, 1:s]
   logicalSyndromes = pfmeasurements(frames)[:, s+1: s+k]

   decoded = 0
   for i in 1:nframes
       row = syndromes[i,:]

       guess, success = syndrome_decode(sparse(pcm_Z), sparse(pcm_Z'), row[Int(s/2)+1:end], 50, fill(p_error, n), zeros(Int(s/2), n), zeros(Int(s/2), n), zeros(n), zeros(n))

       guess = vcat(convert(Vector{Bool}, fill(0, n)), convert(Vector{Bool}, guess))

       if isnothing(guess)
           continue
       else
           result_Z = (O * guess)[k+1:2k]
           if result_Z == logicalSyndromes[i,:]
               if(i == 1)
               end
               decoded += 1
           end
       end
   end
   z_error = 1 - decoded / nframes

   return z_error
end

"""Takes a circuit and adds a pf noise op after each two qubit gate, correspond to the provided fidelity"""
function add_two_qubit_gate_noise(circuit, p_error, noise_func = None)
    new_circuit = []
    for gate in circuit
        if isa(gate, QuantumClifford.AbstractTwoQubitOperator)
            if noise_func == None
                push!(new_circuit, gate)
                push!(new_circuit, PauliError(gate.q1, p_error))
                push!(new_circuit, PauliError(gate.q2, p_error))
            else
                push!(new_circuit, gate)
                push!(new_circuit, noise_func(gate.q1, p_error))
                push!(new_circuit, noise_func(gate.q2, p_error))
            end
        else
            push!(new_circuit, gate)
        end
    end
    return new_circuit
end

end