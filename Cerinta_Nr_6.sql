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

