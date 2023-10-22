module QECC_plotters

export plot_code_performance

using QuantumClifford, QuantumClifford.ECC

 function evaluate_code_decoder(H,lookup_table,p; samples=10_000)
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
     return 1 - decoded / samples
 end;

 function evaluate_code_decoder(code::Stabilizer,lookup_table,p; samples=10_000)
     constraints, qubits = size(code)
     decoded = 0 # Counts correct decodings
     for sample in 1:samples
         # Generate random error
         error = random_pauli(qubits,p/3,nophase=true)
         # Apply that error to your physical system
         # and get syndrome
         syndrome = comm(error, code)
         # Decode the syndrome
         guess = get(lookup_table,syndrome,nothing)
         # check if you were right
         if guess==error
             decoded += 1
         end
     end
     return 1 - decoded / samples
 end;
 
 function plot_code_performance(error_rates, post_ec_error_rates; title="")
     f = Figure(resolution=(500,300))
     ax = f[1,1] = Axis(f, xlabel="single (qu)bit error rate",title=title)
     ax.aspect = DataAspect()
     lim = max(error_rates[end],post_ec_error_rates[end])
     lines!([0,lim], [0,lim], label="single bit", color=:black)
     plot!(error_rates, post_ec_error_rates, label="after decoding", color=:black)
     xlims!(0,lim)
     ylims!(0,lim)
     f[1,2] = Legend(f, ax, "Error Rates")
     return f
 end;

 function evaluate_degen_code_decoder(code::Stabilizer,lookup_table,p; samples=10_000)
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
     1 - decoded / samples
 end;

end