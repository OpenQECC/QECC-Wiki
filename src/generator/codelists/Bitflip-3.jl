# Steane-7 code

function code_data(c::Bitflip3)
    return Dict(
        "name"=>"Bitflip-3",
        "code"=>c,
        "description" => [
            "The simplest error correcting code that can correct a single bit-flip error.",
            "Unable to correct phase errors.",
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
                "name"=>"Shor-9",
                "link"=>"https://math.mit.edu/~shor/papers/good-codes.pdf",
                "desc"=>"Degenerate CSS code designed to account for parity errors"
            ),
        ],
        "citation" => [
            Dict(
                "doi" => "https://en.wikipedia.org/wiki/Repetition_code",
                "journal" => "Wikipedia",
                "title" => "Repetition code",
            ),

        ],
        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end