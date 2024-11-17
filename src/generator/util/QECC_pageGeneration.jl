module QECC_pageGeneration

export genPage

using QuantumClifford
using QuantumClifford.ECC: evaluate_decoder, TableDecoder, code_n, code_s, code_k, naive_syndrome_circuit, isdegenerate, parity_checks, naive_encoding_circuit
using Quantikz
using CairoMakie
using LDPCDecoders
using PyQDecoders

include("./QECC_converter.jl")
using .QECC_Converter

# include("QECC_decoders.jl")
# using .QECC_Decoders

include("./../codelists/codelists.jl")
using .CodeLists: code_data

function genTitle(code)
    n = code["name"]
    return  "# $n"
end

function genDescribe(code)
    try
        result = vcat(["Description"], code["description"])
        return join(result, "\n - ")
    catch e
        error("Error parsing config object description: $e")
    end
    return ""
end

function genExample(code)
    result = ["Example"]
    try
        code_name = code["name"]
        stab = code["parity_checks"]["stab"]
        n = code_n(stab)
        k = code_k(stab)

        push!(result, "- Number of qubits: N = $n")
        push!(result, "- Number of encoded bits: k = $k")
        if isdegenerate(stab)
            push!(result, "- The $code_name code is degenerate!")
        else
            push!(result, "- The $code_name code is not degenerate.")
        end
        push!(result, "")

        # Insert Markdown tags
        push!(result, "<details><summary><h3>Code Tableau</h3></summary>")
        push!(result, "")
        push!(result, "```")
        push!(result, string(stab))
        push!(result, "```")
        push!(result, "</details>")
        push!(result, "")

        if code["replot"] && (code["parity_checks"]["code_n"] < 10)
            image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\codeplots\\")

            # Generate and save encoding circuit img
            encoding_circuit = naive_encoding_circuit(stab);
            savecircuit(encoding_circuit, image_dir * "$code_name-encoding_circuit.png")
            
            push!(result, "")
            
            # Generate and save syndrome circuit img
            syndrome_circuit, anc, - = naive_syndrome_circuit(stab);
            savecircuit(syndrome_circuit, image_dir * "$code_name-syndrome_circuit.png")

            # Insert encoding circuit
            push!(result, "<details><summary><h3>Encoding Circuit</h3></summary>")
            push!(result, "")
            push!(result, "![$code_name Encoding Circuit](images/codeplots/$code_name-encoding_circuit.png)")
            push!(result, "</details>")

            # Insert syndrome circuit
            push!(result, "<details><summary><h3>Syndrome Circuit</h3></summary>")
            push!(result, "")
            push!(result, "![$code_name Syndrome Circuit](images/codeplots/$code_name-syndrome_circuit.png)")
            push!(result, "</details>")
        end
    catch e
        error("Error parsing config object: $e")
    end
    return join(result, "\n")
end #  Displays example code

function genBenchmark(code)
    result = ["Benchmarking Results"]
    try
        decoders = code["benchmark"]["decoders"]
        setups = code["benchmark"]["setups"]
        code_name = code["name"]
        image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\performanceplots\\")
        error_rates = code["benchmark"]["error_rates"]
        log_error_rates = [10^p for p in error_rates]
        push!(result, "This code was tested with the following decoders:")

        for d in decoders
            decoder, lt_time1, _ = @timed getfield(Main, d)(code["code"]) # makes decoder type
            for s in setups
                (x_errs, z_errs), lt_time2, _ = @timed evaluate_rates(decoder, s, log_error_rates, code["benchmark"]["nsamples"])

                push!(result, "### $d and $s")

                plot = plot_code_performance(log_error_rates, x_errs, z_errs, title=code_name * " with $d in " * string(round(lt_time1 + lt_time2, sigdigits=4)) * "s")

                save(image_dir * "$code_name-$d-$s.png", plot)
                push!(result, "![$code_name $d $s PP](images\\performanceplots\\$code_name-$d-$s.png)")
            end
        end
    catch e
        error("Error parsing config object: $e")
    end
    return join(result, "\n\n")
end # Benchmarks example code

function genGenerator(code)
    result = String[]
    try

    catch e
        error("Error parsing config object: $e")
    end
    return join(result, "\n")
end # For future: link to interactive generator page

function genQASM(code)
    result = ["QASM Downloads"]
    try
        code_name = code["name"]

        # generate and save QASM file for the naive encoding circuit
        save_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\QASMDownloads\\")
        encoding_circuit = naive_encoding_circuit(code["parity_checks"]["stab"])
        gen_openQASM_file(encoding_circuit, code["parity_checks"]["code_n"], code["parity_checks"]["code_s"], save_dir*code_name*"-naive_encoding_circuit.qasm")

        push!(result, "[QASM $code_name Naive Encoding Circuit](QASMDownloads\\"*code_name*"-naive_encoding_circuit.qasm)")

        push!(result, "")

        # generate and save QASM file for the naive syndrome circuit
        syndrome_circuit = naive_syndrome_circuit(code["parity_checks"]["stab"])
        gen_openQASM_file(syndrome_circuit, code["parity_checks"]["code_n"], code["parity_checks"]["code_s"],  save_dir*code_name*"-naive_syndrome_circuit.qasm")

        push!(result, "[QASM $code_name Naive Syndrome Circuit](QASMDownloads\\"*code_name*"-naive_syndrome_circuit.qasm)")
    catch e
        error("Error parsing config object: $e")
    end
    return join(result, "\n")
end

function genSimilar(code)
    result = String[]
    try
        s = code["similar"]
        for i in s
            n = i["name"]
            l = i["link"]
            d = i["desc"]
            push!(result, "- **[$n]($l)**: $d")
        end
    catch e
        error("Error parsing config object: $e")
    end
    return "Similar Codes \n" * join(result, "\n")
end # Formats pages for similar codes

function genReferences(code)
    try
        cites = code["citation"]
        section = ["References"]
        for cite in cites
        #  keys = keys(dict)
            author = haskey(cite, "author") ? cite["author"] : ""
            title = cite["title"]
            journal = haskey(cite, "journal") ? cite["journal"] : ""
            link = haskey(cite, "link") ? cite["link"] : ""
            citation = [author, title, journal]
            if link !== ""
                push!(citation, "[Link]($link)")
            end
            push!(section, join(citation, ", "))
        end

        return join(section, "\n")
    catch e
        error("Error parsing references: $e")
    end
end

function genPage(code)
    # imports the code dictionary
    # CONFIG_PATH = "generator/codelists/$code_name.jl"

    # CONFIG_PATH = string(@__DIR__, "\\..\\codelists\\$code_name.jl")
    # println(CONFIG_PATH)
    # include(CONFIG_PATH)

    data = code_data(code)

    code_name = data["name"]

    # Define the string you want to write to the .md file
    markdown_content = join([genTitle(data), 
    genDescribe(data), 
    genExample(data), 
    genBenchmark(data), 
    # genGenerator(), # not implemented yet, not to be included until then
    genQASM(data), 
    genSimilar(data), 
    genReferences(data)], 
    """\n\n## """)

    # Specify the file path where you want to save the .md file
    file_path = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\$code_name.md")

    # Open the file in write mode and write the content to it
    open(file_path, "w") do file
        write(file, markdown_content)
    end

    println("Markdown content has been written to $file_path.")
end
 
end