using QuantumClifford
module converter

function binaryToStabilizer(file_path::String)::String
    file = open(file_path, "r")

    stab_str = ""

    try
        lines = readlines(file)
        
        for line in lines
            parts = split(line, "|")
            Xstring = replace(parts[1][2:end], " " => "")
            Zstring = replace(parts[2][1:end-1], " " => "")
            X = collect(Xstring)
            Z = collect(Zstring)
            X_new = [parse(Int, s) for s in X]
            Z_new = [parse(Int, s) for s in Z]
            
            for i in 1:length(X_new)
                if X_new[i] == 1 && Z_new[i] == 1
                    stab_str = stab_str*'Y'
                elseif X_new[i] == 1 && Z_new[i] == 0
                    stab_str = stab_str*'X'
                elseif X_new[i] == 0 && Z_new[i] == 1
                    stab_str = stab_str*'Z'
                elseif X_new[i] == 0 && Z_new[i] == 0
                    stab_str = stab_str*'_'
                end
            end
            stab_str = stab_str*'\n'
        end
    finally
        close(file)
    end

    return stab_str
end



function stabilizerStringToTableau(stabilizer_str::String)::Tableau
    # Define the mapping for Pauli operators to [phase, x, z]
    pauli_mapping = Dict(
        'I' => ('+', false, false),
        'X' => ('+', true,  false),
        'Y' => ('-', true,  true),
        'Z' => ('+', false, true)
    )
    
    phases = UInt8[]
    xs = Bool[]
    zs = Bool[]
    
    for char in stabilizer_str
        phase, x, z = pauli_mapping[char]
        
        # Convert phase from char to UInt8 (0 for '+', 1 for '-')
        push!(phases, phase == '+' ? UInt8(0) : UInt8(1))
        
        push!(xs, x)
        push!(zs, z)
    end
    
    # Convert arrays to desired format for Tableau
    xs_matrix = reshape(xs, 1, length(xs))
    zs_matrix = reshape(zs, 1, length(zs))

    # Create and return the Tableau
    return Tableau(phases, xs_matrix, zs_matrix)
end

# Example usage:
stabilizer_str = "XYZI"
tableau_obj = stabilizerStringToTableau(stabilizer_str)
println(tableau_obj)


end