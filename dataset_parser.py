import csv
import random

# Constants used for creating the DB
LOCATIE_COUNT = 200
FURNIZOR_COUNT, MAGAZIN_COUNT = [20, 10]
CUMPARATOR_COUNT = 1000
ANGAJAT_COUNT = 100
PRODUS_COUNT = 500
VANZARE_COUNT = 3000
CONTINUT_VANZARE_COUNT = 5000
REVIEW_COUNT = 100
CONTINUT_FURNIZARE_COUNT = 1000
FURNIZARE_COUNT = 100
DISPONIBILITATE_FURNIZOR_COUNT = 300
DISPONIBILITATE_MAGAZIN_COUNT = 1000


# citiy -> 1, country -> 4, ...
cities = None
# name -> 0
first_names, last_names = None, None
# product -> 3, description -> 10
products, cost_produts = None, None
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
    global cost_produts
    cost_produts = [random.randint(100, 1000000) for _ in range(PRODUS_COUNT)]


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
    
def CreateAngajatMagazin():
    fout.write("\n\n -- Populating table Angajat")
    fout.write(" -- Disable fk\n")
    fout.write("ALTER TABLE angajat\n    DISABLE CONSTRAINT angajatfkmagazin;\n\n")

    ids = [i for i in range(ANGAJAT_COUNT)]
    random.shuffle(ids)

    for i in range(ANGAJAT_COUNT):
        nume = random.choice(last_names)[0]
        prenume = random.choice(first_names)[0]
        salariu = 10000 - random.randint(1, 10 * i + 1)
        DataAngajare = GetDate()
        magazinid = "NULL" if i == 0 else str(i - 1)
        manager = "NULL" if i == 0 else str(ids[0])

        if i > MAGAZIN_COUNT:
            m = random.randint(1, MAGAZIN_COUNT)
            manager = str(ids[m])
            magazinid = str(m - 1)
        
        fout.write("INSERT INTO angajat VALUES(" +
                    str(ids[i]) + ", '" +
                    nume + "', '" +
                    prenume + "', " +
                    magazinid + ", " + 
                    manager + ", " +
                    str(salariu) + ", " +
                    DataAngajare + ");\n")

    fout.write("\n\n -- Populating Magazin\n")

    for i in range(MAGAZIN_COUNT):    
        fout.write("INSERT INTO magazin VALUES(" +
                    str(i) + ", " +
                    str(random.randint(0, LOCATIE_COUNT - 1)) + ", " +
                    str(ids[i + 1]) + ", " +
                    GetDate() + ");\n")

    fout.write("\nALTER TABLE angajat\n    ENABLE CONSTRAINT angajatfkmagazin;\n")

def CreateFurnizare():
    furnizare = [1 for i in range(FURNIZARE_COUNT)]
    for i in range(FURNIZARE_COUNT, CONTINUT_FURNIZARE_COUNT):
        furnizare[random.randint(0, FURNIZARE_COUNT - 1)] += 1

    fout.write("\n\nPopulating furnizare, continut_furnizare and disponibilitate_furnizor\n\n")
    
    for i in range(FURNIZARE_COUNT):
        continut = [i for i in range(PRODUS_COUNT)]
        random.shuffle(continut)
        continut = continut[0:furnizare[i]]
        cost = [cost_produts[i] + random.randint(-50, 50) for i in continut]
        cantitate = [random.randint(1, 10) for i in cost]

        suma = 0
        for j in range(furnizare[i]):
            suma += cost[j] * cantitate[j]

        fout.write("INSERT INTO furnizare VALUES(" +
                    str(i) + ", " +
                    str(random.randint(0, MAGAZIN_COUNT - 1)) + ", " +
                    str(suma) + ", " +
                    str(random.randint(0, FURNIZOR_COUNT)) + ");\n")
        
        for j in range(furnizare[i]):
            fout.write("INSERT INTO continutfurnizare VALUES(" +
                        str(i) + ", " +
                        str(continut[j]) + ", " +
                        str(cantitate[j]) + ", " +
                        str(cost[j]) + ");\n")

    added = {}
    for i in range(DISPONIBILITATE_FURNIZOR_COUNT):
        while True:
            f = random.randint(0, FURNIZOR_COUNT - 1)
            p = random.randint(0, PRODUS_COUNT - 1)
            if (f, p) in added:
                continue

            added[(f, p)] = None
            fout.write("INSERT INTO disponibilitatefurnizor VALUES(" +
                        str(f) + ", " + str(p) + ", " +
                        str(random.randint(1, 1000)) + ", " +
                        str(random.randint(-50, 50) + cost_produts[p]) +
                        ");\n")
            break


def CreateDisponibilitateMagazin():
    added = {}
    for i in range(DISPONIBILITATE_MAGAZIN_COUNT):
        while True:
            f = random.randint(0, MAGAZIN_COUNT - 1)
            p = random.randint(0, PRODUS_COUNT - 1)
            if (f, p) in added:
                continue

            added[(f, p)] = None

            fout.write("INSERT INTO disponibilitatemagazin VALUES(" +
                        str(p) + ", " + str(f) + ", " +
                        str(random.randint(1, 1000)) + ", " +
                        str(random.randint(-50, 50) + cost_produts[p]) +
                        ");\n")
            break

def CreateVanzare():
    vanzare = [1 for i in range(VANZARE_COUNT)]
    for i in range(VANZARE_COUNT, CONTINUT_VANZARE_COUNT):
        vanzare[random.randint(0, VANZARE_COUNT - 1)] += 1

    for i in range(VANZARE_COUNT):
        continut = [i for i in range(PRODUS_COUNT)]
        random.shuffle(continut)
        continut = continut[0:vanzare[i]]
        cost = [cost_produts[i] + random.randint(-50, 50) for i in continut]
        cantitate = [random.randint(1, 10) for i in cost]

        suma = 0
        for j in range(vanzare[i]):
            suma += cost[j] * cantitate[j]

        fout.write("INSERT INTO vanzare VALUES(" +
                    str(i) + ", " +
                    str(random.randint(0, MAGAZIN_COUNT - 1)) + ", " +
                    str(random.randint(0, CUMPARATOR_COUNT)) + ", " +
                    GetDate() + ", " + 
                    str(suma) + ");\n")
        
        for j in range(vanzare[i]):
            fout.write("INSERT INTO continutvanzare VALUES(" +
                        str(i) + ", " +
                        str(continut[j]) + ", " +
                        str(cost[j]) + ", " +
                        str(cantitate[j]) + ");\n")
            if (random.randint(1, 7) == 1):
                rev = random.choice(reviews)
                
                fout.write("INSERT INTO review VALUES(" +
                            str(i) + ", " +
                            str(continut[j]) + ", " +
                            rev[0] + ", '" +
                            rev[1] + "');\n")
                            
def main():
    # Parse data from csvs
    ParseData()

    CreateLocatie()
    CreateCumparator()
    CreateProdus()
    CreateFurnisor()
    CreateAngajatMagazin()
    CreateFurnizare()
    CreateVanzare()
    CreateDisponibilitateMagazin()

    fout.write("\nCOMMIT;\n")

if __name__ == "__main__":
    main()