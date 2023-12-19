# Stean-7 code

# change to code_steane7
code = Dict(
    "name"=>"Steane-7",
    "description" => [
        "The Steane code is a quantum error-correcting code that encodes a single logical qubit into seven physical qubits.",
        "This code is designed to correct for any single qubit error, which includes both bit-flip (analogous to classical bit errors) and phase-flip (a uniquely quantum error) errors."
    ],
    "example" => Dict(
        # "codestring"=>"ZZZ_____
        # ___ZZZ__
        # _Z_Z__Z_
        # __Z__Z_Z
        # XXX_____
        # ___XXX__
        # _X_X__X_
        # __X__X_X"

        # Change dict entries to Symbols (e.x.: :codestring )
        "codestring"=>"___XXXX
        _XX__XX
        X_X_X_X
        ___ZZZZ
        _ZZ__ZZ
        Z_Z_Z_Z"

    ),
    "benchmark" => Dict(
        "error_rates"=>(-5:0.1:-1.0),
        "logical_error_rates"=>(-3:0.1:-3)
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
            "author" => "Andrew Steane",
            "doi" => "10.1098/rspa.1996.0136",
            "journal" => "Proc.Roy.Soc.Lond. A452 (1996) 2551",
            "title" => "Multiple Particle Interference and Quantum Error Correction",
        ),

    ],
    "replot" => true, # set to false if regenrating plot is unnecessary in the next run
)

codemetadata(::Type{Steane7}) = code_steane7
