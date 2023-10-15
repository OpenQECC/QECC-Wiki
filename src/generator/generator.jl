using QuantumClifford

CODE_NAME = "<enter your code name here>"
CONFIG_PATH = "codelists/$CODE_NAME.jl"
include(CONFIG_PATH)

# the `code` variable is now imported

function getCodeName()
    n = code["name"]
    return  "# $n"
end

function describe()
    return code["description"]
end

function example()
    result = String[]
    try
        # stab = StringToStab()
        if not code["replot"]
            
        else
            # stab = StringToStab(code["example"]["codestring"])
            circuit, anc, - = naive_syndrome_circuit()
        end
        # if parity check matrix image already exists
        #   display image
        # else
        #   generate image
        #   display image
    catch e
        error("Error parsing config object: $e")
    end
    return '\n'.join(result)
end #  Displays example code

function benchmark()
    result = ['Benchmarking Results']
    try
        if code['replot']
            
        end
            
        # if plots already exists
        #   display plots
        # else
        #   generate plots
        #   display plots
        #   save plots with the following format '$CODE_NAME' + '$plot_type.png'
    catch e
        error("Error parsing config object: $e")
    end
    return '\n'.join(result)
end # Benchmarks example code

function generator()
    result = String[]
    try
        
    catch e
        error("Error parsing config object: $e")
    end
    return '\n'.join(result)
end # For future: link to interactive generator page

function getSimilar()
    result = String[]
    try
        s = code["similar"]
        for i in s
            n = "###" + i["name"]
            l = i["link"]
            d = i["desc"]
            result.append("- **[$n]($l)**: $d")
        end
    catch e
        error("Error parsing config object: $e")
    end
    return 'Similar Codes \n' + '\n'.join(result)
end # Formats pages for similar codes

function references()
    try
        
        cites = code["citation"]
        section = ["References"]
        for cite in cites
            author = '' if 'author' not in cite else cite['author']
            title = cite['title']
            journal = '' if 'journal' not in cite else cite['journal']
            doi = '' if 'doi' not in cite else cite['journal']
            citation = [, author, title, journal]
            if doi
                citation.append(["[DOI](https://doi.org/$doi)"])
            end
            section.append(','.join(citation))
        end
        
        return '\n'.join(section)
    catch e
        error("Error parsing references: $e")
    
end

function main()
    # Define the string you want to write to the .md file
    markdown_content = """\n\n##""".join(getCodeName(), describe(), example(), benchmark(), generator(), getSimilar(), references())

    # Specify the file path where you want to save the .md file
    file_path = "$CODE_NAME.md"

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
