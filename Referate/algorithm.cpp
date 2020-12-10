#include <iostream>
#include <vector>
using namespace std;

// Calcuelaza al k-lea numar fibbonacci (modulo 1000000)
int Fibb(int n)
{
    if (n <= 1)
        return n;
    return (Fibb(n - 1) + Fibb(n - 2)) % 1000000000;
}


// Numar de numere prime in intervalul 2-n
int CountPrimes(int n)
{
    vector <bool> ciur(n + 1);
    int raspuns = 0;
    for (int i = 2; i <= n; i++) {
        if (!ciur[i]) {
            for (int j = i; j <= n; j += i)
                ciur[j] = 1;
            raspuns++;
        }
    }
    return raspuns;
}

int main()
{

    cout << CountPrimes(20000000) << '\n';
    // cout << Fibb(40) << '\n';
    return 0;
}
