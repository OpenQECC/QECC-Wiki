module Shor_Syndrom_Eval

 export create_lookup_table, evaluate_code_decoder_shor_syndrome, ss_encoding_plot

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
 
 """Evaluates a decoder for shor style syndrome circuit"""
 function evaluate_code_decoder_shor_syndrome(checks::Stabilizer, ecirc, cat, scirc, p_init, p_shift=0, p_wait=0 ; nframes=10_000, encoding_locs=nothing)   
     lookup_table = create_lookup_table(checks)
     O = faults_matrix(checks)
     circuit_Z = Base.copy(scirc)
     circuit_X = Base.copy(scirc)
 
     s, n = size(checks)
     k = n-s
 
     if isnothing(encoding_locs)
         pre_X = [sHadamard(i) for i in n-k+1:n]
     else
         pre_X = [sHadamard(i) for i in encoding_locs]
     end 
         
     anc_qubits = 0 
     for pauli in checks
         anc_qubits += mapreduce(count_ones,+, xview(pauli) .| zview(pauli))
     end
     # Here anc_qubits is now equal to the # of anc qubits in scirc
     regbits = anc_qubits + s
 
     if p_shift != 0       
         non_mz, mz = clifford_grouper(scirc)
         non_mz = calculate_shifts(non_mz)
         circuit_X = []
         circuit_Z = []
 
         first_shift = true
         for subcircuit in non_mz
             # Shift!
             if !first_shift
                 # Errors due to shifting the data/ancilla row - whichever is smallest 
                 # TODO right now hardcoded to shift the data qubits.
                 #append!(circuit_X, [PauliError(i,p_shift) for i in n+1:n+anc_qubits])
                 #append!(circuit_Z, [PauliError(i,p_shift) for i in n+1:n+anc_qubits])
                 append!(circuit_X, [PauliError(i,p_shift) for i in 1:n])
                 append!(circuit_Z, [PauliError(i,p_shift) for i in 1:n])
             end
             append!(circuit_Z, subcircuit)
             append!(circuit_X, subcircuit)
             first_shift = false
 
             # Errors due to waiting for the next shuttle -> should this be on all qubits? Maybe the p_shift includes this for ancilla already?
             # TODO Should this be random Pauli error or just Z error?
             #append!(circuit_X, [PauliError(i,p_wait) for i in 1:n])
             #append!(circuit_Z, [PauliError(i,p_wait) for i in 1:n])
             append!(circuit_X, [PauliError(i,p_wait) for i in n+1:n+anc_qubits])
             append!(circuit_Z, [PauliError(i,p_wait) for i in n+1:n+anc_qubits])
         end
         append!(circuit_X, mz)
         append!(circuit_Z, mz)
     end
 
     # TODO make these logical circuits also shor style?
     md = MixedDestabilizer(checks)
     logview_Z = [ logicalzview(md);]
     logcirc_Z, _ = naive_syndrome_circuit(logview_Z)
 
     logview_X = [ logicalxview(md);]
     logcirc_X, _ = naive_syndrome_circuit(logview_X)
     
     # Z logic circuit
     for gate in logcirc_Z
         type = typeof(gate)
         if type == sMRZ
             push!(circuit_Z, sMRZ(gate.qubit+anc_qubits, gate.bit+regbits))
         else 
             push!(circuit_Z, type(gate.q1, gate.q2+anc_qubits))
         end
     end
 
    # X logic circuit
     for gate in logcirc_X
         type = typeof(gate)
         if type == sMRZ
             push!(circuit_X, sMRZ(gate.qubit+anc_qubits, gate.bit+regbits))
         else 
             push!(circuit_X, type(gate.q1, gate.q2+anc_qubits))
         end
     end
 
     # Z simulation
     errors = [PauliError(i,p_init) for i in 1:n]
     fullcircuit_Z = vcat(ecirc, errors, cat, circuit_Z)
 
     frames = PauliFrame(nframes, n+anc_qubits+k, regbits+k)
     pftrajectories(frames, fullcircuit_Z)
     syndromes = pfmeasurements(frames)[:, anc_qubits+1:regbits]
     logicalSyndromes = pfmeasurements(frames)[:, regbits+1:regbits+k]
 
     decoded = 0
     for i in 1:nframes
         row = syndromes[i,:]
         guess = get(lookup_table,row,nothing)
         if isnothing(guess)
             continue
         else
             result_Z = (O * stab_to_gf2(guess))[k+1:2k]
             if result_Z == logicalSyndromes[i,:]
                 decoded += 1
             end
         end
     end
     z_error = 1 - decoded / nframes
     
     # X simulation
     fullcircuit_X = vcat(pre_X, ecirc, errors, cat, circuit_X)
     frames = PauliFrame(nframes, n+anc_qubits+k, regbits+k)
     pftrajectories(frames, fullcircuit_X)
     syndromes = pfmeasurements(frames)[:, anc_qubits+1:regbits]
     logicalSyndromes = pfmeasurements(frames)[:, regbits+1:regbits+k]
 
     decoded = 0
     for i in 1:nframes
         row = syndromes[i,:]
         guess = get(lookup_table,row,nothing)
         if isnothing(guess)
             continue
         else
             result_X = (O * stab_to_gf2(guess))[1:k]
             if result_X == logicalSyndromes[i, :]
                 decoded += 1   
             end
         end
     end
     x_error = 1 - decoded / nframes
     
     return x_error, z_error
 end

 function ss_encoding_plot(code::AbstractECC, name=string(typeof(code)))
     checks = parity_checks(code)
     ss_encoding_plot(checks, name)
 end
 function ss_encoding_plot(checks, error_rates, name="")
     (scirc, _), time1, _ = @timed shor_syndrome_circuit(checks)
     ecirc, time2, _ = @timed naive_encoding_circuit(checks)
    #  a = @timed naive_encoding_circuit(checks)
    #  println(a)
    #  println(ecirc)
    #  println(time2)

    #  error_rates = 0.025:0.0025:0.2
     post_ec_error_rates, time3, _ = @timed [evaluate_code_decoder_shor_syndrome(checks, ecirc, scirc, p) for p in error_rates]
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



"""Table decoder code"""
using QuantumClifford
using Combinatorics: combinations




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
end