module QECC_Decoders

export create_lookup_table, is_degenerate

using QuantumClifford
using Combinatorics: combinations

 function create_lookup_table(H)
    lookup_table = Dict()
    constraints, bits = size(H)
    # In the case of no errors
    lookup_table[ zeros(Int, constraints) ] = zeros(Int, bits)
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
    lookup_table
 end;

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
 end;

 function is_degenerate(H::Stabilizer, errors) # Described in https://quantumcomputing.stackexchange.com/questions/27279
    syndromes = comm.((H,), errors) # TODO This can be optimized by having something that always returns bitvectors
    return length(Set(syndromes)) != length(errors)
 end

 function is_degenerate(H::Stabilizer, d::Int=1)
    n = nqubits(H)
    errors = [begin p=zero(PauliOperator,n); for i in bits; p[i]=op; end; p end for bits in combinations(1:n, d) for op in ((true,false), (false,true))]
    return is_degenerate(H, errors)
 end

end