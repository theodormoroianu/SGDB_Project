-- Autor: Moroianu Theodor
-- Date: 5.1.2021
-- Cerinta: Cerinta nr 13

SET SERVEROUTPUT ON;

-- Used in ex 7
CREATE TABLE CostBonus (
    angajatId       NUMBER PRIMARY KEY,
    numarAngajati   NUMBER,
    sumaSalarii     NUMBER);

CREATE OR REPLACE PACKAGE ProiectTmo AS
    -- Ex 6
    PROCEDURE PrintPromotion;

    -- Ex 7
    PROCEDURE ComputeCostBonus(
    angajatBonusId            NUMBER,
    numarAngajati   IN OUT    NUMBER,
    sumaSalarii     IN OUT    NUMBER);
    
    PROCEDURE CresteSalariuSubordonati(
    angajatMarireId           NUMBER,
    marireSalariu             NUMBER);
    
    FUNCTION PremiazaAngajati(
    numarMinimAngajati        NUMBER,
    marireSalariu             NUMBER)
    RETURN      NUMBER;
    
    -- Ex 8
    FUNCTION CheckStockInStore(
        UserId                    NUMBER,
        StoreId                   NUMBER,
        ProductId                 NUMBER)
    RETURN VARCHAR2;

    -- Ex 9
    PROCEDURE PrintReviewMessages (
    buyerId                   NUMBER,
    ProductId                 NUMBER);
    
END ProiectTmo;
/

