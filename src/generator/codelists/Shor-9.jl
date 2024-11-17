function code_data(c::Shor9)
    return Dict(
        "name"=>"Shor-9",
        "code"=>c,
        "description" => [
            "Nine-qubit CSS code that is the first quantum error-correcting code."
        ],
        "parity_checks" => Dict(
            "stab"=>parity_checks(c),
            "code_n"=>code_n(c),
            "code_s"=>code_s(c),
            "code_k"=>code_k(c),
        ),
        "benchmark" => Dict(
            "decoders"=>[:TableDecoder, :BeliefPropDecoder, :PyMatchingDecoder],
            "setups"=>[:NaiveSyndromeECCSetup, :ShorSyndromeECCSetup],
            "error_rates"=>(-5:0.1:-1.0),
            "nsamples"=>100_000,
        ),
        "similar" => [
            Dict(
                "name"=>"Steane-7",
                "link"=>"./Steane7.md",
                "desc"=>"short desc"
            ),
            Dict(
                "name"=>"Surface Code",
                "link"=>"https://www.nature.com/articles/s41586-022-05434-1",
                "desc"=>"This is a surface code hehe"
            ),
        ],
        "citation" => [
            Dict(
                "author" => "Nathanan Tantivasadakarn and Ruben Verresen and Ashvin Vishwanath",
                "doi" => "10.1103/PhysRevLett.131.060405",
                "journal" => "Physical Review Letters",
                "title" => "Shortest Route to Non-Abelian Topological Order on a Quantum Processor",
            ),

        ],

        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end