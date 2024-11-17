# Steane-7 code

function code_data(c::Cleve8)
    return Dict(
        "name"=>"Cleve-8",
        "code"=>c,
        "description" => [
            "Quantum error correcting code that encodes 3 logical qubits into 8 logical qubits.",
            "Description 2."
        ],
        "parity_checks" => Dict(
            "stab"=>parity_checks(c),
            "code_n"=>code_n(c),
            "code_s"=>code_s(c),
            "code_k"=>code_k(c),
        ),
        "benchmark" => Dict(
            "decoders"=>[:TableDecoder],
            "setups"=>[:NaiveSyndromeECCSetup],
            "error_rates"=>(-5:0.1:-1.0),
            "nsamples"=>100_000,
        ),
        "similar" => [
            Dict(
                "name"=>"Steane-7",
                "link"=>"./Steane7.md",
                "desc"=>"CSS code, capable of correcting single-bit errors"
            ),
            Dict(
                "name"=>"Shor-9",
                "link"=>"./Shor.md",
                "desc"=>"Degenerate CSS code designed to account for parity errors"
            ),
        ],
        "citation" => [
            Dict(
                "author" => "Cerf, N. and Cleve, R.",
                "Link" => "https://royalsocietypublishing.org/doi/10.1098/rspa.1998.0160",
                "journal" => "Proc R Soc A",
                "title" => "Information-theoretic interpretation of quantum error-correcting codes",
            ),

        ],
        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end