CREATE OR REPLACE PACKAGE BODY ProiectTmo AS
    -- Ex 6
    PROCEDURE PrintPromotion
    IS
        type Tablou IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
        
        pretMinimProduse        Tablou;
        achizitiiClient         Tablou;
        contor                  NUMBER;
        
        -- Valuarea minima din doua valori.
        FUNCTION MyMin (
            a   NUMBER,
            b   NUMBER)
        RETURN NUMBER
        IS BEGIN
            IF a < b THEN
                RETURN b;
            END IF;
            return b;
        END MyMin;
        
        -- Returneaza numele unui produs.
        FUNCTION ProductName (
            produs_id_c NUMBER)
        RETURN VARCHAR2
        IS
            nume_p    VARCHAR2(1000);
        BEGIN
            SELECT nume
                INTO nume_p
                FROM produs
                WHERE produs_id_c = produsId;
            RETURN nume_p;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('A aparut o eroare!');
                RETURN 'Name not found';
        END ProductName;
        
        -- Functie care returneaza pentru un client
        -- care sunt preturile platite pentru produsele
        -- din ultima achizitie.
        FUNCTION UltimaAchizitieClient (
            c_id    NUMBER)
        RETURN Tablou 
        IS
            v           Tablou;
            vanzare     NUMBER;
        BEGIN
            SELECT *
                INTO vanzare
                FROM (SELECT vanzareId
                      FROM vanzare
                      WHERE cumparatorId = c_id
                      ORDER BY DataVanzare DESC)
                WHERE ROWNUM = 1;
                
            FOR cont IN (SELECT *
                            FROM ContinutVanzare cv
                            WHERE vanzareId = vanzare) LOOP
                v(cont.ProdusId) := cont.PretUnitar;
            END LOOP;
            return v;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN v;
        END UltimaAchizitieClient;
        
        -- Functie care returneaza cel mai ieftin pret
        -- al unui produs existent.
        FUNCTION PretMinimInStoc
        RETURN Tablou 
        IS
            v           Tablou;
        BEGIN
            FOR disponibil IN (SELECT *
                                    FROM DisponibilitateMagazin) LOOP
                IF v.EXISTS(disponibil.produsid) THEN
                    v(disponibil.produsid) := MyMin(v(disponibil.produsid), disponibil.pretunitar);
                ELSE
                    v(disponibil.produsid) := disponibil.pretunitar;
                END IF;
            END LOOP;
            return v;
        END PretMinimInStoc;
        
    BEGIN
        pretMinimProduse := PretMinimInStoc;
        
        FOR cumparator IN (SELECT * FROM cumparator) LOOP
            achizitiiClient := UltimaAchizitieClient(cumparator.cumparatorId);
            contor := 0;
            
            IF achizitiiClient.COUNT = 0 THEN
                CONTINUE;
            END IF;
            
            FOR i IN achizitiiClient.First .. AchizitiiClient.Last LOOP
                IF pretMinimProduse.EXISTS(i) AND achizitiiClient.EXISTS(i) AND
                        pretMinimProduse(i) < achizitiiClient(i) THEN
                    contor := contor + 1;
                END IF;
            END LOOP;
            
            -- Are reduceri.
            IF contor <> 0 THEN
                DBMS_OUTPUT.PUT_LINE('Draga ' || cumparator.prenume || ', de cand nu ai mai fost pe la\n' ||
                        'noi produsele pe care le-ai cumparat s-au ieftinit:');
                FOR i IN achizitiiClient.First .. AchizitiiClient.Last LOOP
                    IF pretMinimProduse.EXISTS(i) AND achizitiiClient.EXISTS(i) AND
                            pretMinimProduse(i) < achizitiiClient(i) THEN
                        DBMS_OUTPUT.PUT_LINE('    Ai cumparat un ' || ProductName(i) ||
                                ' la pretul de ' || achizitiiClient(i) || ', dar acum este la ' ||
                                ' pretul exceptional de doar ' || pretMinimProduse(i) || '!');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END PrintPromotion;

    -- Ex 7
    PROCEDURE ComputeCostBonus(
        angajatBonusId            NUMBER,
        numarAngajati   IN OUT    NUMBER,
        sumaSalarii     IN OUT    NUMBER) 
    AS
        numarAngajatiIntern       NUMBER;
        sumaSalariiIntern         NUMBER;
    BEGIN
        -- Setez valorile parametrilor interni.
        numarAngajatiIntern := 1;
        SELECT salariu
            INTO sumaSalariiIntern
            FROM angajat a
            WHERE a.angajatId = angajatBonusId;
            
        -- Apelez recursiv pentru toti subordonatii directi.
        FOR subordonat IN (SELECT *
                              FROM angajat a
                              WHERE managerId = angajatBonusId) LOOP
            ComputeCostBonus(subordonat.angajatId,
                             numarAngajatiIntern,
                             sumaSalariiIntern);
        END LOOP;
        
        -- Salvez informatiile legate de `angajatBonusId` in tabel.
        INSERT INTO CostBonus
            VALUES(angajatBonusId,
                   numarAngajatiIntern,
                   SumaSalariiIntern);
        
        -- Updatez variabilele de IN/OUT.
        numarAngajati := numarAngajati + numarAngajatiIntern;
        sumaSalarii := sumaSalarii + sumaSalariiIntern;
        
    EXCEPTION
        -- Nu pot da de `TOO_MANY_ROWS` pentru ca fac un query
        -- pe cheia primara, dar pot sa dau de `NO_DATA_FOUND`.
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('AngajatId neasteptat: ' ||
                                 'Nu exista niciun angajat cu id-ul ' ||
                                 angajatBonusId || '!');
    END ComputeCostBonus;
    
    PROCEDURE CresteSalariuSubordonati(
        angajatMarireId           NUMBER,
        marireSalariu             NUMBER)
    AS
    BEGIN
        -- Cresc salariul angajatului.
        UPDATE angajat
            SET salariu = salariu * (1 + marireSalariu / 100)
            WHERE angajatId = angajatMarireId; 
        
        -- Apelez recursiv pentru toti subordonatii directi.
        FOR subordonat IN (SELECT *
                              FROM angajat a
                              WHERE a.managerId = angajatMarireId) LOOP
            CresteSalariuSubordonati(subordonat.angajatId, marireSalariu);
        END LOOP;
        
        -- Nu exista nicio exceptie pe care putem sa o intalnim.    
    END CresteSalariuSubordonati;
    
    FUNCTION PremiazaAngajati(
        numarMinimAngajati        NUMBER,
        marireSalariu             NUMBER)
    RETURN      NUMBER
    AS
        numarAngajati           NUMBER;
        sumaSalarii             NUMBER;
        angajatBonus            CostBonus%ROWTYPE;
        totalPlata              NUMBER;
    BEGIN
        numarAngajati := 0;
        sumaSalarii := 0;
        
        -- Recalculez tabelul CostBonus
        DELETE CostBonus;
        FOR ang IN (SELECT * FROM angajat) LOOP
            IF ang.managerId IS NULL THEN
                -- CEO of the company
                ComputeCostBonus(ang.angajatId, numarAngajati, sumaSalarii);
            END IF;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('Au fost gasiti ' || numarAngajati ||
                ' angajati, cu un salariu total de ' || sumaSalarii || '!');
                
        -- Caut combinatia de cost minim, care totusi sa aiba cel putin
        -- `numarAngajati` oameni.
        SELECT *
            INTO angajatBonus
            FROM (SELECT *
                    FROM CostBonus
                    WHERE numarAngajati >= numarMinimAngajati
                    ORDER BY sumaSalarii ASC)
            WHERE ROWNUM=1;
        
        -- Cresc salariile subordonatilor lui angajatBonus.angajatId
        CresteSalariuSubordonati(angajatBonus.angajatId, marireSalariu);
        totalPlata := angajatBonus.sumaSalarii * marireSalariu / 100;
        DBMS_OUTPUT.PUT_LINE('Suma salariilor a crescut cu ' || totalPlata || '!');
        
        RETURN totalPlata;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista asa multi angajati!');
            RETURN -1;
    END PremiazaAngajati;
    
    -- Ex 8
    FUNCTION CheckStockInStore(
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
    END CheckStockInStore;
    
    -- Ex 9
    PROCEDURE PrintReviewMessages (
        buyerId                   NUMBER,
        ProductId                 NUMBER)
    AS
        boughtPrice               NUMBER;
        currentPrice              NUMBER;
        averageReview             NUMBER;
        productName               VARCHAR2(100);
        buyerName                 VARCHAR2(100);
    BEGIN
        -- Extrag numele produsului.
        SELECT nume
            INTO productName
            FROM produs
            WHERE produsId = productId;
        
        -- Extrag numele cumparatorului
        SELECT nume || ' ' || prenume
            INTO buyerName
            FROM cumparator
            WHERE cumparatorId = buyerId;
            
        -- Extrag cel mai mare pret la care a fost cumparat produsul.
        SELECT MAX(pretUnitar)
            INTO boughtPrice
            FROM continutVanzare cv JOIN vanzare v ON (cv.vanzareId = v.vanzareId)
                WHERE v.cumparatorId = buyerId
                    AND cv.produsId = ProductId;
        
        -- Extrag pretul minim al produsului.
        SELECT MIN(pretUnitar)
            INTO currentPrice
            FROM disponibilitateMagazin
            WHERE produsId = ProductId
                AND cantitateDisponibila > 0;
        
        -- Nu a cumparat niciodata produsul.
        IF boughtPrice IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Produsul nu a fost niciodata cumparat!');
            RETURN;
        END IF;
        
        -- Extrag reviewul mediu.
        SELECT AVG(rating)
            INTO averageReview
            FROM review
            WHERE produsId = ProductId;
        
        IF averageReview IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Produsul nu are niciun rating!');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Draga ' || buyerName || ', iti aduci aminte cand ai cumparat un ' ||
                productName || ' la pretul de ' || boughtPrice || '?');
        DBMS_OUTPUT.PUT_LINE('Produsul are acum un review de ' || averageReview || ' stele, si poate '
                || ' fi cumparat la doar ' || currentPrice || '!');
    EXCEPTION
        -- Nu pot da de `TOO_MANY_ROWS` pentru ca fac un queryuri
        -- pe chei primare, dar pot sa dau de `NO_DATA_FOUND`.
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Datele furnizate nu sunt valide!');
    END PrintReviewMessages;
