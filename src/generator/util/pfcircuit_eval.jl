module PauliFrame_Eval

 export create_lookup_table, evaluate_code_decoder_w_ecirc_pf, pf_encoding_plot

 include("QECC_plotters.jl")

 using .QECC_Plotters: plot_code_performance
 
 using CairoMakie, SparseArrays, LDPCDecoders
 using QuantumClifford: Stabilizer, MixedDestabilizer, sHadamard, logicalxview, logicalzview, sMRZ, PauliError, pftrajectories, pfmeasurements, stab_to_gf2, PauliFrame, PauliError
 using QuantumClifford.ECC: faults_matrix, naive_syndrome_circuit, parity_checks, AbstractECC, naive_encoding_circuit, Cleve8, Steane7, Shor9, Perfect5
 
 """Generate a lookup table for decoding single qubit errors. Maps s⃗ → e⃗."""
 function create_lookup_table(code::Stabilizer)
     lookup_table = Dict()
     constraints, qubits = size(code)
     # In the case of no errors
     lookup_table[ zeros(UInt8, constraints) ] = zero(PauliOperator, qubits)
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
     lookup_table
 end
 
 """Currently uses a 1 qubit lookup table decoder. Assumes scirc is generated with naive_syndrome_circuit - I have a different function for fault tolerant syndromes circuits"""
 function evaluate_code_decoder_w_ecirc_pf(checks::Stabilizer, ecirc, scirc, p_error; nframes=100_000, encoding_locs=nothing)
     s, n = size(checks)
     k = n-s
 
     pcm = stab_to_gf2(checks)
     pcm_X = pcm[1:Int(s/2), 1:n]
     pcm_Z = pcm[Int(s/2) + 1:end, n + 1:end]
 
     O = faults_matrix(checks)
     circuit_Z = Base.copy(scirc)
     circuit_X = Base.copy(scirc)
 
     # This is a where the bits to be encoded are, ecircs genereated by naive_encoding_circuit() will put those at the bottom
     # Thus, the default is to apply this to the bottom k qubits
     if isnothing(encoding_locs)
         pre_X = [sHadamard(i) for i in n-k+1:n]
     else
         pre_X = [sHadamard(i) for i in encoding_locs]
     end     
 
     md = MixedDestabilizer(checks)
     logview_Z = [ logicalzview(md);]
     logcirc_Z, numLogBits, _ = naive_syndrome_circuit(logview_Z) # numLogBits shoudl equal k
 
     logview_X = [ logicalxview(md);]
     logcirc_X, _ = naive_syndrome_circuit(logview_X)
     
     # Z logic circuit
     for gate in logcirc_Z
         type = typeof(gate)
         if type == sMRZ
             push!(circuit_Z, sMRZ(gate.qubit+s, gate.bit+s))
         else 
             push!(circuit_Z, type(gate.q1, gate.q2+s))
         end
     end
 
    # X logic circuit
     for gate in logcirc_X
         type = typeof(gate)
         if type == sMRZ
             push!(circuit_X, sMRZ(gate.qubit+s, gate.bit+s))
         else 
             push!(circuit_X, type(gate.q1, gate.q2+s))
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
     
     # X simulation
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
 
     return x_error, z_error
 end
 
 function pf_encoding_plot(code::AbstractECC, name=string(typeof(code)))
     checks = parity_checks(code)
     pf_encoding_plot(checks, name)
 end
 function pf_encoding_plot(checks, error_rates, name="")
     (scirc, _), time1, _ = @timed naive_syndrome_circuit(checks)
    #  a = @timed naive_syndrome_circuit(checks)
    #  println(a)
    #  println(scirc)
    #  println(time1)
     ecirc, time2, _ = @timed naive_encoding_circuit(checks)
    #  a = @timed naive_encoding_circuit(checks)
    #  println(a)
    #  println(ecirc)
    #  println(time2)

    #  error_rates = 0.025:0.0025:0.2
     post_ec_error_rates, time3, _ = @timed [evaluate_code_decoder_w_ecirc_pf(checks, ecirc, scirc, p) for p in error_rates]
    #  println(time3)
     
     total_time = round(time1 + time2 + time3, sigdigits=4)

     x_error = [post_ec_error_rates[i][1] for i in eachindex(post_ec_error_rates)]
     z_error = [post_ec_error_rates[i][2] for i in eachindex(post_ec_error_rates)]
    #  a_error = (x_error + z_error) / 2
 
     f_x = plot_code_performance(error_rates, x_error,title=""*name*": Belief Decoder X @$total_time"*"s")
     f_z = plot_code_performance(error_rates, z_error,title=""*name*": Belief Decoder Z @$total_time"*"s")
    #  f_a = plot_code_performance(error_rates, a_error,title=""*name*": Belief Decoder @$total_time"*"s")
 
     return f_x, f_z, total_time
 end
 
#  f_x_Steane, f_z_Steane = pf_encoding_plot(Steane7())
 # f_x_Shor, f_z_Shor = pf_encoding_plot(Shor9())
 # f_x_Cleve, f_z_Cleve = pf_encoding_plot(Cleve8())
 # f_x_Perfect5, f_z_Perfect5 = pf_encoding_plot(Perfect5())

end