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
