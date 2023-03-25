--Author Tomasz Rycko 19744, PBDiOU

--procedure 1 adds a record to the concert table and adds a ticket for this concert to the tickets table at the same time
CREATE or replace procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int,p_cena number, p_ilosc int)
as
v_koncert_id int;
begin
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id, ilosc_biletow)
 values (p_organizatorzy_id,p_data_koncertu,p_id_wykonawcy, p_ilosc);
SELECT id into v_koncert_id FROM koncerty WHERE id = (SELECT max(id) FROM koncerty) and organizatorzy_id=p_organizatorzy_id and data_koncertu=p_data_koncertu;
INSERT INTO bilety(koncerty_id,cena) VALUES (v_koncert_id,p_cena);
end;

exec dodaj_koncert_z_biletami(1,sysdate,7,1000,2500);

--procedure 2 adding records to the artist table and to the genre_of_music and genres_of_artists table, provided that such entries do not already exist
CREATE or replace procedure dodaj_wykonawce_z_gatunkiem(p_nazwa_wykonawcy varchar2, p_opis varchar2,p_nazwa_gatunku varchar)
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
end;

exec dodaj_wykonawce_z_gatunkiem('Swiateczne Dagi','Zespol spiewajacy koledy w nowoczesnym wydaniu','kolędowanie');

--procedure 3. Adds an employee or client (depending on whom we want to add to the database) with a new address. If the given address already exists in the database, instead of adding this address, it adds the client/employee and assigns him this existing address. If we specify anything other than an employee or a client as the parameter p_who_to add, an error will be returned.
create or replace procedure dodaj_pracownika_klienta(p_kogo_dodac varchar2, p_imie varchar2, p_nazwisko varchar2,
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
end;

exec dodaj_pracownika_klienta('klient','Łukasz','Graba','grzecgorz.teleffofddn@cgmail.com','179900000','Wspolna','Skarszfewy',21,'98-100');

--procedure 4. Procedure for deleting an order. Deletes a record from the "orders" table, but also deletes the corresponding records from the "invoices", "ticketsales" and "orders_status" tables.
create or replace procedure usun_zamowienie(p_id_zamowienia int)
as
begin
delete from statusy_zamowien where zamowienia_id=p_id_zamowienia;
delete from sprzedaz_biletow where zamowienia_id=p_id_zamowienia;
delete from faktury where zamowienia_id=p_id_zamowienia;
delete from zamowienia where id=p_id_zamowienia;
end;

exec usun_zamowienie(1);
--procedure 5. The procedure adds a record to the orders table, and then to the invoices, ticket_sales and order statuses table. As parameters it takes (order price, employee ID, customer ID, invoice number, ticket ID and number of tickets)
create or replace procedure dodaj_nowe_zamowienie(p_cena zamowienia.cena_zamowienia%type, p_id_pracownika int,p_id_klienta int, p_nr_faktury varchar2,p_id_biletu int,p_ilosc_biletow int,p_sposob_platnosci varchar2)
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
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,cena,ilosc,sposob_platnosci) VALUES(v_id_zamowienia,p_id_biletu,v_cena_zamowienia,p_ilosc_biletow,p_sposob_platnosci);
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,v_id_zamowienia,v_data_zamowienia);
end;

exec dodaj_nowe_zamowienie(300,3,1,'43/343',3,10,'paypal');
-- overloaded procedure
CREATE or replace procedure dodaj_koncert_z_biletami(p_organizatorzy_id INT, p_data_koncertu date, p_id_wykonawcy int)
as
v_koncert_id int;
v_cena_biletu number:=dbms_random.value(100, 2000);
begin
v_cena_biletu:=round(v_cena_biletu,2);
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id) values (p_organizatorzy_id,p_data_koncertu,p_id_wykonawcy);
SELECT id into v_koncert_id FROM koncerty WHERE id = (SELECT max(id) FROM koncerty) and organizatorzy_id=p_organizatorzy_id and data_koncertu=p_data_koncertu;
INSERT INTO bilety(koncerty_id,cena) VALUES (v_koncert_id,v_cena_biletu);
end;