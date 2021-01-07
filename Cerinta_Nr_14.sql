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
