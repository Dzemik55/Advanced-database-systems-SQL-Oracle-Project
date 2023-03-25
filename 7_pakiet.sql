--Author Tomasz Rycko 19744, PBDiOU

--package declaration
create or replace package testowy is
v_data_koncertu DATE;
v_wykonawca VARCHAR2(255);
function pokaz_liczbe_koncertow (p_nazwa_gatunku varchar2) return integer;
function pokaz_liczbe_koncertow (p_id_gatunku int) return number;
FUNCTION zwroc_najblizsze_koncerty (p_liczba_dni INTEGER) RETURN SYS_REFCURSOR;
FUNCTION czy_wieksza_niz_srednia (p_id_wykonawcy IN INT, p_miesiac IN NUMBER, p_rok IN NUMBER) RETURN BOOLEAN;
FUNCTION zwroc_opoznione_platnosci RETURN SYS_REFCURSOR;
FUNCTION czy_bilet_popularny (p_id_biletu sprzedaz_biletow.bilety_id%TYPE) RETURN BOOLEAN;
procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int,p_cena number);
procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int);
procedure dodaj_wykonawce_z_gatunkiem(p_nazwa_wykonawcy varchar2, p_opis varchar2,p_nazwa_gatunku varchar2);
procedure dodaj_pracownika_klienta(p_kogo_dodac varchar2, p_imie varchar2, p_nazwisko varchar2,
p_email varchar2, p_nr_telefonu char, p_ulica varchar2, p_miasto varchar2, p_numer varchar2, p_kod_pocztowy char);
procedure usun_zamowienie(p_id_zamowienia int);
procedure dodaj_nowe_zamowienie(p_cena zamowienia.cena_zamowienia%type, p_id_pracownika int,p_id_klienta int, p_nr_faktury varchar2,p_id_biletu int,p_ilosc_biletow int);
end testowy;

--package body
create or replace package body testowy is
function pokaz_liczbe_koncertow (p_nazwa_gatunku varchar2) return integer
is
v_liczba_koncertow int;
v_liczba_wszystkich_koncertow int;
begin
select count(id) into v_liczba_koncertow from koncerty k
       WHERE k.wykonawcy_id IN (SELECT gw.wykonawcy_id FROM gatunki_wykonawcy gw
       WHERE gw.gatunki_muzyki_id IN (SELECT gm.id from gatunki_muzyki gm  where gm.nazwa=p_nazwa_gatunku));
select count(id) into v_liczba_wszystkich_koncertow from koncerty;

return v_liczba_koncertow*100/v_liczba_wszystkich_koncertow;
end pokaz_liczbe_koncertow;

function pokaz_liczbe_koncertow (p_id_gatunku int) return number
is
v_liczba_koncertow int;
v_liczba_wszystkich_koncertow int;
begin
select count(id) into v_liczba_koncertow from koncerty k
       WHERE k.wykonawcy_id IN (SELECT gw.wykonawcy_id FROM gatunki_wykonawcy gw
       WHERE gw.gatunki_muzyki_id IN (SELECT gm.id from gatunki_muzyki gm  where gm.id=p_id_gatunku));
select count(id) into v_liczba_wszystkich_koncertow from koncerty;

return round(v_liczba_koncertow*100/v_liczba_wszystkich_koncertow,2);
end pokaz_liczbe_koncertow;

FUNCTION zwroc_najblizsze_koncerty (p_liczba_dni INTEGER)
RETURN SYS_REFCURSOR
AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT k.data_koncertu AS "Data koncertu",
        (SELECT nazwa AS "Wykonawca" From wykonawcy w where w.id=k.wykonawcy_id)
        FROM koncerty k
        WHERE k.data_koncertu BETWEEN SYSDATE AND SYSDATE + p_liczba_dni;
    RETURN v_cursor;
END zwroc_najblizsze_koncerty;

FUNCTION czy_bilet_popularny (
p_id_biletu sprzedaz_biletow.bilety_id%TYPE)
RETURN BOOLEAN IS
v_ilosc NUMBER(8,0);
v_srednia NUMBER(8,2);
BEGIN
SELECT SUM(ilosc) INTO v_ilosc
FROM sprzedaz_biletow WHERE bilety_id=p_id_biletu;
SELECT AVG(ilosc) INTO v_srednia
FROM ( SELECT SUM(ilosc) AS ilosc
FROM sprzedaz_biletow GROUP BY bilety_id);
IF v_ilosc>v_srednia THEN
RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
end czy_bilet_popularny;

