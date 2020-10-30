import csv

def Parse(file: str):
    with open(file) as fin:
        csvreader = csv.reader(fin)
        x = 0
        return [row for row in csvreader]


def main():
    a = int
    b = a("21")
    print(b)
    Parse("datasets\Brazil\olist_customers_dataset.csv")

if __name__ == "__main__":
    main()