END ProiectTmo;
/

-- Ex 6
Execute ProiectTmo.PrintPromotion;

-- Ex 7
DECLARE
    dePlatit        NUMBER;
BEGIN
    dePlatit := ProiectTmo.PremiazaAngajati(&NumarMinimAngajati, &ProcentCrestereSalariu);
    DBMS_OUTPUT.put_line('Salariile au fost crescute optim, dar aveti de platit ' || dePlatit);
END;
/

-- Ex 8
-- Apelarea functiei cu date valide.
SELECT ProiectTmo.CheckStockInStore(57, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un user care nu este manager.
SELECT ProiectTmo.CheckStockInStore(58, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un produs care nu mai este disponibil.
SELECT ProiectTmo.CheckStockInStore(57, 1, 56)
FROM DUAL
UNION
-- Apelarea functiei cu un produs care nu exista.
SELECT ProiectTmo.CheckStockInStore(57, 1, 10000)
FROM DUAL
UNION
-- Apelarea functiei cu un user care nu exista.
SELECT ProiectTmo.CheckStockInStore(1000, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un magazin care nu exista.
SELECT ProiectTmo.CheckStockInStore(10, 1000, 30)
FROM DUAL;

-- Ex 9
-- Apeleaza metoda cu date valide.
EXECUTE PrintReviewMessages(793, 330);

-- Apeleaza metoda cu un cumparator inexistent.
EXECUTE PrintReviewMessages(100000, 330);

-- Apeleaza metoda cu un produs inexistent.
EXECUTE PrintReviewMessages(793, 10000);

-- Apeleaza metoda cu un produs care nu a fost cumparat.
EXECUTE PrintReviewMessages(793, 104);
