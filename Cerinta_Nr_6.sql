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
    
    
    pretMinimProduse    Tablou;
BEGIN
    pretMinimProduse := UltimaAchizitieClient(1);
END;
/

EXECUTE PrintPromotion;

