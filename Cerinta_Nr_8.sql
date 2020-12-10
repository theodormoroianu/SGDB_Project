-- Autor: Moroianu Theodor
-- Date: 12.12.2020
-- Cerinta: Cerinta nr 8

-- Compania a decis sa isi verifice stocul diferitor produse.
-- Pentru acesta, a rugat departamentul de IT sa puna managerilor
-- magazinelor la dispozitie o functie de SQL, care sa efectueze
-- urmatoarele calcule:
--     Managerul isi introduce ID-ul, magazinul pe care il conduce
--       si ID-ul produsului de care este interesat.
--     Functia se asigura ca managerul este intr-adevar manager in
--       magazinul cu ID-ul mentionat (cum functia de SQL este folosita
--       in cadrul altor aplicatii putem sa presupunem ca un angajat nu
--       poate introduce alt ID decat al sau).
--     Daca managerul este validat, atunci functia intoarce cantitatea
--       disponibila a produsului respectiv.

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION CheckStockInStore(
    UserId                    NUMBER,
    StoreId                   NUMBER,
    ProductId                 NUMBER)
RETURN VARCHAR2
AS
    productExists             NUMBER;
    disponibility             NUMBER;
    realStoreManager          NUMBER;
    productName               VARCHAR2(100);
BEGIN
    -- Verific cine este managerul magazinului.
    SELECT managerId
        INTO realStoreManager
        FROM magazin
        WHERE magazinId = StoreId;
    
    -- Daca nu este managerul, arunci ma opresc.
    IF realStoreManager <> UserId THEN
        RETURN 'Nu aveti voie sa acesati aceasta informatie!';
    END IF;
    
    -- Extrag numele produsului.
    SELECT nume
        INTO productName
        FROM produs
        WHERE produsId = productId;
        
    -- Verific daca mai exista un produs.
    SELECT COUNT(1)
        INTO productExists
        FROM disponibilitateMagazin
        WHERE produsId = productId
            AND magazinId = storeId;
    
    -- Produsul exista.
    -- Incerc sa extrag cantitatea disponibila.
    IF productExists = 1 THEN
        SELECT cantitateDisponibila
            INTO disponibility
            FROM disponibilitateMagazin
            WHERE produsId = productId
                AND magazinId = storeId;
        -- Exista produse in stoc.
        IF disponibility > 0 THEN
            RETURN 'Produsul ' || productName || ' mai are ' ||
                    disponibility || ' unitati disponibile.';
        END IF;
    END IF;
    
    -- Daca am ajuns aici, inseamna ca fie nu exista
    -- produsul in `disponibilitateMagazin`, fie are 
    -- cantitatea disponibila egala cu 0.
    return 'Produsul ' || productName ||
            ' nu are nicio unitate disponibila!';
EXCEPTION
    -- Nu pot da de `TOO_MANY_ROWS` pentru ca fac un queryuri
    -- pe chei primare, dar pot sa dau de `NO_DATA_FOUND`.
    WHEN NO_DATA_FOUND THEN
        RETURN 'Datele furnizate nu sunt valide!';
END;
/

SELECT * FROM magazin
WHERE magazinID = 1;
SELECT * FROM disponibilitatemagazin;

-- Apelarea functiei cu date valide.
SELECT CheckStockInStore(57, 1, 30)
FROM DUAL;

-- Apelarea functiei cu un user care nu este manager.
SELECT CheckStockInStore(58, 1, 30)
FROM DUAL;

-- Apelarea functiei cu un produs care nu mai este disponibil.
SELECT CheckStockInStore(57, 1, 56)
FROM DUAL;

-- Apelarea functiei cu un produs care nu exista.
SELECT CheckStockInStore(57, 1, 10000)
FROM DUAL;

-- Apelarea functiei cu un user care nu exista.
SELECT CheckStockInStore(1000, 1, 30)
FROM DUAL;

-- Apelarea functiei cu un magazin care nu exista.
SELECT CheckStockInStore(10, 1000, 30)
FROM DUAL;
