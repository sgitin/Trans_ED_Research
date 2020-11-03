using CSV
using DataFrames

## load survey csv into dataframe and select relevant columns and rows
full_survey_df = CSV.File("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/Trans ED Questionnaire_October 9, 2020_16.23.csv") |> DataFrame
survey1_df = select!(full_survey_df, 8, 11:12, 14, 16, 18:20, 22, 24:25, 27, 29:30, 32, 34, 36, 38:40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60:61, 63, 65:96, 98, 100:101, 103, 105, 107, 109, 111:112, 114)
survey2_df = survey1_df[16:585, :]
survey3_df = coalesce.(survey2_df, "missing")


## rename columns of dataframe
renamed_columns_df = rename(survey3_df, Dict(:Q51 => :trans, :Q86 => :gender, :Q10 => :sex, :Q87 => :binary, :Q88 => :know_age, :Q89 => :transition_age, :Q90 => :past_affirm, :Q100 => :future_affirm, :Q71 => :pride, :Q35 => :psych_dx, :Q36 => :psych_selfid, :Q37 => :stress, :Q38 => :ED_dx, :Q40 => :ED_selfid, :Q41 => :ED_care, :Q42 => :ED_transcomp, :Q48 => :behav_ever, :Q50 => :behav_28, :Q74 => :limit_amount, :Q71_1 => :long_periods, :Q72 => :exclude, :Q73 => :rules, :Q75 => :overeat, :Q76 => :vomit, :Q77 => :laxatives, :Q78 => :exercise, :Q79 => :hormones, :Q92 => :part_community, :Q21 => :community_support, :Q22 => :SO_1, :Q89_1 => :SO_2, :Q90_1 => :Fam_1, :Q91 => :Fam_2, :Q92_1 => :SO_3, :Q93 => :Fri_1, :Q94 => :Fri_2, :Q95 => :Fam_3, :Q97 => :Fri_3, :Q98 => :SO_4, :Q99 => :Fam_4, :Q34 => :Fri_4, :Q1 => :age, :Q2 => :race, :Q3 => :lang, :Q5 => :class, :Q6 => :insurance, :Q7 => :region, :Q8 => :devo_environ, :Q9 => :religion, :Q13 => :attraction, :Q15 => :edu, :Q4 => :disability))

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

## add empty column for 1/0 current disordered eating behavior 
ED_bin_df = insertcols!(ED_bin_df, 76, :DE_BIN => 0, makeunique=false)

## iterate through disordered eating behavior questions to change DE bin to 1 if have current DE behaviors, leave 0 if not
for row in 1:length(ED_bin_df[!, 19])
    if ED_bin_df[row, 19] != "missing"
        ED_bin_df[row, 76] = 1
    else
        ED_bin_df[row, 76] = 0
    end
end

## change age realized trans and age started gender affirmation to integer type
for row in 1:length(ED_bin_df[!, 63])
    if ED_bin_df[row, 63] == "missing"
        ED_bin_df[row, 63] = "0"
    end
end
for row in 1:length(ED_bin_df[!, 7])
    if ED_bin_df[row, 7] == "missing" && ED_bin_df[row, 6] != "missing"
        ED_bin_df[row, 7] = ED_bin_df[row, 63]
    elseif ED_bin_df[row, 7] == "missing" && ED_bin_df[row, 6] == "missing"
        ED_bin_df[row, 7] = "0"
    end
end
for row in 1:length(ED_bin_df[!, 6])
    if ED_bin_df[row, 6] == "missing"
        ED_bin_df[row, 6] = "100"
    end
end



for col in 6:7
    for row in 1:length(ED_bin_df[!, col])
        if ED_bin_df[row, col] == "N/A"
            ED_bin_df[row, col] = ED_bin_df[row, 63]
        elseif ED_bin_df[row, col] == "21-25"
            ED_bin_df[row, col] = "23"
        elseif ED_bin_df[row, col] == "26-29"
            ED_bin_df[row, col] = "27"
        elseif ED_bin_df[row, col] == "30-39"
            ED_bin_df[row, col] = "35"
        elseif ED_bin_df[row, col] == "40-49"
            ED_bin_df[row, col] = "45"
        elseif ED_bin_df[row, col] == "50+"
            ED_bin_df[row, col] = "55"
        elseif ED_bin_df[row, col] == "18-25"
            ED_bin_df[row, col] = "21"
        elseif ED_bin_df[row, col] == "26-35"
            ED_bin_df[row, col] = "30"
        elseif ED_bin_df[row, col] == "36-45"
            ED_bin_df[row, col] = "40"
        elseif ED_bin_df[row, col] == "56-65"
            ED_bin_df[row, col] = "50"
        elseif ED_bin_df[row, col] == "66-75"
            ED_bin_df[row, col] = "60"
        elseif ED_bin_df[row, col] == "76+"
            ED_bin_df[row, col] = "80"
        end
    end
end

# for row in 1:length(ED_bin_df[!, 6])
#     ED_bin_df[row, 6] = parse(Int, ED_bin_df[row, 6])
# end

# for row in 1:length(ED_bin_df[!, 7])
#     ED_bin_df[row, 7] = parse(Int, ED_bin_df[row, 7])
# end


## add empty column for years until affirmation started 
ED_bin_df = insertcols!(ED_bin_df, 77, :years_to_trans => 0, makeunique=false)

## calculate years until affirmation started for each participant (missing data will be -1, not started will be subtracted from their age)
for row in 1:length(ED_bin_df[!, 77])
    age_know = parse(Int, ED_bin_df[row, 6])
    age_start = parse(Int, ED_bin_df[row, 7])
    ED_bin_df[row, 77] = age_start - age_know
end

 
#iterate through suport system columns and replace phrase with numerical score
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
 