using CSV
using DataFrames

## load survey csv into dataframe and select relevant columns and rows
full_survey_df = CSV.File("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/Trans ED Questionnaire_October 9, 2020_16.23.csv") |> DataFrame
survey1_df = select!(full_survey_df, 8, 11:12, 14, 16, 18:20, 22, 24:25, 27, 29:30, 32, 34, 36, 38:40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60:61, 63, 65:96, 98, 100:101, 103, 105, 107, 109, 111:112, 114)
survey2_df = survey1_df[16:585, :]
survey3_df = coalesce.(survey2_df, "missing")


## rename columns of dataframe
renamed_columns_df = rename(survey3_df, Dict(:Q51 => :trans, :Q86 => :gender, :Q10 => :sex, :Q87 => :binary, :Q88 => :know_age, :Q89 => :transition_age, :Q90 => :past_affirm, :Q100 => :future_affirm, :Q71 => :pride, :Q35 => :psych_dx, :Q36 => :psych_selfid, :Q37 => :stress, :Q38 => :ED_dx, :Q40 => :ED_selfid, :Q41 => :ED_care, :Q42 => :ED_transcomp, :Q48 => :behav_ever, :Q50 => :behav_28, :Q74 => :limit_amount, :Q71_1 => :long_periods, :Q72 => :exclude, :Q73 => :rules, :Q75 => :overeat, :Q76 => :vomit, :Q77 => :laxatives, :Q78 => :exercise, :Q79 => :hormones, :Q44 => :clothes, :Q92 => :part_community, :Q21 => :community_support, :Q22 => :SO_1, :Q89_1 => :SO_2, :Q90_1 => :Fam_1, :Q91 => :Fam_2, :Q92_1 => :SO_3, :Q93 => :Fri_1, :Q94 => :Fri_2, :Q95 => :Fam_3, :Q97 => :Fri_3, :Q98 => :SO_4, :Q99 => :Fam_4, :Q34 => :Fri_4, :Q70 => :nonaffirm, :Q1 => :age, :Q2 => :race, :Q3 => :lang, :Q5 => :class, :Q6 => :insurance, :Q7 => :region, :Q8 => :devo_environ, :Q9 => :religion, :Q13 => :attraction, :Q15 => :edu, :Q4 => :disability))

## add empty column for 1/0 ED 
ED_bin_df = insertcols!(renamed_columns_df, 75, :ED_BIN => "no", makeunique=false)

## iterate through ED questions to change ED bin to 1 if have ED, leave 0 if not
for row in 1:length(ED_bin_df[!, 14])
    if ED_bin_df[row, 14] != "missing"
        ED_bin_df[row, 75] = "yes"
    elseif ED_bin_df[row, 15] != "missing"
        ED_bin_df[row, 75] = "yes"
    else
        ED_bin_df[row, 75] = "no"
    end
end

## add empty column for 1/0 current disordered eating behavior 
ED_bin_df = insertcols!(ED_bin_df, 76, :DE_BIN => "no", makeunique=false)

## iterate through disordered eating behavior questions to change DE bin to 1 if have current DE behaviors, leave 0 if not
for row in 1:length(ED_bin_df[!, 19])
    if ED_bin_df[row, 19] != "missing"
        ED_bin_df[row, 76] = "yes"
    else
        ED_bin_df[row, 76] = "no"
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

## add empty column for 1/0 nonbinary bin 
ED_bin_df = insertcols!(ED_bin_df, 78, :enby_BIN => "no", makeunique=false)

## iterate through nonbinary question to change enby bin to 1 if ID more as enby, leave 0 if not
for row in 1:length(ED_bin_df[!, 78])
    if ED_bin_df[row, 5] == "More as a nonbinary trans person"
        ED_bin_df[row, 78] = "yes"
    else
        ED_bin_df[row, 78] = "no"
    end
end

## add empty column for 1/0 psych bin 
ED_bin_df = insertcols!(ED_bin_df, 79, :psych_BIN => "no", makeunique=false)

