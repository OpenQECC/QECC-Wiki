# Steane-7 code

function code_data(c::Example)
    return Dict(
        "name"=>"Example",
        "code"=>c,
        "description" => [
            "Description 1.",
            "Description 2."
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
                "link"=>"https://math.mit.edu/~shor/papers/good-codes.pdf",
                "desc"=>"Degenerate CSS code designed to account for parity errors"
            ),
        ],
        "citation" => [
            Dict(
                "author" => "Joe Smith",
                "link" => "10.1098/rspa.1996.0136",
                "journal" => "Wikipedia",
                "title" => "Helmsdale",
            ),

        ],
        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end