--Autor Tomasz Rycko 19744, PBDiOU

INSERT INTO organizatorzy(nazwa,opis) VALUES('LiveNation','Najwiekszy organizator koncertow w Polsce');
INSERT INTO organizatorzy(nazwa,opis) VALUES('WiniaryKoncerty','Najsmaczniejsze wydarzenia w regionie');
INSERT INTO organizatorzy(nazwa,opis) VALUES('BestEvents','Zagraniczni artysci w Polsce!');
INSERT INTO organizatorzy(nazwa,opis) VALUES('TanieKoncerty','Koncerty na kieszen kazdego');
INSERT INTO organizatorzy(nazwa,opis) VALUES('SzylenyLive','Niemozliwe nie istnieje');
INSERT INTO organizatorzy(nazwa,opis) VALUES('Kpop Polska','Kpopowe gwiazdy w Polsce');
INSERT INTO organizatorzy(nazwa,opis) VALUES('Club Shows','Najlepsze koncerty klubowe w Polsce i za granica');

INSERT INTO statusy(nazwa, opis) VALUES('zlozenie zamowienia','zamowienia zostalo zlozone');
INSERT INTO statusy(nazwa, opis) VALUES('oczekiwanie na zaplate','oczekiwanie na zaplate kliencia');
INSERT INTO statusy(nazwa, opis) VALUES('przetwarzanie zaplaty','zaplata jest przetwarzana');
INSERT INTO statusy(nazwa, opis) VALUES('otrzymano zaplate','zaplata zostala przyjeta');
INSERT INTO statusy(nazwa, opis) VALUES('przetwarzanie zamowienia','zamowienia jest przetwarzane');
INSERT INTO statusy(nazwa, opis) VALUES('zamowienia sfinalizowane','zamowienia zostalo sfinalizowane');
INSERT INTO statusy(nazwa, opis) VALUES('anulowano zamowienia','zamowienia zostalo anulowane przez kliencia');

INSERT INTO wykonawcy(nazwa,opis) VALUES('Skillet','Zespol z USA grajacy rock chrzescijanski');
INSERT INTO wykonawcy(nazwa,opis) VALUES('Architects','Zespol z Wielkiej Brytanii grajacy metalcore oraz metal industrialny');
INSERT INTO wykonawcy(nazwa,opis) VALUES('BLACKPINK','Girlsband z Korei Poludniowej wykonujacy muzyke kpop');
INSERT INTO wykonawcy(nazwa,opis) VALUES('Spiritbox','Zespol z Kanady grajacy metalcore oraz heavy metal');
INSERT INTO wykonawcy(nazwa,opis) VALUES('Polaris','Zespol z Australi grajacy metalcore');
INSERT INTO wykonawcy(nazwa,opis) VALUES('Dua Lipa','Wokalistka z Wielkiej Brytanii wykonujaca muzyke pop');
INSERT INTO wykonawcy(nazwa,opis) VALUES('Eminem','Raper z USA');

INSERT INTO gatunki_muzyki(nazwa) VALUES('Metal');
INSERT INTO gatunki_muzyki(nazwa) VALUES('Rock');
INSERT INTO gatunki_muzyki(nazwa) VALUES('Reggae');
INSERT INTO gatunki_muzyki(nazwa) VALUES('Rap');
INSERT INTO gatunki_muzyki(nazwa) VALUES('Jazz');
INSERT INTO gatunki_muzyki(nazwa) VALUES('Pop');

INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Wspolna','Elblag','2','98-100');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Koncertowa','Warszawa','31','14-500');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Papieska','Wadowice','2137','21-370');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Braniewska','Braniewo','11','65-111');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Sezamowa','Katowice','2','11-112');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Slodka','Poznan','12','65-788');
INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Dlugopisowa','Torul','32','32-320');

INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Tomasz','Rycko','tomasz.rycko@gmail.com','865552746',1);
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Lukasz','Drukarka','lukasz.drukarka@gmail.com','651591319',2); 
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Julia','Puszka','julia.puszka@gmail.com','564447683',3); 
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Cezary','Baryka','szklane.domy@gmail.com','420168797',4); 
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Robert','Lewandowski','zlota.pilka@gmail.com','885404584',5); 
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Jakub ','Blaszczykowski','powtorzony.karny@gmail.com','196260615',6); 
INSERT INTO pracownicy(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Jozef','Telefon','jozef.telefon@gmail.com','418115814',7);

INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Klaudia','Bilecik','klaudia.bilecik@gmail.com','524538395',1);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Robert','Biedron','robert.biedron@gmail.com','866022587',2);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Cezary','Mikrofon','czarek.123@gmail.com','310638050',3);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Joanna','Meksyk','joanna.meksyk@gmail.com','180559599',4);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Sam','Carter','jeste.architecte@gmail.com','497439612',5);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Lukasz','Audi','lukasz.audi@gmail.com','192157073',6);
INSERT INTO klienci(imie,nazwisko,email,nr_telefonu,adresy_id) VALUES('Waldemar','Strzelec','waldemar.strzelec@gmail.com','024722466',7);

INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(1,1,to_date('2022-06-03','RRRR-MM-DD'),3000);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(2,2,to_date('2022-08-13','RRRR-MM-DD'),5000);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(3,3,to_date('2022-05-21','RRRR-MM-DD'),7500);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(4,4,to_date('2022-07-18','RRRR-MM-DD'),4000);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(5,5,to_date('2022-09-18','RRRR-MM-DD'),1000);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(6,6,to_date('2022-08-03','RRRR-MM-DD'),4500);
INSERT INTO koncerty(organizatorzy_id,wykonawcy_id,data_koncertu,ilosc_biletow) VALUES(7,7,to_date('2022-10-15','RRRR-MM-DD'),4500);

INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (1,2);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (1,1);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (2,1);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (3,6);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (4,1);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (5,1);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (6,6);
INSERT INTO gatunki_wykonawcy(wykonawcy_id,gatunki_muzyki_id) VALUES (7,4);

INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2021-03-12','RRRR-MM-DD'), '600',1,1);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2020-12-12','RRRR-MM-DD'), '800',1,2);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2021-05-15','RRRR-MM-DD'), '1000',2,3);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2021-04-11','RRRR-MM-DD'), '1200',3,4);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2020-07-01','RRRR-MM-DD'), '1200',4,5);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2021-03-18','RRRR-MM-DD'), '1400',5,6);
INSERT INTO zamowienia(data_zamowienia,cena_zamowienia,pracownicy_id,klienci_id) VALUES (to_date('2021-06-30','RRRR-MM-DD'), '1600',6,7);

INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,1,to_date('2021-03-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(2,1,to_date('2021-03-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(3,1,to_date('2021-03-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(4,1,to_date('2021-03-13','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(5,1,to_date('2021-03-14','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(6,1,to_date('2021-03-15','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,2,to_date('2020-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(2,2,to_date('2021-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(3,2,to_date('2021-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(4,2,to_date('2021-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(5,2,to_date('2021-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(6,2,to_date('2021-12-12','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,3,to_date('2021-05-15','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(2,3,to_date('2021-12-15','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(3,3,to_date('2021-12-15','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(4,3,to_date('2021-12-16','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(5,3,to_date('2021-12-17','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(6,3,to_date('2021-12-19','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,4,to_date('2021-04-11','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(2,4,to_date('2021-04-11','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(1,5,to_date('2020-07-01','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(2,5,to_date('2020-07-01','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu) VALUES(3,5,to_date('2020-07-01','RRRR-MM-DD'));
INSERT INTO statusy_zamowien(statusy_id,zamowienia_id,data_zmiany_statusu,opis) VALUES(7,5,to_date('2020-07-03','RRRR-MM-DD'),'Klient zdecydowal sie anulowac zamowienia');

INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (1,1,2,'123/1',to_date('2021-03-12','RRRR-MM-DD'),to_date('2021-03-12','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (2,1,3,'123/2',to_date('2020-12-12','RRRR-MM-DD'),to_date('2020-12-12','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (3,2,1,'123/3',to_date('2021-05-15','RRRR-MM-DD'),to_date('2021-05-30','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (4,3,4,'123/4',to_date('2021-04-11','RRRR-MM-DD'),to_date('2021-04-12','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (5,4,6,'123/5',to_date('2020-07-01','RRRR-MM-DD'),to_date('2020-07-01','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (6,5,7,'123/6',to_date('2021-03-18','RRRR-MM-DD'),to_date('2021-03-19','RRRR-MM-DD'));
INSERT INTO faktury(zamowienia_id,pracownicy_id,klienci_id,nr_faktury,data_wystawienia,data_platnosci) VALUES (7,7,5,'123/7',to_date('2021-06-30','RRRR-MM-DD'),to_date('2021-06-30','RRRR-MM-DD'));

INSERT INTO bilety(koncerty_id,cena) VALUES (1,100);
INSERT INTO bilety(koncerty_id,cena) VALUES (2,200);
INSERT INTO bilety(koncerty_id,cena) VALUES (3,250);
INSERT INTO bilety(koncerty_id,cena) VALUES (4,500);
INSERT INTO bilety(koncerty_id,cena) VALUES (5,600);
INSERT INTO bilety(koncerty_id,cena) VALUES (6,700);
INSERT INTO bilety(koncerty_id,cena) VALUES (7,600);

INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(1,2,3,'paypal');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(2,3,4,'karta debetowa');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(3,5,4,'przelew');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(4,7,4,'przelew');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(5,4,2,'paypal');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(6,1,2,'paypal');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(7,6,8,'karta debetowa');