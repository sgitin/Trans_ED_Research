# Trans_ED_Research

This code is used to scrape posts from reddit and analyze them using latent dirichlet allocation probabilistic topic modeling. This specific study focuses on eating disorders in the trans community, but the code can be modified for any topic of interest.

* exploratory_lda.Rmd  -- this is R code to conduct the LDA analysis using the lda package
* exploratory_lda.pdf  -- this is a pdf of the LDA code and tables of the results
* reddit_scrape_pushshift_2019.py  -- this is Python code that scrapes all posts from a specific subreddit within a specific time period using the pushshift package
* reddit_scrape_pushshift_queries.py -- this is Python code that scrapes all posts from a specific subreddit that have a keyword in the title using the pushshift package
* text_processing.jl  -- this is Julia code that cleans the posts that are scraped from reddit to prepare them for LDA analysis using the TextAnalysis package