FUNCTION czy_wieksza_niz_srednia (p_id_wykonawcy IN INT, p_miesiac IN NUMBER, p_rok IN NUMBER)
RETURN BOOLEAN
AS
    v_liczba_koncertow NUMBER;
    v_srednia NUMBER;
BEGIN
    -- Retrieve the number of concerts of a given artist in a given month
    SELECT COUNT(id) INTO v_liczba_koncertow
    FROM koncerty
    WHERE wykonawcy_id = p_id_wykonawcy AND TO_NUMBER(TO_CHAR(data_koncertu, 'MM')) = p_miesiac AND TO_NUMBER(TO_CHAR(data_koncertu, 'YYYY')) = p_rok;

    -- Retrieve the average number of concerts by other artists in a given month
    SELECT AVG(COUNT(id)) INTO v_srednia
    FROM koncerty
    WHERE wykonawcy_id <> p_id_wykonawcy AND TO_NUMBER(TO_CHAR(data_koncertu, 'MM')) = p_miesiac AND TO_NUMBER(TO_CHAR(data_koncertu, 'YYYY')) = p_rok
    GROUP BY wykonawcy_id;
    IF v_srednia IS NULL THEN
    v_srednia:=0;
    end if;
    -- Returns the result of comparing the number of concerts of a given artist with the average number of concerts of other artists
RETURN v_liczba_koncertow > v_srednia;
END czy_wieksza_niz_srednia;

FUNCTION zwroc_opoznione_platnosci
RETURN SYS_REFCURSOR
AS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT f.id AS "ID faktury", f.nr_faktury AS "Nr faktury",  k.id AS "ID klienta",k.imie || ' ' || k.nazwisko AS "Nazwa klienta",f.data_wystawienia AS "Data wystawienia", f.data_platnosci AS "Data platnosci", f.data_platnosci-f.data_wystawienia AS "Liczba dni spoznienia"
        FROM faktury f
        INNER JOIN zamowienia z ON z.id = f.zamowienia_id
        INNER JOIN klienci k ON k.id = z.klienci_id
        WHERE f.data_platnosci >= f.data_wystawienia+7;
    RETURN v_cursor;
END zwroc_opoznione_platnosci;

procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int,p_cena number)
as
v_koncert_id int;
begin
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id) values (p_organizatorzy_id,p_data_koncertu,p_id_wykonawcy);
SELECT id into v_koncert_id FROM koncerty WHERE id = (SELECT max(id) FROM koncerty) and organizatorzy_id=p_organizatorzy_id and data_koncertu=p_data_koncertu;
INSERT INTO bilety(koncerty_id,cena) VALUES (v_koncert_id,p_cena);
end dodaj_koncert_z_biletami;

procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int)
as
v_koncert_id int;
v_cena_biletu number:=dbms_random.value(100, 2000);
begin
v_cena_biletu:=round(v_cena_biletu,2);
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id) values (p_organizatorzy_id,p_data_koncertu,p_id_wykonawcy);
SELECT id into v_koncert_id FROM koncerty WHERE id = (SELECT max(id) FROM koncerty) and organizatorzy_id=p_organizatorzy_id and data_koncertu=p_data_koncertu;
INSERT INTO bilety(koncerty_id,cena) VALUES (v_koncert_id,v_cena_biletu);
end dodaj_koncert_z_biletami;

procedure dodaj_pracownika_klienta(p_kogo_dodac varchar2, p_imie varchar2, p_nazwisko varchar2,
p_email varchar2, p_nr_telefonu char, p_ulica varchar2, p_miasto varchar2, p_numer varchar2, p_kod_pocztowy char)
as
v_nowy_adres_id int;
v_cnt int;
begin
SELECT COUNT(*) INTO v_cnt FROM adresy
    WHERE (adresy.ulica=p_ulica and adresy.numer=p_numer and adresy.miasto=p_miasto);
    if v_cnt=0 then
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES(p_ulica,p_miasto,p_numer,p_kod_pocztowy);
SELECT id into v_nowy_adres_id FROM adresy WHERE id = (SELECT max(id) FROM adresy);
else
SELECT id into v_nowy_adres_id FROM adresy WHERE ulica=p_ulica and numer=p_numer and miasto=p_miasto;
end if;
if (p_kogo_dodac ='Pracownik' or p_kogo_dodac ='pracownik') then
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) values (p_imie,p_nazwisko,p_email,p_nr_telefonu,v_nowy_adres_id);
elsif (p_kogo_dodac ='Klient' or p_kogo_dodac ='klient') then
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) values (p_imie,p_nazwisko,p_email,p_nr_telefonu,v_nowy_adres_id);
else
raise_application_error(-20111,'Mozna dodać tylko pracownika lub klienta!');
end if;
end dodaj_pracownika_klienta;

