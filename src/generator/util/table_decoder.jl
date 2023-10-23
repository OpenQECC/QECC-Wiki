using DataStructures
using Combinatorics


function create_lookup_table_3_errors(H)
    lookup_table_three = Dict()
    constraints, bits = size(H)
    
    lookup_table_three[zeros(Int, constraints)] = zeros(Int, bits)

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
    
    return lookup_table_three
end

function decode_using_table_decoder(syndrome, lookup_table)
    if haskey(lookup_table, syndrome)
        return lookup_table[syndrome]
    else
        error("Unknown syndrome encountered.")
    end
end

lookup_table_three = create_lookup_table_3_errors(H)

# Sample syndrome
measured_syndrome = [1, 0, 0]

decoded_error = decode_using_lookup_table(measured_syndrome, lookup_table_three)
println(decoded_error)
