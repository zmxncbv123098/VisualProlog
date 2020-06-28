from bs4 import BeautifulSoup
import requests
import json
import csv
import time
import random
from random import randint

def getAllGenres():
    g = []
    d = {}
    with open("film.pl", "r") as f:
        for i in f.readlines():
            for j in (i[i.find("(") + 1:i.rfind(")")]).split('"')[-2].split(","):
                if j.lower().replace(" ", "") not in g:
                    g.append(j.lower().replace(" ", ""))

        for i in range(len(g)):
            d[g[i]] = i + 1
        for i in d.items():
            print("genre(", end='')
            print(i[1], end=', ')
            print(i[0], end=").\n")
        print(d)
        return d


def getFilmsFormIMDB():
    url = "https://www.imdb.com/chart/top/"

    html = requests.get(url).text

    soup = BeautifulSoup(html, "lxml")

    td = soup.find_all('td', {'class': 'titleColumn'})
    for i in range(1, len(td) + 1):
        imdbId = td[i].find('a').get("href")[7:-1]
        url = "http://www.omdbapi.com/?apikey=e1ef5580&i=%s" % imdbId
        text = requests.get(url).text

        m = json.loads(text)

        print("film(", end='')
        print(i, end=', ')
        print('"', m["Title"], '"', sep='', end=', ')
        print('"', m['Released'], '"', sep='', end=', ')
        print('"', m['Director'], '"', sep='', end=').;')
        print('"', m["Genre"], '"', sep='')


def editCSVfile():
    with open('495.csv', "r") as csvfile:
        print(csvfile.readline())
        spamreader = csv.reader(csvfile, delimiter=';')
        for row in spamreader:
            print("cinema(", end='')
            print(row[0], end=', ')  # ID
            print('"', row[1], '"', sep='', end=', ')  # NAME
            print('"', row[2], '"', sep='', end=', ')  # ADRESS
            print('"', row[7], '"', sep='', end=', ')  # TELEPHONE
            print(row[-2], end=', ')  # LAT
            print(row[-1], end=').\n')  # LON


def str_time_prop(start, end, format, prop):
    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(format, time.localtime(ptime))


def random_date(start, end, prop):
    return str_time_prop(start, end, '%m/%d/%Y %I:%M %p', prop)


def createShows(showsNumForEach, filmNum):
    for i in range(1, 159+1):  # 159 - number of cinemas
        for j in range(showsNumForEach):  # how many shows for each cinema
            fullDate = random_date("1/1/2019 1:30 PM", "1/1/2020 4:50 AM", random.random())
            # showing(idCINEMA, idFILM, DATE, TIME)
            print("showing(", i, ", ", randint(1, filmNum), ', "', str(fullDate[:fullDate.find(" ")]), '", "',
                  str(fullDate[fullDate.find(" ") + 1:]), '").\n', sep='', end='')


def filmsAndTheirGenres():
    a = getAllGenres()
    with open("filmsMinusGenre.txt", "r") as p:
        for i in p.readlines():
            print(i.split(";")[0])
            for j in i.split(";")[1].lower().replace('"', "").replace(" ", "").replace("\n", "").split(','):
                print("filmGenre(", i.split(";")[0][i.find("(") + 1:i.find(",")], ",", a[j], ").", sep='')


createShows(5, 249)