## iterate through psych dx questions to change psych bin to 1 if have a psych condition, leave 0 if not
for row in 1:length(ED_bin_df[!, 79])
    if occursin("Depressive Disorder", ED_bin_df[row, 11]) || occursin("Schizophrenia Spectrum Disorder", ED_bin_df[row, 11]) || occursin("Other Psychotic Disorder", ED_bin_df[row, 11]) || occursin("Bipolar Disorder", ED_bin_df[row, 11]) || occursin("Anxiety Disorder", ED_bin_df[row, 11]) || occursin("Panic Disorder", ED_bin_df[row, 11]) || occursin("Obsessive Compulsive and Related Disorder", ED_bin_df[row, 11]) || occursin("Post Traumatic Stress Disorder", ED_bin_df[row, 11]) || occursin("Dissociative Identity Disorder", ED_bin_df[row, 11]) || occursin("Sleep Disorder", ED_bin_df[row, 11]) || occursin("Substance-Related and Addictive Disorder", ED_bin_df[row, 11]) || occursin("Personality Disorder", ED_bin_df[row, 11]) || occursin("Autism Spectrum Disorder", ED_bin_df[row, 11]) || occursin("Other", ED_bin_df[row, 11])
        ED_bin_df[row, 79] = "yes"
    elseif occursin("Depressive Disorder", ED_bin_df[row, 12]) || occursin("Schizophrenia Spectrum Disorder", ED_bin_df[row, 12]) || occursin("Other Psychotic Disorder", ED_bin_df[row, 12]) || occursin("Bipolar Disorder", ED_bin_df[row, 12]) || occursin("Anxiety Disorder", ED_bin_df[row, 12]) || occursin("Panic Disorder", ED_bin_df[row, 12]) || occursin("Obsessive Compulsive and Related Disorder", ED_bin_df[row, 12]) || occursin("Post Traumatic Stress Disorder", ED_bin_df[row, 12]) || occursin("Dissociative Identity Disorder", ED_bin_df[row, 12]) || occursin("Sleep Disorder", ED_bin_df[row, 12]) || occursin("Substance-Related and Addictive Disorder", ED_bin_df[row, 12]) || occursin("Personality Disorder", ED_bin_df[row, 12]) || occursin("Autism Spectrum Disorder", ED_bin_df[row, 12]) || occursin("Other", ED_bin_df[row, 12])
        ED_bin_df[row, 79] = "yes"
    else
        ED_bin_df[row, 79] = "no"
    end
end

## add empty column for 1/0 future affirmations bin 
ED_bin_df = insertcols!(ED_bin_df, 80, :future_affirm_BIN => "no", makeunique=false)

## iterate through psych dx questions to change psych bin to 1 if have a psych condition, leave 0 if not
for row in 1:length(ED_bin_df[!, 80])
    if ED_bin_df[row, 9] != "missing"
        ED_bin_df[row, 80] = "yes"
    else
        ED_bin_df[row, 80] = "no"
    end
end

## add empty columns for support scores 
ED_bin_df = insertcols!(ED_bin_df, 81, :trans_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 82, :SO_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 83, :Fam_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 84, :Fri_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 85, :Total_score => 0.00, makeunique=false)

## calculate support scores (if any questions were unanswered score will be 0)
for row in 1:length(ED_bin_df[!, 81])
    trans_1 = parse(Float64, ED_bin_df[row, 34])
    trans_2 = parse(Float64, ED_bin_df[row, 35])
    if trans_1 != 0 && trans_2 != 0
        ED_bin_df[row, 81] = (trans_1 + trans_2)/ 2.00
    else
        ED_bin_df[row, 81] = 0
    end 
end

for row in 1:length(ED_bin_df[!, 82])
    SO_1 = parse(Float64, ED_bin_df[row, 36])
    SO_2 = parse(Float64, ED_bin_df[row, 37])
    SO_3 = parse(Float64, ED_bin_df[row, 40])
    SO_4 = parse(Float64, ED_bin_df[row, 45])
    if SO_1 != 0 && SO_2 != 0 && SO_3 != 0 && SO_4 != 0
        ED_bin_df[row, 82] = (SO_1 + SO_2 + SO_3 + SO_4)/ 4.00
    else
        ED_bin_df[row, 82] = 0
    end 
end

for row in 1:length(ED_bin_df[!, 83])
    Fam_1 = parse(Float64, ED_bin_df[row, 38])
    Fam_2 = parse(Float64, ED_bin_df[row, 39])
    Fam_3 = parse(Float64, ED_bin_df[row, 43])
    Fam_4 = parse(Float64, ED_bin_df[row, 46])
    if Fam_1 != 0 && Fam_2 != 0 && Fam_3 != 0 && Fam_4 != 0
        ED_bin_df[row, 83] = (Fam_1 + Fam_2 + Fam_3 + Fam_4)/ 4.00
    else
        ED_bin_df[row, 83] = 0
    end 
end

for row in 1:length(ED_bin_df[!, 84])
    Fri_1 = parse(Float64, ED_bin_df[row, 41])
    Fri_2 = parse(Float64, ED_bin_df[row, 42])
    Fri_3 = parse(Float64, ED_bin_df[row, 44])
    Fri_4 = parse(Float64, ED_bin_df[row, 47])
    if Fri_1 != 0 && Fri_2 != 0 && Fri_3 != 0 && Fri_4 != 0
        ED_bin_df[row, 84] = (Fri_1 + Fri_2 + Fri_3 + Fri_4)/ 4.00
    else
        ED_bin_df[row, 84] = 0
    end 
end

