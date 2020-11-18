import pandas as pd
import requests
import json
import csv
import time
import datetime


## https://medium.com/@RareLoot/using-pushshifts-api-to-extract-reddit-submissions-fb517b286563




def getPushshiftData(after, before, sub):
    url = 'https://api.pushshift.io/reddit/search/submission/?&size=1000&after='+str(after)+'&before='+str(before)+'&subreddit='+str(sub)
    print(url)
    r = requests.get(url)
    data = json.loads(r.text)
    return data['data']

def collectSubData(subm):
    subData = list() #list to store data points
    title =subm['title']
    try:
        body = ' '+subm['selftext']
    except KeyError:
        body = 'NaN'
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


## transgender
sub='transgender'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("transgender_posts.csv")

## asktransgender

sub='asktransgender'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("asktransgender_posts.csv")


## genderqueer

sub='genderqueer'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("genderqueer_posts.csv")


## NonBinary

sub='NonBinary'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("NonBinary_posts.csv")


## transpassing

sub='transpassing'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("transpassing_posts.csv")


## FTMFitness

sub='FTMFitness'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("FTMFitness_posts.csv")



## EatingDisorders

sub='EatingDisorders'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("EatingDisorders_posts.csv")


## EDAnonymous

sub='EDAnonymous'
#before and after dates
before = "1577836799" #Dec 31, 2019 11:59 pm
after = "1546300801"  #Jan 1, 2019 12:00 am
subCount = 0
subStats = {}


data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the 'after' date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount+=1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(len(data))

updateSubs_file("EDAnonymous_posts.csv")
