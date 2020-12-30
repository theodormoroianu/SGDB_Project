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

SELECT TO_CHAR(sysdate, 'HH24') FROM dual;

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