for row in 1:length(ED_bin_df[!, 85])
    SO_1 = parse(Float64, ED_bin_df[row, 36])
    SO_2 = parse(Float64, ED_bin_df[row, 37])
    SO_3 = parse(Float64, ED_bin_df[row, 40])
    SO_4 = parse(Float64, ED_bin_df[row, 45])
    Fam_1 = parse(Float64, ED_bin_df[row, 38])
    Fam_2 = parse(Float64, ED_bin_df[row, 39])
    Fam_3 = parse(Float64, ED_bin_df[row, 43])
    Fam_4 = parse(Float64, ED_bin_df[row, 46])
    Fri_1 = parse(Float64, ED_bin_df[row, 41])
    Fri_2 = parse(Float64, ED_bin_df[row, 42])
    Fri_3 = parse(Float64, ED_bin_df[row, 44])
    Fri_4 = parse(Float64, ED_bin_df[row, 47])
    if SO_1 != 0 && SO_2 != 0 && SO_3 != 0 && SO_4 != 0 && Fam_1 != 0 && Fam_2 != 0 && Fam_3 != 0 && Fam_4 != 0 && Fri_1 != 0 && Fri_2 != 0 && Fri_3 != 0 && Fri_4 != 0
        ED_bin_df[row, 85] = (SO_1 + SO_2 + SO_3 + SO_4 + Fam_1 + Fam_2 + Fam_3 + Fam_4 + Fri_1 + Fri_2 + Fri_3 + Fri_4)/ 12.00
    else
        ED_bin_df[row, 85] = 0
    end 
end

## add empty columns for binary trans fem and binary trans masc
ED_bin_df = insertcols!(ED_bin_df, 86, :trans_fem => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 87, :trans_masc => "no", makeunique=false)

## iterate through gender identity questions to fill out trans fem and trans masc columns
for row in 1:length(ED_bin_df[!, 86])
    if ED_bin_df[row, 5] == "More as a binary trans person" && ED_bin_df[row, 2] != "No" && occursin("Woman", ED_bin_df[row, 3]) || occursin("Trans Woman", ED_bin_df[row, 3]) || occursin("Demi Girl", ED_bin_df[row, 3])
        ED_bin_df[row, 86] = "yes"
    else
        ED_bin_df[row, 86] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 87])
    if ED_bin_df[row, 5] == "More as a binary trans person" && ED_bin_df[row, 2] != "No" && occursin("Man", ED_bin_df[row, 3]) || occursin("Trans Man", ED_bin_df[row, 3]) || occursin("Demi Boy", ED_bin_df[row, 3])
        ED_bin_df[row, 87] = "yes"
    else
        ED_bin_df[row, 87] = "no"
    end
end

## add empty columns for functions of DE
ED_bin_df = insertcols!(ED_bin_df, 88, :lose_weight => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 89, :change_shape => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 90, :increase_muscle => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 91, :decrease_muscle => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 92, :curves_bigger => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 93, :curves_smaller => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 94, :society_weight => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 95, :society_shape => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 96, :society_gender => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 97, :attractive => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 98, :weight_sport => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 99, :body_sport => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 100, :dysphoria => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 101, :passing_comfort => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 102, :passing_safety => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 103, :no_hormones => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 104, :no_surgery => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 105, :no_periods => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 106, :anxiety => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 107, :depression => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 108, :trauma => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 109, :numb_pain => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 110, :control => "no", makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 111, :compulsion => "no", makeunique=false)

