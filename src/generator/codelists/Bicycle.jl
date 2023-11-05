# Bicycle code

code = Dict(
    "name"=>"Bicycle",
    "description" => [
        "This LDPC code is based on circulant matrices of difference sets.",
        "The difference should satisfy the property that each every difference (modulo N/2) in the set occurs at most once",
        "This is a CSS code where each sub-matrix is constructed from the circulant and it's transpose horizontally contatinated. This sub-matrix then has some of it's rows removed while trying to keep the number of checks per column the same.",
    ],
    "example" => Dict(
        # "codestring"=>"XX_X___X___X_X
        # _XX_X__XX___X_
        # __XX_X__XX___X
        # ___XX_XX_XX___
        # X___XX__X_XX__
        # _X___XX__X_XX_",

        # "codestring"=>"XX_XX_
        # X__XXX
        # ZZ_ZZ_
        # Z__ZZZ"


        "codestring"=>"_XX_XX__
        __XX_XX_
        X__X__XX
        _ZZ_ZZ__
        __ZZ_ZZ_
        Z__Z__ZZ"
    ),
    "benchmark" => Dict(
        "error_rates"=>(-5:0.1:-1.0),
    ),
    "similar" => [
        Dict(
            "name"=>"Unicycle Codes",
            "link"=>"https://arxiv.org/abs/quant-ph/0304161",
            "desc"=>"Circulant code based on perfect difference sets"
        ),
    ],
    "citation" => [
        Dict(
            "author" => "David J.C. MacKay, Graeme Mitchison, Paul L. McFadden",
            "doi" => "10.1109/TIT.2004.834737",
            "journal" => "IEEE Transactions on Information Theory, Vol. 50, No. 10, p. 2315 (2004)",
            "title" => "Sparse Graph Codes for Quantum Error-Correction", 
        ),

    ],

    "simulation"=>"", # link to simulation
    "replot" => true, # set to false if regenrating plot is unnecessary in the next run


)
