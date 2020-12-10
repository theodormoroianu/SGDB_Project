# Calcuelaza al k-lea numar fibbonacci (modulo 1000000)
def Fibb(n: int):
    if n <= 1:
        return n
    return (Fibb(n - 1) + Fibb(n - 2)) % 1000000000

# Numar de numere prime in intervalul 2-n
def CountPrimes(n: int):
    ciur = [False for i in range(n + 1)]
    raspuns = 0
    for i in range(2, n + 1):
        if not ciur[i]:
            for j in range(i, n + 1, i):
                ciur[j] = True
            raspuns += 1
    return raspuns

print(CountPrimes(30000000))
# print(Fibb(40))