# iterate through function of disordered eating behavior questions to fill out yes/no columns for each function
for row in 1:length(ED_bin_df[!, 88])
    if occursin("To lose weight", ED_bin_df[row, 20]) || occursin("To lose weight", ED_bin_df[row, 21]) || occursin("To lose weight", ED_bin_df[row, 22]) || occursin("To lose weight", ED_bin_df[row, 23]) || occursin("To lose weight", ED_bin_df[row, 24]) || occursin("To lose weight", ED_bin_df[row, 25]) || occursin("To lose weight", ED_bin_df[row, 26]) || occursin("To lose weight", ED_bin_df[row, 27]) || occursin("To lose weight", ED_bin_df[row, 28])
        ED_bin_df[row, 88] = "yes"
    else
        ED_bin_df[row, 88] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 89])
    if occursin("To change body shape", ED_bin_df[row, 20]) || occursin("To change body shape", ED_bin_df[row, 21]) || occursin("To change body shape", ED_bin_df[row, 22]) || occursin("To change body shape", ED_bin_df[row, 23]) || occursin("To change body shape", ED_bin_df[row, 24]) || occursin("To change body shape", ED_bin_df[row, 25]) || occursin("To change body shape", ED_bin_df[row, 26]) || occursin("To change body shape", ED_bin_df[row, 27]) || occursin("To change body shape", ED_bin_df[row, 28])
        ED_bin_df[row, 89] = "yes"
    else
        ED_bin_df[row, 89] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 90])
    if occursin("To increase muscle mass", ED_bin_df[row, 20]) || occursin("To increase muscle mass", ED_bin_df[row, 21]) || occursin("To increase muscle mass", ED_bin_df[row, 22]) || occursin("To increase muscle mass", ED_bin_df[row, 23]) || occursin("To increase muscle mass", ED_bin_df[row, 24]) || occursin("To increase muscle mass", ED_bin_df[row, 25]) || occursin("To increase muscle mass", ED_bin_df[row, 26]) || occursin("To increase muscle mass", ED_bin_df[row, 27]) || occursin("To increase muscle mass", ED_bin_df[row, 28])
        ED_bin_df[row, 90] = "yes"
    else
        ED_bin_df[row, 90] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 91])
    if occursin("To decrease muscle mass", ED_bin_df[row, 20]) || occursin("To decrease muscle mass", ED_bin_df[row, 21]) || occursin("To decrease muscle mass", ED_bin_df[row, 22]) || occursin("To decrease muscle mass", ED_bin_df[row, 23]) || occursin("To decrease muscle mass", ED_bin_df[row, 24]) || occursin("To decrease muscle mass", ED_bin_df[row, 25]) || occursin("To decrease muscle mass", ED_bin_df[row, 26]) || occursin("To decrease muscle mass", ED_bin_df[row, 27]) || occursin("To decrease muscle mass", ED_bin_df[row, 28])
        ED_bin_df[row, 91] = "yes"
    else
        ED_bin_df[row, 91] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 92])
    if occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 20]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 21]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 22]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 23]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 24]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 25]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 26]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 27]) || occursin("To make “curves” (i.e. hips, butt, breasts) bigger", ED_bin_df[row, 28])
        ED_bin_df[row, 92] = "yes"
    else
        ED_bin_df[row, 92] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 93])
    if occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 20]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 21]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 22]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 23]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 24]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 25]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 26]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 27]) || occursin("To make “curves” (i.e. hips, butt, breasts) smaller", ED_bin_df[row, 28])
        ED_bin_df[row, 93] = "yes"
    else
        ED_bin_df[row, 93] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 94])
    if occursin("To fit societal standards of weight", ED_bin_df[row, 20]) || occursin("To fit societal standards of weight", ED_bin_df[row, 21]) || occursin("To fit societal standards of weight", ED_bin_df[row, 22]) || occursin("To fit societal standards of weight", ED_bin_df[row, 23]) || occursin("To fit societal standards of weight", ED_bin_df[row, 24]) || occursin("To fit societal standards of weight", ED_bin_df[row, 25]) || occursin("To fit societal standards of weight", ED_bin_df[row, 26]) || occursin("To fit societal standards of weight", ED_bin_df[row, 27]) || occursin("To fit societal standards of weight", ED_bin_df[row, 28])
        ED_bin_df[row, 94] = "yes"
    else
        ED_bin_df[row, 94] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 95])
    if occursin("To fit societal standards of body shape", ED_bin_df[row, 20]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 21]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 22]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 23]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 24]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 25]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 26]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 27]) || occursin("To fit societal standards of body shape", ED_bin_df[row, 28])
        ED_bin_df[row, 95] = "yes"
    else
        ED_bin_df[row, 95] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 96])
    if occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 20]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 21]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 22]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 23]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 24]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 25]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 26]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 27]) || occursin("To fit societal standards of what your gender “should” look like", ED_bin_df[row, 28])
        ED_bin_df[row, 96] = "yes"
    else
        ED_bin_df[row, 96] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 97])
    if occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 20]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 21]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 22]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 23]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 24]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 25]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 26]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 27]) || occursin("To be more attractive to sexual partners, current or future", ED_bin_df[row, 28])
        ED_bin_df[row, 97] = "yes"
    else
        ED_bin_df[row, 97] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 98])
    if occursin("To fit a weight class for a sport", ED_bin_df[row, 20]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 21]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 22]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 23]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 24]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 25]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 26]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 27]) || occursin("To fit a weight class for a sport", ED_bin_df[row, 28])
        ED_bin_df[row, 98] = "yes"
    else
        ED_bin_df[row, 98] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 99])
    if occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 20]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 21]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 22]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 23]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 24]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 25]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 26]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 27]) || occursin("To have the “right” body type for a sport or other activity", ED_bin_df[row, 28])
        ED_bin_df[row, 99] = "yes"
    else
        ED_bin_df[row, 99] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 100])
    if occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 20]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 21]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 22]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 23]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 24]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 25]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 26]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 27]) || occursin("to avoid the discomfort of seeing a body that doesn’t match who you are", ED_bin_df[row, 28])
        ED_bin_df[row, 100] = "yes"
    else
        ED_bin_df[row, 100] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 101])
    if occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 20]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 21]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 22]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 23]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 24]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 25]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 26]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 27]) || occursin("to avoid the discomfort of being misgendered", ED_bin_df[row, 28])
        ED_bin_df[row, 101] = "yes"
    else
        ED_bin_df[row, 101] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 102])
    if occursin("for safety reasons", ED_bin_df[row, 20]) || occursin("for safety reasons", ED_bin_df[row, 21]) || occursin("for safety reasons", ED_bin_df[row, 22]) || occursin("for safety reasons", ED_bin_df[row, 23]) || occursin("for safety reasons", ED_bin_df[row, 24]) || occursin("for safety reasons", ED_bin_df[row, 25]) || occursin("for safety reasons", ED_bin_df[row, 26]) || occursin("for safety reasons", ED_bin_df[row, 27]) || occursin("for safety reasons", ED_bin_df[row, 28])
        ED_bin_df[row, 102] = "yes"
    else
        ED_bin_df[row, 102] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 103])
    if occursin("without using prescription hormones", ED_bin_df[row, 20]) || occursin("without using prescription hormones", ED_bin_df[row, 21]) || occursin("without using prescription hormones", ED_bin_df[row, 22]) || occursin("without using prescription hormones", ED_bin_df[row, 23]) || occursin("without using prescription hormones", ED_bin_df[row, 24]) || occursin("without using prescription hormones", ED_bin_df[row, 25]) || occursin("without using prescription hormones", ED_bin_df[row, 26]) || occursin("without using prescription hormones", ED_bin_df[row, 27]) || occursin("without using prescription hormones", ED_bin_df[row, 28])
        ED_bin_df[row, 103] = "yes"
    else
        ED_bin_df[row, 103] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 104])
    if occursin("without having surgical procedures", ED_bin_df[row, 20]) || occursin("without having surgical procedures", ED_bin_df[row, 21]) || occursin("without having surgical procedures", ED_bin_df[row, 22]) || occursin("without having surgical procedures", ED_bin_df[row, 23]) || occursin("without having surgical procedures", ED_bin_df[row, 24]) || occursin("without having surgical procedures", ED_bin_df[row, 25]) || occursin("without having surgical procedures", ED_bin_df[row, 26]) || occursin("without having surgical procedures", ED_bin_df[row, 27]) || occursin("without having surgical procedures", ED_bin_df[row, 28])
        ED_bin_df[row, 104] = "yes"
    else
        ED_bin_df[row, 104] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 105])
    if occursin("To suppress menstruation", ED_bin_df[row, 20]) || occursin("To suppress menstruation", ED_bin_df[row, 21]) || occursin("To suppress menstruation", ED_bin_df[row, 22]) || occursin("To suppress menstruation", ED_bin_df[row, 23]) || occursin("To suppress menstruation", ED_bin_df[row, 24]) || occursin("To suppress menstruation", ED_bin_df[row, 25]) || occursin("To suppress menstruation", ED_bin_df[row, 26]) || occursin("To suppress menstruation", ED_bin_df[row, 27]) || occursin("To suppress menstruation", ED_bin_df[row, 28])
        ED_bin_df[row, 105] = "yes"
    else
        ED_bin_df[row, 105] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 106])
    if occursin("stress or anxiety", ED_bin_df[row, 20]) || occursin("stress or anxiety", ED_bin_df[row, 21]) || occursin("stress or anxiety", ED_bin_df[row, 22]) || occursin("stress or anxiety", ED_bin_df[row, 23]) || occursin("stress or anxiety", ED_bin_df[row, 24]) || occursin("stress or anxiety", ED_bin_df[row, 25]) || occursin("stress or anxiety", ED_bin_df[row, 26]) || occursin("stress or anxiety", ED_bin_df[row, 27]) || occursin("stress or anxiety", ED_bin_df[row, 28])
        ED_bin_df[row, 106] = "yes"
    else
        ED_bin_df[row, 106] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 107])
    if occursin("depression", ED_bin_df[row, 20]) || occursin("depression", ED_bin_df[row, 21]) || occursin("depression", ED_bin_df[row, 22]) || occursin("depression", ED_bin_df[row, 23]) || occursin("depression", ED_bin_df[row, 24]) || occursin("depression", ED_bin_df[row, 25]) || occursin("depression", ED_bin_df[row, 26]) || occursin("depression", ED_bin_df[row, 27]) || occursin("depression", ED_bin_df[row, 28])
        ED_bin_df[row, 107] = "yes"
    else
        ED_bin_df[row, 107] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 108])
    if occursin("trauma", ED_bin_df[row, 20]) || occursin("trauma", ED_bin_df[row, 21]) || occursin("trauma", ED_bin_df[row, 22]) || occursin("trauma", ED_bin_df[row, 23]) || occursin("trauma", ED_bin_df[row, 24]) || occursin("trauma", ED_bin_df[row, 25]) || occursin("trauma", ED_bin_df[row, 26]) || occursin("trauma", ED_bin_df[row, 27]) || occursin("trauma", ED_bin_df[row, 28])
        ED_bin_df[row, 108] = "yes"
    else
        ED_bin_df[row, 108] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 109])
    if occursin("To numb emotional pain", ED_bin_df[row, 20]) || occursin("To numb emotional pain", ED_bin_df[row, 21]) || occursin("To numb emotional pain", ED_bin_df[row, 22]) || occursin("To numb emotional pain", ED_bin_df[row, 23]) || occursin("To numb emotional pain", ED_bin_df[row, 24]) || occursin("To numb emotional pain", ED_bin_df[row, 25]) || occursin("To numb emotional pain", ED_bin_df[row, 26]) || occursin("To numb emotional pain", ED_bin_df[row, 27]) || occursin("To numb emotional pain", ED_bin_df[row, 28])
        ED_bin_df[row, 109] = "yes"
    else
        ED_bin_df[row, 109] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 110])
    if occursin("To exert control", ED_bin_df[row, 20]) || occursin("To exert control", ED_bin_df[row, 21]) || occursin("To exert control", ED_bin_df[row, 22]) || occursin("To exert control", ED_bin_df[row, 23]) || occursin("To exert control", ED_bin_df[row, 24]) || occursin("To exert control", ED_bin_df[row, 25]) || occursin("To exert control", ED_bin_df[row, 26]) || occursin("To exert control", ED_bin_df[row, 27]) || occursin("To exert control", ED_bin_df[row, 28])
        ED_bin_df[row, 110] = "yes"
    else
        ED_bin_df[row, 110] = "no"
    end
