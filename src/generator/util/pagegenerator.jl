module pagegenerator

export compile

 using QuantumClifford
 using QuantumClifford.ECC
 using Quantikz
 using CairoMakie

 include("./converter.jl")
 using .converter

 include("./pfcircuit_eval.jl")
 using .PauliFrame_Eval

 include("QECC_plotters.jl")
 using .QECC_Plotters

 include("QECC_decoders.jl")
 using .QECC_Decoders

 create_lookup_table = QECC_Decoders.create_lookup_table
 plot_code_performance = QECC_Plotters.plot_code_performance
 
 CODE_NAME = "Bicycle"

 CONFIG_PATH = "../codelists/$CODE_NAME.jl"
 include(CONFIG_PATH)

 # the `code` variable is now imported

 function getCodeName()
     n = code["name"]
     return  "# $n"
 end

 function describe()
     try
        result = vcat(["Description"], code["description"])
        return join(result, "\n - ")
     catch e
        error("Error parsing config object description: $e")
     end
     return ""
 end

 function example()
     result = ["Example"]
     try
         tab = stabilizerStringToTableau(code["example"]["codestring"])
         stab = Stabilizer(tab)
         if code["replot"]
            # generate circuit img
            circuit, anc, - = naive_syndrome_circuit(tab);

            # save img
            image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\codeplots\\$CODE_NAME-codeplot.png")
            savecircuit(circuit, image_dir)
         end
         n = code_n(stab)
         k = code_k(stab)
         push!(result, "Code Tableau:")
         push!(result, join(split(code["example"]["codestring"], ' ')))
         push!(result, "- Number of qubits: N = $n")
         push!(result, "- Number of encoded bits: k = $k")
         push!(result, "### Syndrome Circuit:")

         # Link image in markdown file
         push!(result, "![$CODE_NAME Syndrome Circuit](../../src/pages/images/codeplots/$CODE_NAME-codeplot.png)")
     catch e
         error("Error parsing config object: $e")
     end
     return join(result, "\n")
 end #  Displays example code

 function benchmark()
     result = ["Benchmarking Results"]
    #  try
         image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\performanceplots\\")
         tab = stabilizerStringToTableau(code["example"]["codestring"])
         stab = Stabilizer(tab)
         times = []
         if code["replot"]
            image_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\images\\performanceplots\\")
            tab = stabilizerStringToTableau(code["example"]["codestring"])
            stab = Stabilizer(tab)

            # Truth table decoder
            lookup_table, lt_time1, _ = @timed create_lookup_table(stab)
            error_rates = code["benchmark"]["error_rates"]
            post_ec_error_rates, lt_time2, _ = @timed [evaluate_code_decoder(stab, lookup_table, p) for p in error_rates]
            lt_time = round(lt_time1 + lt_time2, sigdigits=4)
            push!(times, lt_time)
            lt_plot = plot_code_performance(error_rates, post_ec_error_rates, title="$CODE_NAME: Lookup table @$lt_time"*"s")
            save(image_dir * "$CODE_NAME-lookuptable.png", lt_plot)

            # Krishna decoder
            bp_x_plot, bp_z_plot, bp_a_plot, bp_time = pf_encoding_plot(stab, CODE_NAME)
            push!(times, bp_time)
            save(image_dir * "$CODE_NAME-beliefx.png", bp_x_plot)
            save(image_dir * "$CODE_NAME-beliefz.png", bp_z_plot)
            save(image_dir * "$CODE_NAME-beliefa.png", bp_a_plot)
         end
         push!(result, "This code was tested with the following decoders:")
         push!(result, "**Lookup table:** Ran in "*string(times[1])*"s")
         push!(result, "![$CODE_NAME Truth Table PP](images\\performanceplots\\$CODE_NAME-lookuptable.png)")
         push!(result, "**Belief decoder:** Ran in "*string(times[2])*"s")
         push!(result, "![$CODE_NAME Belief Decoder PP](images\\performanceplots\\$CODE_NAME-belief.png)")
        

         # if plots already exists
         #   display plots
         # else
         #   generate plots
         #   display plots
         #   save plots with the following format "$CODE_NAME" + "$plot_type.png"
    #  catch e
        #  error("Error parsing config object: $e")
    #  end
     return join(result, "\n")
 end # Benchmarks example code

 function generator()
     result = String[]
     try

     catch e
         error("Error parsing config object: $e")
     end
     return join(result, "\n")
 end # For future: link to interactive generator page

 function QASMdownload()
    result = String["QASM Downloads"]
    # generate QASM file
    save_dir = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\QASMDownloads\\")
    generate_openQasm_file(code["example"]["codestring"], save_dir*CODE_NAME*"-encodingCircuit.qasm")
    push!(result, "[QASM Encoding Circuit](QASMDownloads\\"*CODE_NAME*"-encodingCircuit.qasm)")
    return result
 end

 function getSimilar()
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

 function references()
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

 function main()
     # Define the string you want to write to the .md file
     markdown_content = join([getCodeName(), describe(), example(), benchmark(), generator(), QASMdownload(), getSimilar(), references()], """\n\n## """)
 
     # Specify the file path where you want to save the .md file
     file_path = string(@__DIR__, "\\..\\..\\..\\docs\\codes\\$CODE_NAME.md")
 
     # Open the file in write mode and write the content to it
     open(file_path, "w") do file
         write(file, markdown_content)
     end

     println("Markdown content has been written to $file_path.")
 end

 # Check if this script is the main entry point
 if !isdefined(Main, :__init__)
     main()  # Call the main function if this script is the main entry point
 end

end