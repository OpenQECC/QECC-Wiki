module Citation
function format_chicago_citation(input_string::AbstractString)
    # Define a regular expression pattern to match authors, title, journal (including year), arXiv, and DOI
    citation_pattern = r"(?:\[\d+\])?(.+?), “(.+?)”, (.+?) (arXiv:[^\s]+) (DOI:[^\n]+)"

    # Extract matched components using a regular expression
    match_citation = match(citation_pattern, input_string)

    # Check if a match was found
    if match_citation === nothing
        return "Invalid citation format"
    end

    # Extract captured components
    authors = match_citation.captures[1]
    title = match_citation.captures[2]
    journal_arxiv_doi = match_citation.captures[3:end]

    # Extract the journal, arXiv, and DOI components
    journal = ""
    arxiv = ""
    doi = ""

    for component in journal_arxiv_doi
        if occursin("arXiv:", component)
            arxiv = match(r"arXiv:([^\s]+)", component).captures[1]
        elseif occursin("DOI:", component)
            doi = match(r"DOI:([^\n]+)", component).captures[1]
        else
            journal = component
        end
    end

    # Format the Chicago citation with functioning links in Markdown
    return strip("""
    $authors, "$title," $journal [arXiv:$arxiv](https://arxiv.org/abs/$arxiv) DOI: [$doi](https://doi.org/$doi)
    """)

end

export format_chicago_citation
end


# Example input string
input_string = "[13] N. Tantivasadakarn, R. Verresen, and A. Vishwanath, “Shortest Route to Non-Abelian Topological Order on a Quantum Processor”, Physical Review Letters 131, arXiv:2209.03964 DOI:10.1234/abcd"

# Format the Chicago citation with links
chicago_citation = format_chicago_citation(input_string)

# Print or use the formatted citation as needed
println(chicago_citation)
