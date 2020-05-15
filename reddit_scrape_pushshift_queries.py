import pandas as pd
import requests
import json
import csv
import time
import datetime


## https://medium.com/@RareLoot/using-pushshifts-api-to-extract-reddit-submissions-fb517b286563




def getPushshiftData(query, sub):
    url = 'https://api.pushshift.io/reddit/search/submission/?title='+str(query)+'&size=1000&subreddit='+str(sub)
    print(url)
    r = requests.get(url)
    data = json.loads(r.text)
    return data['data']

def collectSubData(subm):
    subData = list() #list to store data points
    #  '"' +
    title =subm['title']
    try:
        body = ' '+subm['selftext']
        # + '"'
    except KeyError:
        body = 'NaN'
        # '"'
    text = title + body
    url = subm['url']
    author = subm['author']
    sub_id = subm['id']
    score = subm['score']
    created = datetime.datetime.fromtimestamp(subm['created_utc']) #1520561700.0
    numComms = subm['num_comments']
    permalink = subm['permalink']


    subData.append((sub_id,text,url,author,score,created,numComms,permalink))
    subStats[sub_id] = subData


def updateSubs_file(filename):
    upload_count = 0
    location = "/Users/Apple/Documents/Trans_ED_Research/posts/"
    file = location + filename
    with open(file, 'w', newline='', encoding='utf-8') as file:
        a = csv.writer(file, delimiter=',')
        headers = ["Post_ID","Text","Url","Author","Score","Publish Date","Total No. of Comments","Permalink"]
        a.writerow(headers)
        for sub in subStats:
            a.writerow(subStats[sub][0])
            upload_count+=1

        print(str(upload_count) + " submissions have been uploaded")


## transgender body
sub='transgender'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transgender_body_posts.csv")

## transgender dysphori
sub='transgender'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transgender_dysphori_posts.csv")

## transgender weigh
sub='transgender'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transgender_weigh_posts.csv")

## transgender diet
sub='transgender'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transgender_diet_posts.csv")


## asktransgender body
sub='asktransgender'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("asktransgender_body_posts.csv")

## asktransgender dysphori
sub='asktransgender'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("asktransgender_dysphori_posts.csv")

## asktransgender weigh
sub='asktransgender'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("asktransgender_weigh_posts.csv")

## asktransgender diet
sub='asktransgender'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("asktransgender_diet_posts.csv")


## genderqueer body
sub='genderqueer'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("genderqueer_body_posts.csv")

## genderqueer dysphori
sub='genderqueer'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("genderqueer_dysphori_posts.csv")

## genderqueer weigh
sub='genderqueer'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("genderqueer_weigh_posts.csv")

## genderqueer diet
sub='genderqueer'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("genderqueer_diet_posts.csv")


## NonBinary body
sub='NonBinary'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("NonBinary_body_posts.csv")

## NonBinary dysphori
sub='NonBinary'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("NonBinary_dysphori_posts.csv")

## NonBinary weigh
sub='NonBinary'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("NonBinary_weigh_posts.csv")

## transgender diet
sub='NonBinary'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("NonBinary_diet_posts.csv")

## transpassing body
sub='transpassing'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transpassing_body_posts.csv")

## transpassing dysphori
sub='transpassing'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transpassing_dysphori_posts.csv")

## transpassing weigh
sub='transpassing'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transpassing_weigh_posts.csv")

## transpassing diet
sub='transpassing'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("transpassing_diet_posts.csv")


## FTMFitness body
sub='FTMFitness'
#before and after dates
query = 'body'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("FTMFitness_body_posts.csv")

## FTMFitness dysphori
sub='FTMFitness'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("FTMFitness_dysphori_posts.csv")

## FTMFitness weigh
sub='FTMFitness'
#before and after dates
query = 'weight'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("FTMFitness_weigh_posts.csv")

## FTMFitness diet
sub='FTMFitness'
#before and after dates
query = 'diet'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("FTMFitness_diet_posts.csv")


## EatingDisorders gender
sub='EatingDisorders'
#before and after dates
query = 'gender'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("EatingDisorders_gender_posts.csv")

## EatingDisorders dysphori
sub='EatingDisorders'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("EatingDisorders_dysphori_posts.csv")

## EDAnonymous gender
sub='EDAnonymous'
#before and after dates
query = 'gender'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("EDAnonymous_gender_posts.csv")

## EDAnonymous dysphori
sub='EDAnonymous'
#before and after dates
query = 'dysphoria'
subCount = 0
subStats = {}


data = getPushshiftData(query, sub)

for submission in data:
    collectSubData(submission)
    subCount+=1


updateSubs_file("EDAnonymous_dysphori_posts.csv")
