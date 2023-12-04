using QuantumClifford
using QuantumClifford.ECC
 using QuantumClifford: Tableau
using Quantikz
using CairoMakie
include("./util/QECC_converter.jl")
using .QECC_Converter
include("./util/QECC_decoders.jl")
using .QECC_Decoders
include("./util/QECC_pageGeneration.jl")
using .QECC_pageGeneration

codes = ["Bicycle", "Steane-7"]
decoders = ["tableDecode", "beliefDecodeX", "beliefDecodeZ"]
encoding_circuits = ["naive_encoding_circuit"]
syndrome_circuits = ["naive_syndrome_circuit"]

for code in codes
    genPage(code, decoders, encoding_circuits, syndrome_circuits)
end