end

for row in 1:length(ED_bin_df[!, 111])
    if occursin("To satisfy a compulsion", ED_bin_df[row, 20]) || occursin("To satisfy a compulsion", ED_bin_df[row, 21]) || occursin("To satisfy a compulsion", ED_bin_df[row, 22]) || occursin("To satisfy a compulsion", ED_bin_df[row, 23]) || occursin("To satisfy a compulsion", ED_bin_df[row, 24]) || occursin("To satisfy a compulsion", ED_bin_df[row, 25]) || occursin("To satisfy a compulsion", ED_bin_df[row, 26]) || occursin("To satisfy a compulsion", ED_bin_df[row, 27]) || occursin("To satisfy a compulsion", ED_bin_df[row, 28])
        ED_bin_df[row, 111] = "yes"
    else
        ED_bin_df[row, 111] = "no"
    end
end

## add empty column for trans fem/trans masc/enby
ED_bin_df = insertcols!(ED_bin_df, 112, :trans_sort => "N/A", makeunique=false)

for row in 1:length(ED_bin_df[!, 112])
    if ED_bin_df[row, 78] == "yes"
        ED_bin_df[row, 112] = "nonbinary"
    elseif ED_bin_df[row, 86] == "yes"
        ED_bin_df[row, 112] = "trans-fem"
    elseif ED_bin_df[row, 87] == "yes"
        ED_bin_df[row, 112] = "trans-masc"
    else
        ED_bin_df[row, 112] = "N/A"
    end
