# Bicycle code

code = Dict(
    "name"=>"Bicycle",
    "description" => [
        "This is a test code",
        "Description 1",
        "Description 2",
        "Description 3"
    ],
    "example" => Dict(
        # "codestring"=>"XX_X___X___X_X
        # _XX_X__XX___X_
        # __XX_X__XX___X
        # ___XX_XX_XX___
        # X___XX__X_XX__
        # _X___XX__X_XX_",

        "codestring"=>"XX_XX_X
        X__XXX_
        ZZ_ZZ_Z
        Z__ZZZ_"
    ),
    "benchmark" => Dict(
        "error_rates"=>0.000:0.005:0.09,
    ),
    "similar" => [
        Dict(
            "name"=>"",
            "link"=>"",
            "desc"=>""
        ),
        Dict(
            "name"=>"",
            "link"=>"",
            "desc"=>""
        ),
    ],
    "citation" => [
        Dict(
            "author" => "",
            "doi" => "",
            "journal" => "",
            "title" => "", 
        ),

    ],

    "simulation"=>"", # link to simulation
    "replot" => true, # set to false if regenrating plot is unnecessary in the next run


)
