using TextAnalysis
using CSV
using DataFrames


## change directory to input files
cd("/Users/Apple/Documents/Trans_ED_Research/posts")

for file in readdir()
    @time begin
        filename = string("/Users/Apple/Documents/Trans_ED_Research/posts/", file)

        posts_df = CSV.File(filename) |> DataFrame

        processed_posts_df = DataFrame(Post_ID = [], Text = [])

        for i in 1:length(posts_df[:, 1])
            post = posts_df[i, 2]
            sd = StringDocument(post)
            ## remove numbers, articles, prepositions, stop words, html tags, punctuation, pronouns
            prepare!(sd, strip_numbers | strip_articles | strip_prepositions | strip_stopwords | strip_html_tags | strip_punctuation | strip_case | strip_pronouns | strip_non_letters)
            ## stem words
            stem!(sd)
            ## remove words that are part of a url
            remove_words!(sd, ["http", "https", "com", "www", "jpg", "imgur", "amp", "x", "b", "img", "png"])
            push!(processed_posts_df, posts_df[i, 1:2])
            processed_posts_df[i, 2] = text(sd)
        end
        ## change directory to ouput files
        cd("/Users/Apple/Documents/Trans_ED_Research/processed_posts")

        outputfile = string("processed_", file)

        ## write out csv
        open(outputfile, "w") do f
            CSV.write(f, processed_posts_df)
        end
    end
end

## this writes processed files to different directory now; adjust directories as needed