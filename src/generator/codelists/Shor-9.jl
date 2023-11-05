code = Dict(
    "name"=>"Shor9",
    "description" => [
        "Nine-qubit CSS code that is the first quantum error-correcting code."
    ],
    "example" => Dict(
        "codestring"=>"ZZ_______
        _ZZ______
        ___ZZ____
        ____ZZ___
        ______ZZ_
        _______ZZ
        XXXXXX___
        ___XXXXXX"
        # "codestring"=>"___XXXX
        # _XX__XX
        # X_X_X_X
        # ___ZZZZ
        # _ZZ__ZZ
        # Z_Z_Z_Z"
        # leaving room for future example additions
    ),
    "benchmark" => Dict(
        "error_rates"=>0.005:0.005:0.09,
    ),
    "similar" => [
        Dict(
            "name"=>"sample name",
            "link"=>"sample link",
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
    "replot" => true, # set to false if regenrating plot is unnecessary in the next run
)