end

## add empty columns for GMSR scoring
ED_bin_df = insertcols!(ED_bin_df, 113, :disc_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 114, :reject_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 115, :vict_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 116, :current_disc_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 117, :current_reject_score => 0.00, makeunique=false)
ED_bin_df = insertcols!(ED_bin_df, 118, :current_vict_score => 0.00, makeunique=false)


# iterate through GMSR questions to fill out score columns
for row in 1:length(ED_bin_df[!, 113])
    if occursin("Yes, in the past year", ED_bin_df[row, 48]) 
        ED_bin_df[row, 113] = 1.00
        ED_bin_df[row, 116] = 1.00
    elseif occursin("Yes", ED_bin_df[row, 48])
        ED_bin_df[row, 113] = 1.00
        ED_bin_df[row, 116] = 0.00
    else
        ED_bin_df[row, 113] = 0.00
        ED_bin_df[row, 116] = 0.00
    end
end

for row in 1:length(ED_bin_df[!, 113])
    if occursin("Yes, in the past year", ED_bin_df[row, 49]) 
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 49])
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 0.00
    else
        ED_bin_df[row, 113] += 0.00
        ED_bin_df[row, 116] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 113])
    if occursin("Yes, in the past year", ED_bin_df[row, 50]) 
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 50])
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 0.00
    else
        ED_bin_df[row, 113] += 0.00
        ED_bin_df[row, 116] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 113])
    if occursin("Yes, in the past year", ED_bin_df[row, 51]) 
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 51])
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 0.00
    else
        ED_bin_df[row, 113] += 0.00
        ED_bin_df[row, 116] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 113])
    if occursin("Yes, in the past year", ED_bin_df[row, 52]) 
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 52])
        ED_bin_df[row, 113] += 1.00
        ED_bin_df[row, 116] += 0.00
    else
        ED_bin_df[row, 113] += 0.00
        ED_bin_df[row, 116] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 114])
    if occursin("Yes, in the past year", ED_bin_df[row, 53]) 
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 53])
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 0.00
    else
        ED_bin_df[row, 114] += 0.00
        ED_bin_df[row, 117] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 114])
    if occursin("Yes, in the past year", ED_bin_df[row, 54]) 
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 54])
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 0.00
    else
        ED_bin_df[row, 114] += 0.00
        ED_bin_df[row, 117] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 114])
    if occursin("Yes, in the past year", ED_bin_df[row, 55]) 
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 55])
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 0.00
    else
        ED_bin_df[row, 114] += 0.00
        ED_bin_df[row, 117] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 114])
    if occursin("Yes, in the past year", ED_bin_df[row, 56]) 
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 56])
        ED_bin_df[row, 114] += 1.00
        ED_bin_df[row, 117] += 0.00
    else
        ED_bin_df[row, 114] += 0.00
        ED_bin_df[row, 117] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 115])
    if occursin("Yes, in the past year", ED_bin_df[row, 57]) 
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 57])
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 0.00
    else
        ED_bin_df[row, 115] += 0.00
        ED_bin_df[row, 118] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 115])
    if occursin("Yes, in the past year", ED_bin_df[row, 58]) 
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 58])
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 0.00
    else
        ED_bin_df[row, 115] += 0.00
        ED_bin_df[row, 118] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 115])
    if occursin("Yes, in the past year", ED_bin_df[row, 59]) 
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 59])
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 0.00
    else
        ED_bin_df[row, 115] += 0.00
        ED_bin_df[row, 118] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 115])
    if occursin("Yes, in the past year", ED_bin_df[row, 60]) 
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 60])
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 0.00
    else
        ED_bin_df[row, 115] += 0.00
        ED_bin_df[row, 118] += 0.00
    end
