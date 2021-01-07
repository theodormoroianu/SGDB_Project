-- Autor: Moroianu Theodor
-- Data: 5.1.2021

-- Ex 4
CREATE TABLE locatie (
    locatieID NUMBER PRIMARY KEY,
    adresa VARCHAR2(100),
    oras VARCHAR2(50),
    tara VARCHAR2(30));

CREATE TABLE furnizor (
    furnizorID NUMBER PRIMARY KEY,
    nume VARCHAR2(100),
    dataIncepereParteneriat DATE,
    telefon VARCHAR2(10),
    locatieID NUMBER,
    FOREIGN KEY (locatieID) REFERENCES locatie(locatieID) ON DELETE SET NULL);
    
CREATE TABLE angajat (
    angajatID NUMBER PRIMARY KEY,
    nume VARCHAR2(50),
    prenume VARCHAR2(50),
    magazinID NUMBER,
    managerID NUMBER,
    salariu NUMBER,
    dataAngajare Date,
    FOREIGN KEY (managerID) REFERENCES angajat(angajatID) ON DELETE SET NULL);
    
CREATE TABLE magazin (
    magazinID NUMBER PRIMARY KEY,
    locatieID NUMBER,
    managerID Number,
    dataDeschidere Date,
    FOREIGN KEY (managerID) REFERENCES angajat(angajatID) ON DELETE SET NULL,
    FOREIGN KEY (locatieID) REFERENCES locatie(locatieID) ON DELETE SET NULL);

ALTER TABLE angajat
    ADD CONSTRAINT angajatfkmagazin FOREIGN KEY (magazinID) REFERENCES magazin(magazinID);
    
CREATE TABLE produs (
    produsID NUMBER PRIMARY KEY,
    nume VARCHAR2(200),
    descriere VARCHAR2(200));
    
CREATE TABLE cumparator (
    cumparatorID NUMBER PRIMARY KEY,
    nume VARCHAR2(100),
    prenume VARCHAR2(100),
    varsta NUMBER,
    puncteFidelitate NUMBER,
    locatieID NUMBER,
    dataCreareCont DATE,
    telefon NUMBER(10),
    FOREIGN KEY (locatieID) REFERENCES locatie(locatieID) ON DELETE SET NULL);
    
CREATE TABLE vanzare (
    vanzareID NUMBER PRIMARY KEY,
    magazinID NUMBER,
    cumparatorID NUMBER,
    dataVanzare DATE,
    pretTotal NUMBER NOT NULL,
    FOREIGN KEY (magazinID) REFERENCES magazin(magazinID) ON DELETE SET NULL,
    FOREIGN KEY (cumparatorID) REFERENCES cumparator(cumparatorID) ON DELETE CASCADE);

CREATE TABLE continutVanzare (
    vanzareID NUMBER,
    produsID NUMBER,
    pretUnitar NUMBER NOT NULL,
    cantitate NUMBER NOT NULL,
    PRIMARY KEY (vanzareID, produsID),
    FOREIGN KEY (vanzareID) REFERENCES vanzare(vanzareID) ON DELETE CASCADE,
    FOREIGN KEY (produsID) REFERENCES produs(produsID) ON DELETE SET NULL);

CREATE TABLE review (
    vanzareID NUMBER,
    produsID NUMBER,
    rating NUMBER NOT NULL,
    comentariu VARCHAR2(1000),
    PRIMARY KEY (vanzareID, produsID),
    FOREIGN KEY (vanzareID) REFERENCES vanzare(vanzareID) ON DELETE CASCADE,
    FOREIGN KEY (produsID) REFERENCES produs(produsID) ON DELETE SET NULL,
    CHECK (rating >= 1 AND rating <= 5));
    
