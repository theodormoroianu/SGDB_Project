import csv
import random

# Constants used for creating the DB
LOCATIE_COUNT = 2000
FURNIZOR_COUNT, MAGAZIN_COUNT = [100, 100]
CUMPARATOR_COUNT = 1000
ANGAJAT_COUNT = 500
PRODUS_COUNT = 3000
VANZARE_COUNT = 3000
CONTINUT_VANZARE_COUNT = 5000
REVIEW_COUNT = 1000

# citiy -> 1, country -> 4, ...
cities = None
# name -> 0
first_names, last_names = None, None
# product -> 3, description -> 10
products = None
# company -> 0, website -> 1
companies = None
# rating -> 0, review -> 1
reviews = None
# date -> 0
dates = None
# address -> 0
addresses = None
fout = open("PopulateDataBase.sql", "w", encoding='cp850')



# Parses a csv file and returns it as a matrix.
# First row contains the name of the columns.
def Parse(file: str):
    with open(file, encoding='cp850') as fin:
        csv_reader = csv.reader(fin)
        return [row for row in csv_reader][1:]

def ParseData():
    global cities, first_names, last_names, products, companies, reviews, dates, addresses

    cities = Parse("datasets\\worldcities.csv")
    first_names = Parse("datasets\\first_names.csv")
    last_names = Parse("datasets\\last_names.csv")
    products = Parse("datasets\\products.csv")
    companies = Parse("datasets\\companies.csv")
    reviews = Parse("datasets\\reviews.csv")
    dates = Parse("datasets\\dates.csv")
    addresses = Parse("datasets\\addresses.csv")

def GetDate():
    date = random.choice(dates)[0]
    return "TO_DATE('" + date + "', 'YYYY-MM-DD HH24:MI:SS')"

def GetTelefon():
    return "0" + str(700000000 + random.randint(0, 100000000))

def CreateLocatie():
    fout.write("\n\n -- Populating table `locatie`\n")
    for i in range(LOCATIE_COUNT):
        adresa = random.choice(addresses)[0]
        city = random.choice(cities)
        oras, tara = city[0], city[4]
        fout.write("INSERT INTO locatie VALUES("
                    + str(i) + ", '" + adresa + "', '" +
                    oras + "', '" + tara + "');\n")

def CreateCumparator():
    fout.write("\n\n -- Populating table `cumparator`\n")
    for i in range(CUMPARATOR_COUNT):
        nume = random.choice(first_names)[0]
        prenume = random.choice(last_names)[0]
        varsta = random.randint(18, 50)
        puncte_fidelitate = random.randint(0, 10000)
        locatieID = random.randint(0, LOCATIE_COUNT - 1)
        dataCreareCont = GetDate()
        telefon = GetTelefon()
        fout.write("INSERT INTO cumparator VALUES(" +
                    str(i) + ", '" +
                    nume + "', '" +
                    prenume + "', " +
                    str(varsta) + ", " + 
                    str(puncte_fidelitate) + ", " +
                    str(locatieID) + ", " +
                    dataCreareCont + ", '" +
                    telefon + "');\n")

def CreateProdus():
    fout.write("\n\n -- Populating table `produs`\n")
    for i in range(PRODUS_COUNT):
        prod = random.choice(products)
        nume = prod[3]
        description = prod[10]
        fout.write("INSERT INTO produs VALUES(" +
                    str(i) + ", '" +
                    nume + "', NULL);\n")


def CreateFurnisor():
    fout.write("\n\n -- Populating table `furnizor`\n")
    for i in range(FURNIZOR_COUNT):
        nume = random.choice(companies)[0]
        dataincepere = GetDate()
        telefon = GetTelefon()
        locatieID = random.randint(0, LOCATIE_COUNT - 1)
        fout.write("INSERT INTO furnizor VALUES(" +
                    str(i) + ", '" +
                    nume + "', " +
                    dataincepere + ", '" +
                    telefon + "', " +
                    str(locatieID) + ");\n")
    

def main():
    # Parse data from csvs
    ParseData()

    # CreateLocatie()
    # CreateCumparator()
    # CreateProdus()
    CreateFurnisor()

if __name__ == "__main__":
    main()