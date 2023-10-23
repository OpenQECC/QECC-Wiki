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

 CODE_NAME = "steane"

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
            image_dir = string(@__DIR__, "/../../pages/images/codeplots/$CODE_NAME-codeplot.png")
            savecircuit(circuit, image_dir)
         end
         n = code_n(stab)
         k = code_k(stab)
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
         if code["replot"]
            println(code["example"]["codestring"])
            tab = stabilizerStringToTableau(code["example"]["codestring"])
            stab = Stabilizer(tab)

            # Truth table decoder


            # Krishna decoder
            f_x_Steane, f_z_Steane, f_a_Steane = pf_encoding_plot(stab, "Steane 7")
            image_dir = string(@__DIR__, "/../../pages/images/performanceplots/")
            save(image_dir * "$CODE_NAME-perfplotx.png", f_x_Steane)
            save(image_dir * "$CODE_NAME-perfplotz.png", f_z_Steane)
            save(image_dir * "$CODE_NAME-perfplota.png", f_a_Steane)
         end


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
     markdown_content = join([getCodeName(), describe(), example(), benchmark(), generator(), getSimilar(), references()], """\n\n## """)

     # Specify the file path where you want to save the .md file
     file_path = string(@__DIR__, "/../../../docs/codes/$CODE_NAME.md")

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