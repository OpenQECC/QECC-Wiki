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
 
 function generate_openQasm_file(stabilizer_str::String, file_path::String)
    ccir = QuantumClifford.ECC.naive_encoding_circuit(stabilizer_str)

    num_ancila = length(stabilizer_str)
    num_qubits = length(stabilizer_str[1])

    qasm_code = """
    OPENQASM 2.0;
    include "qelib1.inc";

    qreg q[$num_qubits];
    creg c[$num_ancila];
    """

    for elem in ccir
        # println(typeof(elem))
        if typeof(elem) == sHadamard
            q1 = elem.q-1
            qasm_code = qasm_code*"\nh q[$q1];"
        elseif typeof(elem) == sZCX || typeof(elem) == sCNOT
            # cNOT gate
            q1 = elem.q1-1
            q2 = elem.q2-1
            qasm_code = qasm_code*"\ncx q[$q1], q[$q2];"
        elseif typeof(elem) == sZCY
            q1 = elem.q1-1
            q2 = elem.q2-1
            qasm_code = qasm_code*"\ncy q[$q1], q[$q2];"
        elseif typeof(elem) == sZCZ
            q1 = elem.q1-1
            q2 = elem.q2-1
            qasm_code = qasm_code*"\ncz q[$q1], q[$q2];"
        elseif typeof(elem) == sX
            q1 = elem.q-1
            qasm_code = qasm_code*"\nx q[$q1];"
        elseif typeof(elem) == sY
            q1 = elem.q-1
            qasm_code = qasm_code*"\ny q[$q1];"
        elseif typeof(elem) == sZ
            q1 = elem.q-1
            qasm_code = qasm_code*"\nz q[$q1];"
        elseif typeof(elem) == sPhase
            q1 = elem.q-1
            qasm_code = qasm_code*"\ns q[$q1];"
        end
    end

    # Open the file for writing (creates the file if it doesn't exist)
    open(file_path, "w") do file
        write(file, qasm_code_1)
    end
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