CREATE TABLE disponibilitateMagazin (
    produsID NUMBER,
    magazinID NUMBER,
    cantitateDisponibila NUMBER NOT NULL,
    pretUnitar NUMBER NOT NULL,
    PRIMARY KEY (produsID, magazinID),
    FOREIGN KEY (produsID) REFERENCES produs(produsID) ON DELETE CASCADE,
    FOREIGN KEY (magazinID) REFERENCES magazin(magazinID) ON DELETE CASCADE,
    CHECK (cantitateDisponibila >= 0),
    CHECK (pretUnitar > 0));
    
CREATE TABLE disponibilitateFurnizor (
    furnizorID NUMBER,
    produsID NUMBER,
    stocDisponibil NUMBER NOT NULL,
    pretUnitar NUMBER,
    PRIMARY KEY (furnizorID, produsID),
    FOREIGN KEY (furnizorID) REFERENCES furnizor(furnizorID) ON DELETE CASCADE,
    FOREIGN KEY (produsID) REFERENCES produs(produsID) ON DELETE CASCADE);
    
CREATE TABLE furnizare (
    furnizareID NUMBER PRIMARY KEY,
    magazinID NUMBER,
    pretTotal NUMBER NOT NULL,
    furnizorID NUMBER,
    FOREIGN KEY (furnizorID) REFERENCES furnizor(furnizorID) ON DELETE SET NULL,
    FOREIGN KEY (magazinID) REFERENCES magazin(magazinID) ON DELETE CASCADE,
    CHECK (pretTotal > 0));
    
CREATE TABLE continutFurnizare (
    furnizareID NUMBER,
    produsID NUMBER,
    cantitate NUMBER NOT NULL,
    pretUnitar NUMBER NOT NULL,
    PRIMARY KEY (furnizareID, produsID),
    FOREIGN KEY (furnizareID) REFERENCES furnizare(furnizareID) ON DELETE CASCADE,
    FOREIGN KEY (produsID) REFERENCES produs(produsID) ON DELETE SET NULL,
    CHECK (cantitate > 0 AND pretUnitar > 0));

-- Ex 5
-- Pentru a popula baza de date am creat un script de `Python` cu ajutorul caruia am creat fisierul
-- PopulateDataBase.sql, cu ajutorul caruia introduc 13.000 de inregistrari in baza de date.

