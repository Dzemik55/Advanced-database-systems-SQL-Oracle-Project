--Author Tomasz Rycko 19744, PBDiOU

-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2022-10-08 14:58:03 CEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

set serveroutput on;
ALTER SESSION SET NLS_DATE_FORMAT = 'yyyy-mm-dd';
--  addresses table
CREATE TABLE adresy ( 
    id           INTEGER
        CONSTRAINT nnc_adresy_id NOT NULL,
    ulica        VARCHAR2(20),
    miasto       VARCHAR2(20)
        CONSTRAINT nnc_adresy_miasto NOT NULL,
    numer        VARCHAR2(5)
        CONSTRAINT nnc_adresy_numer NOT NULL,
    kod_pocztowy CHAR(6)
        CONSTRAINT nnc_adresy_kod_pocztowy NOT NULL
);

COMMENT ON TABLE adresy IS
    'addresses table';

ALTER TABLE adresy ADD CONSTRAINT adresy_pk PRIMARY KEY ( id );

--  tickets table
CREATE TABLE bilety ( 
--  id
    id          INTEGER NOT NULL,
    cena        NUMBER NOT NULL,
    koncerty_id INTEGER NOT NULL
);

COMMENT ON TABLE bilety IS
    'tickets table';


ALTER TABLE bilety ADD CONSTRAINT bilety_pk PRIMARY KEY ( id );

--  invoices table
CREATE TABLE faktury (
    id               INTEGER NOT NULL,
    nr_faktury       VARCHAR2(10) NOT NULL,
    data_wystawienia DATE NOT NULL,
    data_platnosci   DATE,
    czy_zaplacono    VARCHAR2(3) DEFAULT 'nie' NOT NULL,
    pracownicy_id    INTEGER NOT NULL,
    klienci_id       INTEGER NOT NULL,
    zamowienia_id    INTEGER NOT NULL
);

COMMENT ON TABLE faktury IS
    'invoices table';


ALTER TABLE faktury ADD CONSTRAINT faktury_pk PRIMARY KEY ( id );

--  musical genres table
CREATE TABLE gatunki_muzyki (
    id    INTEGER NOT NULL,
    nazwa VARCHAR2(20) NOT NULL
);

COMMENT ON TABLE gatunki_muzyki IS
    'musical genres table';

ALTER TABLE gatunki_muzyki ADD CONSTRAINT gatunki_muzyki_pk PRIMARY KEY ( id );

--  genres of a specific artist table
CREATE TABLE gatunki_wykonawcy (
    wykonawcy_id      INTEGER NOT NULL,
    gatunki_muzyki_id INTEGER NOT NULL
);

COMMENT ON TABLE gatunki_wykonawcy IS
    'genres of a specific artist table';

--  customer data table
CREATE TABLE klienci (
    id          INTEGER NOT NULL,
    imie        VARCHAR2(20) NOT NULL,
    nazwisko    VARCHAR2(20) NOT NULL,
    email       VARCHAR2(40) NOT NULL,
    czy_usunieto varchar(3) default 'nie',
    nr_telefonu CHAR(9) NOT NULL CHECK (LENGTH(nr_telefonu) = 9),
    adresy_id   INTEGER NOT NULL
);

COMMENT ON TABLE klienci IS
    'customer data table';

ALTER TABLE klienci ADD CONSTRAINT klienci_pk PRIMARY KEY ( id );

ALTER TABLE klienci ADD CONSTRAINT klienci_email__un UNIQUE ( email);
ALTER TABLE klienci ADD CONSTRAINT klienci_telefon__un UNIQUE (nr_telefonu);

--  concerts table
CREATE TABLE koncerty (
    id               INTEGER NOT NULL,
    data_koncertu    DATE NOT NULL,
    organizatorzy_id INTEGER NOT NULL,
    wykonawcy_id     INTEGER NOT NULL,
    ilosc_biletow INTEGER NOT NULL
);

COMMENT ON TABLE koncerty IS
    'concerts table ';

ALTER TABLE koncerty ADD CONSTRAINT koncerty_pk PRIMARY KEY ( id );

--  event organizers table
CREATE TABLE organizatorzy (
    id    INTEGER NOT NULL,
    nazwa VARCHAR2(20) NOT NULL,
    opis  CLOB
);

COMMENT ON TABLE organizatorzy IS
    'event organizers table';

ALTER TABLE organizatorzy ADD CONSTRAINT organizatorzy_pk PRIMARY KEY ( id );

--  employees data table
CREATE TABLE pracownicy (
    id          INTEGER NOT NULL,
    imie        VARCHAR2(20) NOT NULL,
    nazwisko    VARCHAR2(20) NOT NULL,
    email       VARCHAR2(40) NOT NULL,
    nr_telefonu CHAR(9) NOT NULL CHECK (LENGTH(nr_telefonu) = 9),
    adresy_id   INTEGER NOT NULL
);

