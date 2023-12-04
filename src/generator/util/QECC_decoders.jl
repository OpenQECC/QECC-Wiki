module QECC_Decoders

export create_lookup_table, is_degenerate, create_lookup_table_3_errors, tableDecode, beliefDecodeX, beliefDecodeZ

using QuantumClifford, QuantumClifford.ECC, CairoMakie, SparseArrays, LDPCDecoders
using Combinatorics: combinations

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

 function tableDecode(stab, error_rates, name = "", varargs...)
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

 function beliefDecodeX(stab, error_rates, name = "", varargs...)
   ecirc = varargs[1]
   scirc = varargs[2]
   post_ec_error_rates, time, _ = @timed [beliefDecoderEvalX(stab, ecirc, scirc, p) for p in error_rates]
   time = round(time, sigdigits=4)
   f_x = plot_code_performance(error_rates, post_ec_error_rates, title="Belief Decoder X: $name @$time"*"s")
   return f_x
 end

 function beliefDecodeZ(stab, error_rates, name = "", varargs...)
   ecirc = varargs[1]
   scirc = varargs[2]
   post_ec_error_rates, time, _ = @timed [beliefDecoderEvalZ(stab, ecirc, scirc, p) for p in error_rates]
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

function plot_code_performance(error_rates, post_ec_error_rates; title="")
   f = Figure(resolution=(500,300))
   ax = f[1,1] = Axis(f, xlabel="single (qu)bit error rate", ylabel="Logical error rate", xscale = log10, yscale = log10, title=title)
   ax.aspect = DataAspect()
   lim = max(error_rates[end],post_ec_error_rates[end])
   lines!([0.00001,lim], [0.00001,lim], label="single bit", color=:black)
   plot!(error_rates, post_ec_error_rates, label="after decoding", color=:black)
   xlims!(0.00001, lim)
   ylims!(0.00001, lim)
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

function beliefDecoderEvalX(checks::Stabilizer, ecirc, scirc, p_error; nframes=100_000, encoding_locs=nothing)
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

function beliefDecoderEvalZ(checks::Stabilizer, ecirc, scirc, p_error; nframes=100_000, encoding_locs=nothing)
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

end