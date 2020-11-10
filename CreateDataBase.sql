DROP TABLE locatie CASCADE CONSTRAINTS;
DROP TABLE furnizor CASCADE CONSTRAINTS;
DROP TABLE angajat CASCADE CONSTRAINTS;
DROP TABLE magazin CASCADE CONSTRAINTS;
DROP TABLE produs CASCADE CONSTRAINTS;
DROP TABLE continutfurnizare CASCADE CONSTRAINTS;
DROP TABLE furnizare CASCADE CONSTRAINTS;
DROP TABLE disponibilitatefurnizor CASCADE CONSTRAINTS;
DROP TABLE review CASCADE CONSTRAINTS;
DROP TABLE continutvanzare CASCADE CONSTRAINTS;
DROP TABLE vanzare CASCADE CONSTRAINTS;
DROP TABLE disponibilitatemagazin CASCADE CONSTRAINTS;
DROP TABLE cumparator CASCADE CONSTRAINTS;


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
    
    