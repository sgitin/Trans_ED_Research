# Trans_ED_Research

This specific study focuses on eating disorders in the trans community, but the code can be modified for any topic of interest. The folder of code marked "Forum_Analysis" is used to scrape posts from reddit and analyze them using latent dirichlet allocation probabilistic topic modeling.  The folder marked "Survey_Analysis" is used to conduct an exploratory data analysis of the data from the survey questionnaire in the folder and then conduct hypothesis tests on the measures that appeared statistically significant.

* exploratory_lda.Rmd  -- this is R code to conduct the LDA analysis using the lda package
* exploratory_lda.pdf  -- this is a pdf of the LDA code and tables of the results
* Final Interview Questions.pdf -- this is a pdf of the interview questions that asked as a follow up to the survey
* Full Questionnaire.docx -- this is a Word Document containing the full questionnaire that is analyzed by the code
* reddit_scrape_pushshift_2019.py  -- this is Python code that scrapes all posts from a specific subreddit within a specific time period using the pushshift package
* reddit_scrape_pushshift_queries.py -- this is Python code that scrapes all posts from a specific subreddit that have a keyword in the title using the pushshift package
* survey_analysis.Rmd -- this is R code for the exploratory data analysis of the survey data
* survey_cleaning.jl -- this is Julia code that cleans the survey data to prepare it for statistical analysis in R
* survey_hypothesis_testing.Rmd -- this is R code that conducts hypothesis tests for the measures in the survey that appeared to be statistically significant based on the exploratory data analysis
* text_processing.jl  -- this is Julia code that cleans the posts that are scraped from reddit to prepare them for LDA analysis using the TextAnalysis package