COMMENT ON TABLE pracownicy IS
    'employees data table';

ALTER TABLE pracownicy ADD CONSTRAINT pracownicy_pk PRIMARY KEY ( id );

ALTER TABLE pracownicy ADD CONSTRAINT pracownicy_email__un UNIQUE ( email);
ALTER TABLE pracownicy ADD CONSTRAINT pracownicy_telefon__un UNIQUE (nr_telefonu);
                                                            

--  ticket sales table
CREATE TABLE sprzedaz_biletow (
    id            INTEGER NOT NULL,
    cena          NUMBER,
    ilosc         SMALLINT NOT NULL,
    bilety_id     INTEGER NOT NULL,
    zamowienia_id INTEGER NOT NULL,
    sposob_platnosci varchar2(14) not null,
    oplata_transakcyjna number
);

COMMENT ON TABLE sprzedaz_biletow IS
    'ticket sales table';

ALTER TABLE sprzedaz_biletow ADD CONSTRAINT sprzedaz_biletow_pk PRIMARY KEY ( id );

--  order statuses table
CREATE TABLE statusy (
    id    INTEGER NOT NULL,
    nazwa VARCHAR2(30) NOT NULL,
    opis  VARCHAR2(50) NOT NULL
);

COMMENT ON TABLE statusy IS
    'order statuses table';

ALTER TABLE statusy ADD CONSTRAINT statusy_pk PRIMARY KEY ( id );

--  specific order statuses table
CREATE TABLE statusy_zamowien (
    id                  INTEGER NOT NULL,
    data_zmiany_statusu DATE NOT NULL,
    opis                VARCHAR2(100),
    statusy_id          INTEGER NOT NULL,
    zamowienia_id       INTEGER NOT NULL
);

COMMENT ON TABLE statusy_zamowien IS
    'specific order statuses table';

ALTER TABLE statusy_zamowien ADD CONSTRAINT statusy_zamowien_pk PRIMARY KEY ( id );

--  artists table
CREATE TABLE wykonawcy (
    id    INTEGER NOT NULL,
    nazwa VARCHAR2(60) NOT NULL,
    opis  CLOB
);

COMMENT ON TABLE wykonawcy IS
    'artists table';

ALTER TABLE wykonawcy ADD CONSTRAINT wykonawcy_pk PRIMARY KEY ( id );

--  orders table
CREATE TABLE zamowienia (
    id              INTEGER NOT NULL,
    data_zamowienia DATE NOT NULL,
    cena_zamowienia NUMBER NOT NULL,
    pracownicy_id   INTEGER NOT NULL,
    klienci_id      INTEGER NOT NULL
);

COMMENT ON TABLE zamowienia IS
    'orders table';

CREATE INDEX zamowienia__idx ON
    zamowienia (
        cena_zamowienia
    DESC );

ALTER TABLE zamowienia ADD CONSTRAINT zamowienie_pk PRIMARY KEY ( id );

ALTER TABLE bilety
    ADD CONSTRAINT bilety_koncerty_fk FOREIGN KEY ( koncerty_id )
        REFERENCES koncerty ( id );

ALTER TABLE faktury
    ADD CONSTRAINT faktury_klienci_fk FOREIGN KEY ( klienci_id )
        REFERENCES klienci ( id );

ALTER TABLE faktury
    ADD CONSTRAINT faktury_pracownicy_fk FOREIGN KEY ( pracownicy_id )
        REFERENCES pracownicy ( id );

ALTER TABLE faktury
    ADD CONSTRAINT faktury_zamowienia_fk FOREIGN KEY ( zamowienia_id )
        REFERENCES zamowienia ( id );

ALTER TABLE gatunki_wykonawcy
    ADD CONSTRAINT gatunki_wykonawcy_fk FOREIGN KEY ( gatunki_muzyki_id )
        REFERENCES gatunki_muzyki ( id );

ALTER TABLE gatunki_wykonawcy
    ADD CONSTRAINT gatunki_wykonawcy_wykonawcy_fk FOREIGN KEY ( wykonawcy_id )
        REFERENCES wykonawcy ( id );

ALTER TABLE klienci
    ADD CONSTRAINT klienci_adresy_fk FOREIGN KEY ( adresy_id )
        REFERENCES adresy ( id );

ALTER TABLE koncerty
    ADD CONSTRAINT koncerty_organizatorzy_fk FOREIGN KEY ( organizatorzy_id )
        REFERENCES organizatorzy ( id );

ALTER TABLE koncerty
    ADD CONSTRAINT koncerty_wykonawcy_fk FOREIGN KEY ( wykonawcy_id )
        REFERENCES wykonawcy ( id );

