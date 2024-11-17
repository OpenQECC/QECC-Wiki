using QuantumClifford
using QuantumClifford.ECC
 using QuantumClifford: Tableau
using Quantikz
using CairoMakie
include("./util/QECC_converter.jl")
using .QECC_Converter
include("./util/QECC_pageGeneration.jl")
using .QECC_pageGeneration

codes = [Toric(4, 4)]

for code in codes
    genPage(code)
end

# Decoders = [:TableDecoder, :BeliefPropDecoder, :PyMatchingDecoder, :BitFlipDecoder, :PyBeliefPropDecoder, :PyBeliefPropOSDecoder]