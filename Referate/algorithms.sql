-- Autor: Theodor Moroianu
-- Data: 26/11/2020

SET SERVEROUTPUT ON;


-- Functie care calculeaza al k-lea numar fibbonacci, modulo 10^9
CREATE OR REPLACE FUNCTION Fibb
    (n          INTEGER)
RETURN INTEGER
IS    
BEGIN
    IF n <= 1 THEN
        RETURN n;
    END IF;
    RETURN MOD(Fibb(n - 1) + Fibb(n - 2), 1000000000);
END;
/

-- Functie care calculeaza numarul de numere prime in intervalul [2-n]
CREATE OR REPLACE FUNCTION CountPrimes
    (n          INTEGER)
RETURN INTEGER
IS
    TYPE vector IS VARRAY(100000000) OF BOOLEAN;
    ciur    vector := vector();
    ans     BINARY_INTEGER;
    indice  BINARY_INTEGER;
BEGIN
    ans := 0;
    FOR i IN 1..n LOOP
        ciur.extend;
        ciur(i) := False;
    END LOOP;
    FOR i IN 2..n LOOP
        IF ciur(i) = False THEN
            ans := ans + 1;
            indice := i;
            WHILE indice <= n LOOP
                ciur(indice) := True;
                indice := indice + i;
            END LOOP;
        END IF;
    END LOOP;
    RETURN ans;
END;
/



DECLARE
    ans     INTEGER;
    val     INTEGER := 40;
BEGIN
    ans := Fibb(val);
    DBMS_OUTPUT.PUT_LINE('Fibb(' || val || ') = ' || ans);
END;
/

DECLARE
    ans     INTEGER;
    val     INTEGER := 30000000;
BEGIN
    ans := CountPrimes(val);
    DBMS_OUTPUT.PUT_LINE('CountPrimes(' || val || ') = ' || ans);
END;
/
