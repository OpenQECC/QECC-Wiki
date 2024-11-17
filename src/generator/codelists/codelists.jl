module CodeLists

using QuantumClifford.ECC: Steane7, Shor9, parity_checks, code_n, code_s, code_k, Bitflip3, Cleve8, Toric

function code_data end

include("./Steane-7.jl")
include("./Shor-9.jl")
include("./Bitflip-3.jl")
include("./Cleve-8.jl")
include("./Toric.jl")

end
