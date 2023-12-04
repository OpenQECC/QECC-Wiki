module QECC_pageGeneration

export genPage

 using QuantumClifford
 using QuantumClifford.ECC
 using Quantikz
 using CairoMakie

 include("./QECC_converter.jl")
 using .QECC_Converter

 include("QECC_decoders.jl")
 using .QECC_Decoders

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
         tab = stabilizerStringToTableau(code["example"]["codestring"])
         stab = Stabilizer(tab)
         if code["replot"]
            # generate circuit img
            circuit, anc, - = naive_syndrome_circuit(tab);

            # save img
            image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\codeplots\\$code_name-codeplot.png")
            savecircuit(circuit, image_dir)
         end
         n = code_n(stab)
         k = code_k(stab)
         push!(result, "Code Tableau:")
         push!(result, join(split(code["example"]["codestring"], ' ')))
         push!(result, "- Number of qubits: N = $n")
         push!(result, "- Number of encoded bits: k = $k")
         if is_degenerate(stab)
            push!(result, "- The $code_name code is degenerate!")
         else
            push!(result, "- The $code_name code is not degenerate.")
         end
         push!(result, "### Syndrome Circuit:")

         # Link image in markdown file
         push!(result, "![$code_name Syndrome Circuit](images/codeplots/$code_name-codeplot.png)")
     catch e
         error("Error parsing config object: $e")
     end
     return join(result, "\n")
 end #  Displays example code

 function genBenchmark(code, decoders, encodingCircuits, syndromeCircuits)
     result = ["Benchmarking Results"]
     try
        code_name = code["name"]
        image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\performanceplots\\")
        tab = stabilizerStringToTableau(code["example"]["codestring"])
        stab = Stabilizer(tab)
        error_rates = code["benchmark"]["error_rates"]
        log_error_rates = [10^p for p in error_rates]
        push!(result, "This code was tested with the following decoders:")

        for decoder in decoders
            for encodingCircuit in encodingCircuits
                for syndromeCircuit in syndromeCircuits
                    push!(result, "###: $decoder and $encodingCircuit and $syndromeCircuit")
                    plot = eval(getfield(Main, Symbol(decoder))(stab, log_error_rates, code["name"], encodingCircuit, syndromeCircuit))
                    save(image_dir * "$code_name-$decoder.png", plot)
                    push!(result, "![$code_name $decoder PP](images\\performanceplots\\$code_name-$decoder.png)")
                end
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
    result = ["## QASM Downloads"]
    try
        code_name = code["name"]
        # generate QASM file
        save_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\QASMDownloads\\")
        generate_openQasm_file(code["example"]["codestring"], save_dir*code_name*"-encodingCircuit.qasm")
        push!(result, "[QASM Encoding Circuit](QASMDownloads\\"*code_name*"-encodingCircuit.qasm)")
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
             doi = haskey(cite, "doi") ? cite["doi"] : ""
             citation = [author, title, journal]
             if doi !== ""
                 push!(citation, "[DOI](https://doi.org/$doi)")
             end
             push!(section, join(citation, ", "))
         end

         return join(section, "\n")
     catch e
         error("Error parsing references: $e")
     end
 end

 function genPage(code_name, decoders, encodingCircuits, syndromeCircuits)
    # imports the code dictionary
    # CONFIG_PATH = "generator/codelists/$code_name.jl"

    CONFIG_PATH = string(@__DIR__, "\\..\\codelists\\$code_name.jl")
    println(CONFIG_PATH)
    include(CONFIG_PATH)

    code_name = code["name"]
    tab = stabilizerStringToTableau(code["example"]["codestring"])
    stab = Stabilizer(tab)
    
    genEncodingCircuits = [getfield(Main, Symbol(circ))(stab) for circ in encodingCircuits]
    genSyndromeCircuits = [getfield(Main, Symbol(circ))(stab)[1] for circ in syndromeCircuits]

     # Define the string you want to write to the .md file
     markdown_content = join([genTitle(code), 
     genDescribe(code), 
     genExample(code), 
     genBenchmark(code, decoders, genEncodingCircuits, genSyndromeCircuits), 
     # genGenerator(), # not implemented yet, not to be included until then
     genQASM(code), 
     genSimilar(code), 
     genReferences(code)], 
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