ALTER TABLE pracownicy
    ADD CONSTRAINT pracownicy_adresy_fk FOREIGN KEY ( adresy_id )
        REFERENCES adresy ( id );

ALTER TABLE sprzedaz_biletow
    ADD CONSTRAINT sprzedaz_biletow_bilety_fk FOREIGN KEY ( bilety_id )
        REFERENCES bilety ( id );

ALTER TABLE sprzedaz_biletow
    ADD CONSTRAINT sprzedaz_biletow_zamowienia_fk FOREIGN KEY ( zamowienia_id )
        REFERENCES zamowienia ( id );

ALTER TABLE statusy_zamowien
    ADD CONSTRAINT statusy_zamowien_statusy_fk FOREIGN KEY ( statusy_id )
        REFERENCES statusy ( id );

ALTER TABLE statusy_zamowien
    ADD CONSTRAINT statusy_zamowien_zamowienia_fk FOREIGN KEY ( zamowienia_id )
        REFERENCES zamowienia ( id );

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_klienci_fk FOREIGN KEY ( klienci_id )
        REFERENCES klienci ( id );

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_pracownicy_fk FOREIGN KEY ( pracownicy_id )
        REFERENCES pracownicy ( id );

CREATE SEQUENCE adresy_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER adresy_id_trg BEFORE
    INSERT ON adresy
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := adresy_id_seq.nextval;
END;
/

CREATE SEQUENCE bilety_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER bilety_id_trg BEFORE
    INSERT ON bilety
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := bilety_id_seq.nextval;
END;
/

CREATE SEQUENCE faktury_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER faktury_id_trg BEFORE
    INSERT ON faktury
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := faktury_id_seq.nextval;
END;
/

CREATE SEQUENCE gatunki_muzyki_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER gatunki_muzyki_id_trg BEFORE
    INSERT ON gatunki_muzyki
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := gatunki_muzyki_id_seq.nextval;
END;
/

CREATE SEQUENCE klienci_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER klienci_id_trg BEFORE
    INSERT ON klienci
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := klienci_id_seq.nextval;
END;
/

CREATE SEQUENCE koncerty_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER koncerty_id_trg BEFORE
    INSERT ON koncerty
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := koncerty_id_seq.nextval;
END;
/

CREATE SEQUENCE organizatorzy_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER organizatorzy_id_trg BEFORE
    INSERT ON organizatorzy
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := organizatorzy_id_seq.nextval;
END;
/

CREATE SEQUENCE pracownicy_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER pracownicy_id_trg BEFORE
    INSERT ON pracownicy
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := pracownicy_id_seq.nextval;
END;
/

CREATE SEQUENCE sprzedaz_biletow_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER sprzedaz_biletow_id_trg BEFORE
    INSERT ON sprzedaz_biletow
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := sprzedaz_biletow_id_seq.nextval;
END;
/

CREATE SEQUENCE statusy_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER statusy_id_trg BEFORE
    INSERT ON statusy
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := statusy_id_seq.nextval;
END;
/

CREATE SEQUENCE statusy_zamowien_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER statusy_zamowien_id_trg BEFORE
    INSERT ON statusy_zamowien
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := statusy_zamowien_id_seq.nextval;
END;
/

CREATE SEQUENCE wykonawcy_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER wykonawcy_id_trg BEFORE
    INSERT ON wykonawcy
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := wykonawcy_id_seq.nextval;
END;
/

CREATE SEQUENCE zamowienia_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER zamowienia_id_trg BEFORE
    INSERT ON zamowienia
    FOR EACH ROW
    WHEN ( new.id IS NULL )
BEGIN
    :new.id := zamowienia_id_seq.nextval;
END;
/

--account table used in APEX application authorization
CREATE TABLE konto
  (
    id      INTEGER NOT NULL ,
    login   VARCHAR2 (50) NOT NULL ,
    haslo   VARCHAR2 (100) NOT NULL ,
    rola_id INTEGER NOT NULL
  ) ;
ALTER TABLE konto ADD CONSTRAINT uzytkownik_PK PRIMARY KEY ( id ) ;
ALTER TABLE konto ADD CONSTRAINT uzytkownik__UN UNIQUE ( login ) ;

--role table used in APEX application authorization
CREATE TABLE rola
  ( id INTEGER NOT NULL , nazwa VARCHAR2 (50) NOT NULL
  ) ;
ALTER TABLE rola ADD CONSTRAINT rola_PK PRIMARY KEY ( id ) ;
ALTER TABLE rola ADD CONSTRAINT rola__UN UNIQUE ( nazwa ) ;

