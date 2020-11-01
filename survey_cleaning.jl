using CSV
using DataFrames

## load survey csv into dataframe and select relevant columns and rows
full_survey_df = CSV.File("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/Trans ED Questionnaire_October 9, 2020_16.23.csv") |> DataFrame
survey1_df = select!(full_survey_df, 8, 11:12, 14, 16, 18:20, 22, 24:25, 27, 29:30, 32, 34, 36, 38:40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60:61, 63, 65:96, 98, 100:101, 103, 105, 107, 109, 111:112, 114)
survey2_df = survey1_df[16:585, :]
survey3_df = coalesce.(survey2_df, "missing")


## rename columns of dataframe
renamed_columns_df = rename(survey3_df, Dict(:Q51 => :trans, :Q86 => :gender, :Q10 => :sex, :Q87 => :binary, :Q88 => :know_age, :Q89 => :transition_age, :Q90 => :past_affirm, :Q100 => :future_affirm, :Q71 => :pride, :Q35 => :psych_dx, :Q36 => :psych_selfid, :Q37 => :stress, :Q38 => :ED_dx, :Q40 => :ED_selfid, :Q41 => :ED_care, :Q42 => :ED_transcomp, :Q48 => :behav_ever, :Q50 => :behav_28, :Q74 => :limit_amount, :Q71_1 => :long_periods, :Q72 => :exclude, :Q73 => :rules, :Q75 => :overeat, :Q76 => :vomit, :Q77 => :laxatives, :Q78 => :exercise, :Q79 => :hormones, :Q92 => :part_community, :Q21 => :community_support, :Q1 => :age, :Q2 => :race, :Q3 => :lang, :Q5 => :class, :Q6 => :insurance, :Q7 => :region, :Q8 => :devo_environ, :Q9 => :religion, :Q13 => :attraction, :Q15 => :edu, :Q4 => :disability))

## add empty column for 1/0 ED 
ED_bin_df = insertcols!(renamed_columns_df, 75, :ED_BIN => 0, makeunique=false)

## iterate through ED questions to change ED bin to 1 if have ED, leave 0 if not
for row in 1:length(ED_bin_df[!, 14])
    if ED_bin_df[row, 14] != "missing"
        ED_bin_df[row, 75] = 1
    elseif ED_bin_df[row, 15] != "missing"
        ED_bin_df[row, 75] = 1
    else
        ED_bin_df[row, 75] = 0
    end
end


#CSV.write("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/test_ED_bin.csv", ED_bin_df)
 
# # create dictionary for support network questions
# support_dict = Dict()
# support_dict["Very Strongly Disagree"] = 1
# support_dict["Strongly Disagree"] = 2
# support_dict["Mildly Disagree"] = 3
# support_dict["Neutral"] = 4
# support_dict["Mildly Agree"] = 5
# support_dict["Strongly Agree"] = 6
# support_dict["Very Strongly Agree"] = 7

# ## translate support answers to score
# for row in 1:length(ED_bin_df[!, 34])
#     if haskey(support_dict, row)
#         ED_bin_df[row, 34] = support_dict[row]
#     end
# end


## iterate through support questions to change to scores
# for col in ED_bin_df[1, 34:47]
#     for row in 1:length(ED_bin_df[!, col])
#         if ED_bin_df[row, col] = "Very Strongly Disagree"
#             ED_bin_df[row, col] = 1
#         elseif ED_bin_df[row, col] = "Strongly Disagree"
#             ED_bin_df[row, col] = 2
#         elseif ED_bin_df[row, col] = "Mildly Disagree"
#             ED_bin_df[row, col] = 3
#         elseif ED_bin_df[row, col] = "Neutral"
#             ED_bin_df[row, col] = 4
#         elseif ED_bin_df[row, col] = "Mildly Agree"
#             ED_bin_df[row, col] = 5
#         elseif ED_bin_df[row, col] = "Strongly Agree"
#             ED_bin_df[row, col] = 6
#         elseif ED_bin_df[row, col] = "Very Strongly Agree"
#             ED_bin_df[row, col] = 7
#         else
#             ED_bin_df[row, col] = "missing"
#         end
#     end
# end

# CSV.write("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/test_ED_bin.csv", ED_bin_df)
 
## add empty columns for support scoring 
ED_bin_df = insertcols!(ED_bin_df, 76, :trans_1 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 77, :trans_2 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 78, :SO_1 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 79, :SO_2 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 80, :Fam_1 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 81, :Fam_2 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 82, :SO_3 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 83, :Fri_1 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 84, :Fri_2 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 85, :Fam_3 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 86, :Fri_3 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 87, :SO_4 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 88, :Fam_4 => 0, makeunique = false)
ED_bin_df = insertcols!(ED_bin_df, 89, :Fri_4 => 0, makeunique = false)

for col in 34:47
    for row in 1:length(ED_bin_df[!, col])
        if ED_bin_df[row, col] == "Very Strongly Disagree"
            ED_bin_df[row, col] = "1"
        elseif ED_bin_df[row, col] == "Strongly Disagree"
            ED_bin_df[row, col] = "2"
        elseif ED_bin_df[row, col] == "Mildly Disagree"
            ED_bin_df[row, col] = "3"
        elseif ED_bin_df[row, col] == "Neutral"
            ED_bin_df[row, col] = "4"
        elseif ED_bin_df[row, col] == "Mildly Agree"
            ED_bin_df[row, col] = "5"
        elseif ED_bin_df[row, col] == "Strongly Agree"
            ED_bin_df[row, col] = "6"
        elseif ED_bin_df[row, col] == "Very Strongly Agree"
            ED_bin_df[row, col] = "7"
        else
            ED_bin_df[row, col] = "0"
        end
    end
end



CSV.write("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/test_ED_bin.csv", ED_bin_df)
 
#:SO_2 => 0, :Fam_1 => 0, :Fam_2 => 0, :SO_3 => 0, :Fri_1 => 0, :Fri_2 => 0, :Fam_3 => 0, :Fri_3 => 0, :SO_4 => 0, :Fam_4 => 0, :Fri_4 => 0,