# Steane-7 code

function code_data(c::Steane7)
    return Dict(
        "name"=>"Steane-7",
        "code"=>c,
        "description" => [
            "The Steane code is a quantum error-correcting code that encodes a single logical qubit into seven physical qubits.",
            "This code is designed to correct for any single qubit error, which includes both bit-flip (analogous to classical bit errors) and phase-flip (a uniquely quantum error) errors.",
            "[Error correction zoo: Steane 7](https://errorcorrectionzoo.org/c/steane)"
        ],
        "parity_checks" => Dict(
            "stab"=>parity_checks(c),
            "code_n"=>code_n(c),
            "code_s"=>code_s(c),
            "code_k"=>code_k(c),
        ),
        "benchmark" => Dict(
            "decoders"=>[:TableDecoder, :BeliefPropDecoder],
            "setups"=>[:NaiveSyndromeECCSetup],
            "error_rates"=>(-5:0.1:-1.0),
            "nsamples"=>100_000,
        ),
        "similar" => [
            Dict(
                "name"=>"Shor-9",
                "link"=>"./Shor-9.md",
                "desc"=>"Degenerate CSS code -- first to correct all error types"
            ),
        ],
        "citation" => [
            Dict(
                "author" => "Andrew Steane",
                "doi" => "10.1098/rspa.1996.0136",
                "journal" => "Proc.Roy.Soc.Lond. A452 (1996) 2551",
                "title" => "Multiple Particle Interference and Quantum Error Correction",
            ),
        ],

        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end