end

for row in 1:length(ED_bin_df[!, 115])
    if occursin("Yes, in the past year", ED_bin_df[row, 61]) 
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 1.00
    elseif occursin("Yes", ED_bin_df[row, 61])
        ED_bin_df[row, 115] += 1.00
        ED_bin_df[row, 118] += 0.00
    else
        ED_bin_df[row, 115] += 0.00
        ED_bin_df[row, 118] += 0.00
    end
end

CSV.write("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/cleaned_survey.csv", ED_bin_df)

#create new dataframe to keep track of totals for ED dx and self-id stratified by trans vs cis
dx_id_df = DataFrame()

dx_id_df.cis_ed_dx = ["pica_cis_dx", "rumination_cis_dx", "arfid_cis_dx", "anorexia_cis_dx", "bulimia_cis_dx", "binge_cis_dx", "osfed_cis_dx", "ufed_cis_dx", "other_cis_dx"]
dx_id_df.cis_ed_dx_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.unsure_ed_dx = ["pica_unsure_dx", "rumination_unsure_dx", "arfid_unsure_dx", "anorexia_unsure_dx", "bulimia_unsure_dx", "binge_unsure_dx", "osfed_unsure_dx", "ufed_unsure_dx", "other_unsure_dx"]
dx_id_df.unsure_ed_dx_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.trans_ed_dx = ["pica_trans_dx", "rumination_trans_dx", "arfid_trans_dx", "anorexia_trans_dx", "bulimia_trans_dx", "binge_trans_dx", "osfed_trans_dx", "ufed_trans_dx", "other_trans_dx"]
dx_id_df.trans_ed_dx_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.cis_ed_id = ["pica_cis_id", "rumination_cis_id", "arfid_cis_id", "anorexia_cis_id", "bulimia_cis_id", "binge_cis_id", "osfed_cis_id", "ufed_cis_id", "other_cis_id"]
dx_id_df.cis_ed_id_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.unsure_ed_id = ["pica_unsure_id", "rumination_unsure_id", "arfid_unsure_id", "anorexia_unsure_id", "bulimia_unsure_id", "binge_unsure_id", "osfed_unsure_id", "ufed_unsure_id", "other_unsure_id"]
dx_id_df.unsure_ed_id_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.trans_ed_id = ["pica_trans_id", "rumination_trans_id", "arfid_trans_id", "anorexia_trans_id", "bulimia_trans_id", "binge_trans_id", "osfed_trans_id", "ufed_trans_id", "other_trans_id"]
dx_id_df.trans_ed_id_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.total_ed_dx = ["pica_total_dx", "rumination_total_dx", "arfid_total_dx", "anorexia_total_dx", "bulimia_total_dx", "binge_total_dx", "osfed_total_dx", "ufed_total_dx", "other_total_dx"]
dx_id_df.total_ed_dx_value = [0,0,0,0,0,0,0,0,0]
dx_id_df.total_ed_id = ["pica_total_id", "rumination_total_id", "arfid_total_id", "anorexia_total_id", "bulimia_total_id", "binge_total_id", "osfed_total_id", "ufed_total_id", "other_total_id"]
dx_id_df.total_ed_id_value = [0,0,0,0,0,0,0,0,0]