procedure usun_zamowienie(p_id_zamowienia int)
as
begin
delete from statusy_zamowien where zamowienia_id=p_id_zamowienia;
delete from sprzedaz_biletow where zamowienia_id=p_id_zamowienia;
delete from faktury where zamowienia_id=p_id_zamowienia;
delete from zamowienia where id=p_id_zamowienia;
end usun_zamowienie;

procedure dodaj_nowe_zamowienie(p_cena zamowienia.cena_zamowienia%type, p_id_pracownika int,p_id_klienta int, p_nr_faktury varchar2,p_id_biletu int,p_ilosc_biletow int)
as
v_id_zamowienia int;
v_nr_faktury varchar2(10);
v_id_biletu sprzedaz_biletow.bilety_id%type;
v_ilosc_biletow sprzedaz_biletow.ilosc%type;
v_cena_zamowienia sprzedaz_biletow.cena%type;
v_data_zamowienia zamowienia.data_zamowienia%type;
begin
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (sysdate,p_cena,p_id_pracownika,p_id_klienta);
SELECT id into v_id_zamowienia FROM zamowienia WHERE id = (SELECT max(id) FROM zamowienia);
SELECT data_zamowienia into v_data_zamowienia FROM zamowienia WHERE id = (SELECT max(id) FROM zamowienia);
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (v_id_zamowienia,p_id_pracownika,p_id_klienta,
p_nr_faktury,v_data_zamowienia,v_data_zamowienia);
SELECT cena_zamowienia into v_cena_zamowienia FROM zamowienia WHERE id = (SELECT max(id) FROM zamowienia);
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,cena,ilosc) VALUES(v_id_zamowienia,p_id_biletu,v_cena_zamowienia,p_ilosc_biletow);
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,v_id_zamowienia,v_data_zamowienia);
end dodaj_nowe_zamowienie;

procedure dodaj_wykonawce_z_gatunkiem(p_nazwa_wykonawcy varchar2, p_opis varchar2,p_nazwa_gatunku varchar2)
as
cnt int;
v_id_wykonawcy int;
v_id_gatunku int;
begin
select count(*) into cnt from wykonawcy where nazwa=p_nazwa_wykonawcy;
if (cnt=0) then
insert into wykonawcy(nazwa,opis) values (p_nazwa_wykonawcy,p_opis);
SELECT id into v_id_wykonawcy FROM wykonawcy WHERE id = (SELECT max(id) FROM wykonawcy) and nazwa=p_nazwa_wykonawcy;
else
select id into v_id_wykonawcy from wykonawcy where nazwa=p_nazwa_wykonawcy;
dbms_output.put_line('Podany wykonawca juz jest w bazie, nie dodano nowego wykonawcy');
end if;
select count(*) into cnt from gatunki_muzyki where nazwa=p_nazwa_gatunku;
if (cnt=0) then
insert into gatunki_muzyki(nazwa) values(p_nazwa_gatunku);
SELECT id into v_id_gatunku FROM gatunki_muzyki WHERE id = (SELECT max(id) FROM gatunki_muzyki) and nazwa=p_nazwa_gatunku;
else
select id into v_id_gatunku from gatunki_muzyki where nazwa=p_nazwa_gatunku;
dbms_output.put_line('Podany gatunek juz jest w bazie, nie dodano nowego gatunku');
end if;
select count(*) into cnt from gatunki_wykonawcy where wykonawcy_id=v_id_wykonawcy and gatunki_muzyki_id=v_id_gatunku;
if (cnt=0) then
insert into gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) values (v_id_wykonawcy,v_id_gatunku);
else
dbms_output.put_line('Nie przypisano gatunku do wykonawcy, taki sam rekord istnieje juz w bazie');
end if;
end dodaj_wykonawce_z_gatunkiem;
end testowy;