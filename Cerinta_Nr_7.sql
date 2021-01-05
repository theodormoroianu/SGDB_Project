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
-- Care este cea mai buna alegere de premiere a angajatilor?

-- Subprogramul definit jos de tot, prin apeluri la functiile definite
-- tot aici, foloseste cursoare implicite.

SET SERVEROUTPUT ON;

-- Tabel in care salvez costul de-a alege
-- fiecare angajat ca "sursa" a bonusului,
-- impreuna cu numarul de angajati afectati.
DROP TABLE CostBonus;
CREATE TABLE CostBonus (
    angajatId       NUMBER PRIMARY KEY,
    numarAngajati   NUMBER,
    sumaSalarii     NUMBER);


-- Functie recursiva care populeaza tabelul CostBonus.
DROP PROCEDURE ComputeCostBonus;
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
DROP PROCEDURE CresteSalariuSubordonati;
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
DROP FUNCTION PremiazaAngajati;
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


-- Anularea side-effecturilor.
DROP TABLE CostBonus;
DROP PROCEDURE ComputeCostBonus;
DROP PROCEDURE CresteSalariuSubordonati;
DROP FUNCTION PremiazaAngajati;

ROLLBACK;