-- Din motive evidente am decis sa nu il includ in acest document, fiind disponibil [aici](https://github.com/theodormoroianu/SGDB_Project/blob/main/PopulateDataBase.sql).
-- Un esantilon ar fi:

INSERT INTO locatie VALUES(0, '300 W PINE AVE', 'Ravne na Koroškem', 'Slovenia');
INSERT INTO locatie VALUES(1, '2296 N FREMONT BLVD', 'Taltal', 'Chile');
INSERT INTO locatie VALUES(2, '108 W CEDAR AVE', 'Market Weighton', 'United Kingdom');
INSERT INTO locatie VALUES(3, '1815 N SAN FRANCISCO ST', 'Flossmoor', 'United States');
INSERT INTO locatie VALUES(4, '2750 W DARLEEN DR', 'Swartz Creek', 'United States');
INSERT INTO locatie VALUES(5, '1519 E GAVIN LN', 'Lansing', 'United States');
INSERT INTO locatie VALUES(6, '2393 W ZEPHER AVE', 'Murcia', 'Spain');
INSERT INTO locatie VALUES(7, '775 N FOREST VIEW DR', 'Lugano', 'Switzerland');
INSERT INTO locatie VALUES(8, '3009 W BRENDA LP', 'Zeulenroda', 'Germany');
INSERT INTO locatie VALUES(9, '3826 N FOREST BROOK ST', 'Tripoli', 'Libya');
INSERT INTO locatie VALUES(10, '3876 N FOREST BROOK ST', 'Saint John’s', 'Antigua And Barbuda');
INSERT INTO locatie VALUES(11, '3391 N ESTATES ST', 'Nuevitas', 'Cuba');
INSERT INTO locatie VALUES(12, '2021 N CENTER ST', 'Las Veredas', 'Mexico');
INSERT INTO locatie VALUES(13, '417 W JUNIPER AVE', 'Néa Péramos', 'Greece');
INSERT INTO locatie VALUES(14, '3328 N PARK DR', 'Jánoshalma', 'Hungary');
INSERT INTO locatie VALUES(15, '3707 N LOMA VISTA DR', 'Oruro', 'Bolivia');
INSERT INTO locatie VALUES(16, '910 N TURQUOISE DR', 'Dingelstädt', 'Germany');
INSERT INTO locatie VALUES(17, '2338 E DEL RAE DR', 'Wiesloch', 'Germany');
INSERT INTO locatie VALUES(18, '3027 S TROXLER CIR', 'Steamboat Springs', 'United States');
INSERT INTO locatie VALUES(19, '3867 S BOX CANYON TRL', 'Velence', 'Hungary');
-- ....
INSERT INTO angajat VALUES(42, 'Lalinde', 'Chloe', NULL, NULL, 9999, TO_DATE('2018-08-29 17:15:27', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(80, 'Elvington', 'Thomasena', 0, 42, 9997, TO_DATE('2017-11-29 03:50:37', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(57, 'Cihon', 'Jolanda', 1, 42, 9998, TO_DATE('2017-12-22 18:01:37', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(50, 'Ouch', 'Buffy', 2, 42, 9977, TO_DATE('2018-07-19 19:45:10', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(54, 'Toenjes', 'Alexia', 3, 42, 9984, TO_DATE('2017-10-19 18:35:18', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(3, 'Deglow', 'Brandy', 4, 42, 9999, TO_DATE('2017-10-26 02:56:34', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(15, 'Yount', 'Solomon', 5, 42, 9999, TO_DATE('2018-08-08 17:30:23', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(39, 'Everleth', 'Kaitlin', 6, 42, 9947, TO_DATE('2018-08-06 14:04:19', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(13, 'Starken', 'Ouida', 7, 42, 9995, TO_DATE('2018-05-14 20:54:52', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(41, 'Vaquero', 'Nobuko', 8, 42, 9920, TO_DATE('2017-03-15 14:44:36', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(32, 'Matsuzaki', 'Merrilee', 9, 42, 9999, TO_DATE('2018-04-25 13:10:27', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(44, 'Caccavale', 'Rosendo', 5, 15, 9938, TO_DATE('2017-04-28 16:05:17', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(99, 'Villela', 'Dori', 4, 3, 9959, TO_DATE('2017-04-17 03:50:21', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(61, 'Kossman', 'Estela', 4, 3, 9886, TO_DATE('2018-02-22 07:10:33', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(65, 'Daubs', 'Arlinda', 8, 41, 9886, TO_DATE('2017-11-07 18:10:26', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO angajat VALUES(45, 'Albu', 'Fredricka', 1, 57, 9922, TO_DATE('2018-08-07 17:20:08', 'YYYY-MM-DD HH24:MI:SS'));
-- ....
INSERT INTO review VALUES(218, 343, 4, 'Awesome product, looks genuine original');
INSERT INTO vanzare VALUES(219, 6, 683, TO_DATE('2017-05-08 21:32:15', 'YYYY-MM-DD HH24:MI:SS'), 1340538);
INSERT INTO continutvanzare VALUES(219, 446, 978786, 1);
INSERT INTO continutvanzare VALUES(219, 122, 361752, 1);
INSERT INTO vanzare VALUES(220, 5, 187, TO_DATE('2018-08-14 16:05:15', 'YYYY-MM-DD HH24:MI:SS'), 4779454);
INSERT INTO continutvanzare VALUES(220, 316, 938926, 4);
INSERT INTO review VALUES(220, 316, 3, 'FLAVOR WAS GOOD, TASTE TOO BUT MOST OF THE BISCUITS IN THE PACK WERE BROKEN .THIS IS DUE TO POOR HANDLING AND TRANSPORT BY THE SUPPLIER I SUPPOSE');
INSERT INTO continutvanzare VALUES(220, 151, 146250, 7);
INSERT INTO vanzare VALUES(221, 5, 499, TO_DATE('2017-11-27 03:59:21', 'YYYY-MM-DD HH24:MI:SS'), 5438412);
INSERT INTO continutvanzare VALUES(221, 384, 842117, 6);
INSERT INTO review VALUES(221, 384, 3, 'Look niceLight weightBut after 6-8 month its not working properly... Sometimes its ohk sometimes its automatically slower');
INSERT INTO continutvanzare VALUES(221, 110, 385710, 1);
INSERT INTO vanzare VALUES(222, 0, 773, TO_DATE('2018-05-08 22:30:30', 'YYYY-MM-DD HH24:MI:SS'), 389466);
INSERT INTO continutvanzare VALUES(222, 235, 389466, 1);
INSERT INTO vanzare VALUES(223, 8, 727, TO_DATE('2018-04-16 00:49:49', 'YYYY-MM-DD HH24:MI:SS'), 15532285);
INSERT INTO continutvanzare VALUES(223, 54, 733325, 7);
INSERT INTO continutvanzare VALUES(223, 67, 860218, 2);
-- ....
INSERT INTO disponibilitatemagazin VALUES(299, 3, 862, 623525);
INSERT INTO disponibilitatemagazin VALUES(47, 6, 384, 434975);
INSERT INTO disponibilitatemagazin VALUES(75, 4, 785, 601924);
INSERT INTO disponibilitatemagazin VALUES(1, 7, 462, 382492);
INSERT INTO disponibilitatemagazin VALUES(420, 5, 566, 580345);
INSERT INTO disponibilitatemagazin VALUES(302, 1, 357, 157974);
INSERT INTO disponibilitatemagazin VALUES(424, 0, 971, 674998);
INSERT INTO disponibilitatemagazin VALUES(349, 2, 39, 931221);
INSERT INTO disponibilitatemagazin VALUES(383, 0, 868, 529510);
INSERT INTO disponibilitatemagazin VALUES(98, 8, 539, 261794);
INSERT INTO disponibilitatemagazin VALUES(480, 3, 468, 641473);
INSERT INTO disponibilitatemagazin VALUES(405, 4, 857, 276682);
INSERT INTO disponibilitatemagazin VALUES(359, 5, 863, 949630);
-- ....

-- Tot fisierul poate fi gasit aici: https://github.com/theodormoroianu/SGDB_Project/blob/main/PopulateDataBase.sql
-- Scriptul cu care a fost generat poate fi gasit aici: https://github.com/theodormoroianu/SGDB_Project/blob/main/dataset_parser.py

-- Ex 6
-- Autor: Moroianu Theodor
-- Date: 27.11.2020
-- Cerinta: Cerinta nr 6

-- Compania vrea sa organizeze o campanie de promotie de craciun.
-- Pentru aceasta campanie, compania doreste sa ii trimita fiecarui
-- cumparator un mesaj de tipul "De cand nu ai mai fost pe la noi
-- produsele pe care le-ai cumparat ultima data s-au ieftinit:
--      Ai cumparat produsul X la Y dar acum il poti cumpara la Z ...".
-- Evident, campania aceasta este facuta doar pentru a atrage clientii,
-- deci presupunem ca pretul unui produs este costul cel mai ieftin al
-- produsului in oricare dintre magazinele in care este in stoc.

-- Subprogramul definit jos de tot, prin apeluri la functiile definite
-- tot aici, foloseste un tip de colectie studiat.

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PrintPromotion
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
END;
/

EXECUTE PrintPromotion;

-- Cerinta 7 -- Subprogram Care Sa Utilizeze Un Cursor
-- Autor: Moroianu Theodor
-- Date: 25.11.2020
-- Cerinta: Cerinta nr 7

-- Compania a decis sa dea bonus de craciun angajatilor.
-- Evident, nu are asa multi bani de cheltuit, asa ca doreste sa 
-- cheltuie cat mai putini.
-- Astfel compania a decis sa premieze un angajat, subordonatii sai
-- directi, subordonatii acestora etc. In termeni tehnici compania
-- doreste sa premieze un subarbore din arborele angajatilor.
-- Premiul consta din cresterea salariului cu X%, unde X este ales
-- de CEO (pe ascuns, ca sa nu comenteze lumea ca e prea mic).
-- Pe de alta parte, ca sa nu comenteze angajatii, trebuie sa
-- fie premiati cel putin Y angajati.
-- Care sunt cele mai bune Z alegeri de premiere a angajatilor?

-- Subprogramul definit jos de tot, prin apeluri la functiile definite
-- tot aici, foloseste cursoare implicite.

SET SERVEROUTPUT ON;

-- Tabel in care salvez costul de-a alege
-- fiecare angajat ca "sursa" a bonusului,
-- impreuna cu numarul de angajati afectati.
CREATE TABLE CostBonus (
    angajatId       NUMBER PRIMARY KEY,
    numarAngajati   NUMBER,
    sumaSalarii     NUMBER);


-- Functie recursiva care populeaza tabelul CostBonus.
CREATE OR REPLACE PROCEDURE ComputeCostBonus(
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
END;
/

-- Procedura care creste salariile subordonatiilor unui angajat cu X%.
CREATE OR REPLACE PROCEDURE CresteSalariuSubordonati(
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
END;
/


-- Functie care efectueaza darea bonusului.
-- Functia returneaza costul total al cresterii, sau -1 daca nu
-- poate fi efectuata cresterea.
CREATE OR REPLACE FUNCTION PremiazaAngajati(
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
END;
/


-- Apelarea functiei.
DECLARE
    dePlatit        NUMBER;
BEGIN
    dePlatit := PremiazaAngajati(&NumarMinimAngajati, &ProcentCrestereSalariu);
    DBMS_OUTPUT.put_line('Salariile au fost crescute optim, dar aveti de platit ' || dePlatit);
END;
/


-- Cerinta 8 -- Subprogram Care Sa Utilizeze 3 Tabele
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


-- Apelarea functiei cu date valide.
SELECT CheckStockInStore(57, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un user care nu este manager.
SELECT CheckStockInStore(58, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un produs care nu mai este disponibil.
SELECT CheckStockInStore(57, 1, 56)
FROM DUAL
UNION
-- Apelarea functiei cu un produs care nu exista.
SELECT CheckStockInStore(57, 1, 10000)
FROM DUAL
UNION
-- Apelarea functiei cu un user care nu exista.
SELECT CheckStockInStore(1000, 1, 30)
FROM DUAL
UNION
-- Apelarea functiei cu un magazin care nu exista.
SELECT CheckStockInStore(10, 1000, 30)
FROM DUAL;

-- Cerinta 9 -- Subprogram Care Sa Utilizeze 5 Tabele
-- Autor: Moroianu Theodor
-- Date: 12.12.2020
-- Cerinta: Cerinta nr 9

-- Compania a decis sa faca o noua campanie promotionala.
-- Astfel, pentru fiecare cumparator trebuie sa afisam urmatorul
-- mesaj:
-- "Draga XXXX, pe data de YYYY ai cumparat produsul ZZZZ la pretul VVV 
-- care are un review mediu de TTTT, si il poti cumpara la un pret de UUUU".
-- Bine inteles, pentru a face un astfel de mesaj trebuie ca produsul
-- sa aiba cel putin un review, si sa fie disponibil in cel putin un
-- magazin.


SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PrintReviewMessages (
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
END;
/

SELECT *
FROM vanzare v JOIN continutVanzare cv ON (cv.vanzareid = v.vanzareid);

-- Apeleaza metoda cu date valide.
EXECUTE PrintReviewMessages(793, 330);

-- Apeleaza metoda cu un cumparator inexistent.
EXECUTE PrintReviewMessages(100000, 330);

-- Apeleaza metoda cu un produs inexistent.
EXECUTE PrintReviewMessages(793, 10000);

-- Apeleaza metoda cu un produs care nu a fost cumparat.
EXECUTE PrintReviewMessages(793, 104);


-- Cerinta 10 -- Trigger De Tip LMD
-- Autor: Moroianu Theodor
-- Date: 22.12.2020
-- Cerinta: Cerinta nr 10

-- Pentru a asigura putina integritate in baza de date,
-- compania doreste ca dupa orice modificare a structurii de 
-- angajat / sef, sa se verifice daca toti angajatii raman 
-- in continuare subordonati directi sau indirecti ai sefului.

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER SubordonareIsATree
    AFTER INSERT OR UPDATE OR DELETE ON Angajat
DECLARE
    sef_p           Angajat.AngajatID%TYPE;
    numar_ang_p     BINARY_INTEGER;
    numar_sub_p     BINARY_INTEGER;
BEGIN
    -- Numar real de angajati.
    SELECT COUNT(1)
        INTO numar_ang_p
        FROM Angajat;
    
    -- Gasirea sefului suprem.
    SELECT AngajatID
        INTO sef_p
        FROM Angajat
        WHERE ManagerID IS NULL;
        
    -- Numar de subordonati.
    SELECT COUNT(1)
        INTO numar_sub_p
        FROM Angajat
        START WITH AngajatID = sef_p
        CONNECT BY PRIOR AngajatID = ManagerID;
    
    -- Verif ca sunt egale.
    IF numar_ang_p <> numar_sub_p THEN
        RAISE_APPLICATION_ERROR(-20002, 'Directorul nu este seful tuturor angajatilor!');
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Exista mai multi angajati fara sef!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu exista angajati fara sef!');
END;
/

-- Legal, cresc salariul.
UPDATE Angajat
    SET salariu = salariu + 10;

-- Illegal, invalidez managerii. Nu exista angajat fara sef,
-- ajungem in cazul 'NO_DATA_FOUND'.
UPDATE Angajat
    SET managerID = AngajatID;

-- Illega, exista prea multi angajati fara sef.
-- ajungem in cazul 'TOO_MANY_ROWS'.
UPDATE Angajat
    SET managerID = NULL;
    
-- Illegal, exista un ciclu undeva.
UPDATE Angajat
    SET managerID = 44
    WHERE angajatID = 15;


-- Sterg triggerul.
DROP TRIGGER SubordonareIsATree;


-- Cerinta 11 -- Trigger De Tip LMD La Nivel De Linie
-- Autor: Moroianu Theodor
-- Date: 22.12.2020
-- Cerinta: Cerinta nr 11

-- Pentru a nu avea conflicte interne, directorul doreste
-- ca la modificarea salariului unui angajat, acesta sa nu se modifice
-- cu mai mult de 10%.
-- Implementam un trigger care verifica fiecare modificare a bazei de date.

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER SalaryIsFair
    AFTER UPDATE ON Angajat
FOR EACH ROW
    WHEN (ABS((NEW.salariu - OLD.salariu) / OLD.salariu) > 0.1)
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'Angajatul ' || :NEW.nume || ' a fost modificat cu mai mult de 10%!');
END;
/

-- Legal, cresc salariul angajatilor cu 5%.
UPDATE Angajat
    SET salariu = salariu * 105 / 100;

--Ilegal, cresc prea mult.
UPDATE Angajat
    SET salariu = salariu * 115 / 100;
    
--Ilegal, scad prea mult.
UPDATE Angajat
    SET salariu = salariu * 80 / 100;
    
-- Sterg triggerul.
DROP TRIGGER SalaryIsFair;


-- Cerinta 12 -- Trigger De Tip LDD
-- Autor: Moroianu Theodor
-- Date: 22.12.2020
-- Cerinta: Cerinta nr 11

-- Pentru a facilita gasirea problemelor in baza de date,
-- se doreste crearea unui trigger, care sa salveze informatii
-- despre eventuale modificari ale bazei de date.
-- De asemenea, pentru a evita greseli datorate oboselii,
-- se doreste ca adaugarea / stergerea / modificarea tabelelor
-- sa nu fie posibila inafara programului de lucru (8:00 - 17:00).

SET SERVEROUTPUT ON;

CREATE TABLE Informatii (
    Utilizator      VARCHAR2(100),
    BazaDeDate      VARCHAR2(100),
    Eveniment       VARCHAR2(100),
    NumeTabel       VARCHAR2(100),
    DataModificare  DATE);

CREATE OR REPLACE TRIGGER LoggerModificari
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN 
    -- Verific ca sunt permise modificarile.
    IF TO_CHAR(sysdate, 'D') NOT BETWEEN 2 AND 6 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu se pot face astfel de operatii in Weekend!');
    END IF;
    IF TO_CHAR(sysdate, 'HH24') NOT BETWEEN 8 AND 17 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu se pot face astfel de operatii inafara orarului de lucru!');
    END IF;
    
    INSERT INTO Informatii VALUES (
            SYS.LOGIN_USER,
            SYS.DATABASE_NAME,
            SYS.SYSEVENT,
            SYS.DICTIONARY_OBJ_NAME,
            sysdate);
END;
/

-- Creeam un tabel.
CREATE TABLE Tabel (
    ID  VARCHAR2(10)
);

-- Stergem tabelul.
DROP TABLE Tabel;

-- Vedem modificarile care sunt salvate in "Informatii".
SELECT * FROM Informatii;

-- Stergem tabelul "Informatii" si triggerul.
DROP TRIGGER LoggerModificari;
DROP TABLE Informatii;


-- Cerinta 13 -- Pachet cu Toate Obiectele
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



-- Cerinta 14 -- Implementarea In Oracle A Diagramei Conceptuale
-- Autor: Moroianu Theodor
-- Date: 5.1.2021
-- Cerinta: Cerinta nr 14

-- Pachet care implementeaza o coada.

SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE Coada AS
    TYPE Vector IS TABLE OF NUMBER;
    q    Vector := Vector(); 

    FUNCTION Top
    RETURN NUMBER;
    
    FUNCTION Gol
    RETURN BOOLEAN;
    
    PROCEDURE Push (
        val NUMBER);
        
    PROCEDURE Pop;
END Coada;
/

CREATE OR REPLACE PACKAGE BODY Coada AS
    FUNCTION Top
    RETURN NUMBER
    IS
    BEGIN
        IF q.First IS NOT NULL THEN
            RETURN q(q.First);
        END IF;
        RAISE_APPLICATION_ERROR(-20002, 'Queue is empty!');
    END Top;
    
    PROCEDURE Pop
    IS
    BEGIN
        IF q.First IS NOT NULL THEN
            q.Delete(q.First);
            RETURN;
        END IF;
        RAISE_APPLICATION_ERROR(-20002, 'Queue is empty!');
    END Pop;
    
    FUNCTION Gol
    RETURN BOOLEAN
    IS
    BEGIN
        RETURN q.First IS NULL;
    END Gol;
    
    PROCEDURE Push (
        val NUMBER)
    IS
    BEGIN
        q.Extend;
        q(q.Last) := val;
    END Push;
END Coada;
/

BEGIN
    IF coada.Gol THEN
        DBMS_OUTPUT.PUT_LINE('Coada e goala!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Coada NU e goala!');
    END IF;
    
    Coada.Push(10);
    
    IF coada.Gol THEN
        DBMS_OUTPUT.PUT_LINE('Coada e goala!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Coada NU e goala!');
    END IF;
    
    Coada.Push(20);
    Coada.Push(30);
    Coada.Pop;
    DBMS_OUTPUT.PUT_LINE(Coada.Top);
END;
/
