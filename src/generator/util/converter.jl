module converter

export binaryToStabilizer, stabilizerStringToTableau

 using QuantumClifford
 using QuantumClifford: Tableau
 using QuantumClifford.ECC
 
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
             
             for i in eachindex(X_new)
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
 
 
 
 function stabilizerStringToTableau(stabilizer_str::String)
     # Define the mapping for Pauli operators to [phase, x, z]
     pauli_mapping = Dict(
         '_' => (0, false, false),
         'I' => (0, false, false),
         'X' => (0, true,  false),
         'Y' => (3, true,  true),
         'Z' => (0, false, true)
     )
     
     stabilizer_str = join(split(stabilizer_str, ' '))
     str_arrs = split(stabilizer_str, '\n')
     cols = length(str_arrs[1])
     rows = length(str_arrs)
     phases = convert(Array{UInt8}, zeros(rows))
     xm = Matrix{Bool}(undef, rows, cols)
     zm = Matrix{Bool}(undef, rows, cols)
     for i in eachindex(str_arrs)
        str = str_arrs[i]
        for j in eachindex(str)
            phase, xm[i, j], zm[i, j] = pauli_mapping[str[j]]
            phases[i] += phase
        end
        phases[i] = phases[i]%4
     end
    #  println("phases: ", phases, " type: ", typeof(phases))
    #  println("xs_matrix: ", xm, " type: ", typeof(xm))
    #  println("zs_matrix: ", zm, " type: ", typeof(zm))
    #  return 0
    #  return Tableau(phases, xs_matrix, zs_matrix)
    return Tableau(phases, xm, zm)
 end

 # Example usage:
#  stabilizer_str = 
#  "XYZI
#  ZZYY
#  XIXI
#  IIII
#  ZZZZ
#  XXXX
#  YYYY"
#  tableau_obj = stabilizerStringToTableau(stabilizer_str)
#  println(tableau_obj)

end