#iterate through ED dx question to fill out dx_id_df columns
for row in 1:length(ED_bin_df[!, 14])
    if occursin("Pica", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[1, 2] += 1
        dx_id_df[1, 14] += 1
    elseif occursin("Pica", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[1, 4] += 1
        dx_id_df[1, 14] += 1
    elseif occursin("Pica", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[1, 6] += 1
        dx_id_df[1, 14] += 1
    elseif occursin("Rumination Disorder", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[2, 2] += 1
        dx_id_df[2, 14] += 1
    elseif occursin("Rumination Disorder", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[2, 4] += 1
        dx_id_df[2, 14] += 1
    elseif occursin("Rumination Disorder", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[2, 6] += 1
        dx_id_df[2, 14] += 1
    elseif occursin("ARFID", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[3, 2] += 1
        dx_id_df[3, 14] += 1
    elseif occursin("ARFID", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[3, 4] += 1
        dx_id_df[3, 14] += 1
    elseif occursin("ARFID", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[3, 6] += 1
        dx_id_df[3, 14] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[4, 2] += 1
        dx_id_df[4, 14] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[4, 4] += 1
        dx_id_df[4, 14] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[4, 6] += 1
        dx_id_df[4, 14] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[5, 2] += 1
        dx_id_df[5, 14] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[5, 4] += 1
        dx_id_df[5, 14] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[5, 6] += 1
        dx_id_df[5, 14] += 1
    elseif occursin("Binge", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[6, 2] += 1
        dx_id_df[6, 14] += 1
    elseif occursin("Binge", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[6, 4] += 1
        dx_id_df[6, 14] += 1
    elseif occursin("Binge", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[6, 6] += 1
        dx_id_df[6, 14] += 1
    elseif occursin("OSFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[7, 2] += 1
        dx_id_df[7, 14] += 1
    elseif occursin("OSFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[7, 4] += 1
        dx_id_df[7, 14] += 1
    elseif occursin("OSFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[7, 6] += 1
        dx_id_df[7, 14] += 1
    elseif occursin("UFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[8, 2] += 1
        dx_id_df[8, 14] += 1
    elseif occursin("UFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[8, 4] += 1
        dx_id_df[8, 14] += 1
    elseif occursin("UFED", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[8, 6] += 1
        dx_id_df[8, 14] += 1
    elseif occursin("Other", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="No"
        dx_id_df[9, 2] += 1
        dx_id_df[9, 14] += 1
    elseif occursin("Other", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[9, 4] += 1
        dx_id_df[9, 14] += 1
    elseif occursin("Other", ED_bin_df[row, 14]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[9, 6] += 1
        dx_id_df[9, 14] += 1
    end
end

#iterate through ED self-id question to fill out dx_id_df columns
for row in 1:length(ED_bin_df[!, 15])
    if occursin("Pica", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[1, 8] += 1
        dx_id_df[1, 16] += 1
    elseif occursin("Pica", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[1, 10] += 1
        dx_id_df[1, 16] += 1
    elseif occursin("Pica", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[1, 12] += 1
        dx_id_df[1, 16] += 1
    elseif occursin("Rumination", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[2, 8] += 1
        dx_id_df[2, 16] += 1
    elseif occursin("Rumination", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[2, 10] += 1
        dx_id_df[2, 16] += 1
    elseif occursin("Rumination", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[2, 12] += 1
        dx_id_df[2, 16] += 1
    elseif occursin("ARFID", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[3, 8] += 1
        dx_id_df[3, 16] += 1
    elseif occursin("ARFID", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[3, 10] += 1
        dx_id_df[3, 16] += 1
    elseif occursin("ARFID", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[3, 12] += 1
        dx_id_df[3, 16] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[4, 8] += 1
        dx_id_df[4, 16] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[4, 10] += 1
        dx_id_df[4, 16] += 1
    elseif occursin("Anorexia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[4, 12] += 1
        dx_id_df[4, 16] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[5, 8] += 1
        dx_id_df[5, 16] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[5, 10] += 1
        dx_id_df[5, 16] += 1
    elseif occursin("Bulimia", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[5, 12] += 1
        dx_id_df[5, 16] += 1
    elseif occursin("Binge", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[6, 8] += 1
        dx_id_df[6, 16] += 1
    elseif occursin("Binge", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[6, 10] += 1
        dx_id_df[6, 16] += 1
    elseif occursin("Binge", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[6, 12] += 1
        dx_id_df[6, 16] += 1
    elseif occursin("OSFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[7, 8] += 1
        dx_id_df[7, 16] += 1
    elseif occursin("OSFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[7, 10] += 1
        dx_id_df[7, 16] += 1
    elseif occursin("OSFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[7, 12] += 1
        dx_id_df[7, 16] += 1
    elseif occursin("UFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[8, 8] += 1
        dx_id_df[8, 16] += 1
    elseif occursin("UFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[8, 10] += 1
        dx_id_df[8, 16] += 1
    elseif occursin("UFED", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[8, 12] += 1
        dx_id_df[8, 16] += 1
    elseif occursin("Other", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="No"
        dx_id_df[9, 8] += 1
        dx_id_df[9, 16] += 1
    elseif occursin("Other", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Unsure/Questioning"
        dx_id_df[9, 10] += 1
        dx_id_df[9, 16] += 1
    elseif occursin("Other", ED_bin_df[row, 15]) && ED_bin_df[row, 2]=="Yes"
        dx_id_df[9, 12] += 1
        dx_id_df[9, 16] += 1
    end
end



CSV.write("/Users/Sy/Documents/Trans_ED_Research/Trans ED Research/ed_dx_id.csv", dx_id_df)
 