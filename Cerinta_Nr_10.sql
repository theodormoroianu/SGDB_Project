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
