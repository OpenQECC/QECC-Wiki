# Steane-7 code

function code_data(c::Toric)
    return Dict(
        "name"=>"Toric",
        "code"=>c,
        "description" => [
            "Toric codes, a generalization of the topological surface codes where the X and Z checks depends opon the spatial location of the qubits.",
            "In a grid with qubits at every midpoint between vertices, X checks are done between the 4 qubits neighboring a vertex, and Z checks are done between the 4 qubits around a grid square."
        ],
        "parity_checks" => Dict(
            "stab"=>parity_checks(c),
            "code_n"=>code_n(c),
            "code_s"=>code_s(c),
            "code_k"=>code_k(c),
        ),
        "benchmark" => Dict(
            "decoders"=>[:TableDecoder, :BeliefPropDecoder, :PyMatchingDecoder, :BitFlipDecoder, :PyBeliefPropDecoder],
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
            Dict(
                "name"=>"Surface Code",
                "link"=>"https://www.nature.com/articles/s41586-022-05434-1",
                "desc"=>"This is a surface code hehe"
            ),
        ],
        "citation" => [
            Dict(
                "author" => "A. Y. Kitaev",
                "link" => "https://www.mathnet.ru/php/archive.phtml?wshow=paper&jrnid=rm&paperid=892&option_lang=eng",
                "journal" => "Russian Mathematical Surveys 52, 1191 (1997)",
                "title" => "Quantum computations: algorithms and error correction",
            ),

        ],
        "simulation"=>"", # link to simulation
        "replot" => true, # set to false if regenerating plot is unnecessary in the next run
    )
end