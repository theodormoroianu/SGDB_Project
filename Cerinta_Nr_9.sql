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
