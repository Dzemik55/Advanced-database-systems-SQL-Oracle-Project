--Author Tomasz Rycko 19744, PBDiOU

--trigger 1. A trigger that sets the correct price in the table sale_tickets based on the price in the table tickets and sets the value of the transaction_fee column depending on the type of payment (wire transfer/debit card/paypal).
CREATE OR REPLACE TRIGGER ustaw_cene_oraz_oplate_tr
BEFORE INSERT OR UPDATE ON sprzedaz_biletow
FOR EACH ROW
DECLARE
  v_bilet_cena NUMBER;
  v_oplata_transakcyjna NUMBER;
BEGIN
  -- get the ticket price from the tickets table
  SELECT cena INTO v_bilet_cena
  FROM bilety
  WHERE id = :new.bilety_id;

  -- set price in table sale_tickets
  :new.cena := v_bilet_cena*:new.ilosc;

  -- set the transaction fee depending on the type of payment
  IF :new.sposob_platnosci = 'przelew' or :new.sposob_platnosci = 'Przelew' THEN
    v_oplata_transakcyjna := 0;
  ELSIF :new.sposob_platnosci = 'karta debetowa' or :new.sposob_platnosci = 'Karta debetowa' THEN
    v_oplata_transakcyjna := v_bilet_cena * 0.01;
  ELSIF :new.sposob_platnosci = 'PayPal' or :new.sposob_platnosci = 'Paypal' or :new.sposob_platnosci = 'paypal' THEN
    v_oplata_transakcyjna := v_bilet_cena * 0.02;
  END IF;

  :new.oplata_transakcyjna := v_oplata_transakcyjna;
  
  update zamowienia set cena_zamowienia=:new.cena+v_oplata_transakcyjna where id=:new.zamowienia_id;
END;

INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,cena,ilosc,sposob_platnosci) VALUES(7,6,3200,8,'PayPal');
INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(7,6,8,'karta debetowa');



--trigger 2 not allowing to add a concert with a date that already exists in the table and not allowing to add more concert of a given artist if he already has a concert on the given date (i.e. 1 artist can give 1 concert per day)
create or replace trigger koncerty_ta_sama_data before insert on koncerty for each row
declare
cnt int;
cnt2 int;
begin
select count(*) into cnt from koncerty where trunc(data_koncertu)=trunc(:new.data_koncertu);
select count(*) into cnt2 from koncerty where trunc(data_koncertu)=trunc(:new.data_koncertu) and wykonawcy_id=:new.wykonawcy_id;
if (cnt>0 and cnt2=0) then
RAISE_APPLICATION_ERROR(-20500,'Nie mozna dodawac koncertu z data w ktorej juz jest inny koncert!');
elsif(cnt>0 and cnt2>0) then
RAISE_APPLICATION_ERROR(-20500,'Wykonawca nie moze miec wiecej niz 1 koncertu tego samego dnia!');
end if;
end;
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id,ilosc_biletow) values (1,sysdate+500,1,5100);
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id,ilosc_biletow) values (1,sysdate+500,1,5100);
insert into koncerty(organizatorzy_id,data_koncertu,wykonawcy_id,ilosc_biletow) values (1,sysdate+500,2,5100);

--trigger 3 checking the correctness of the postal code entered into the addresses table
CREATE OR REPLACE TRIGGER poprawnosc_kodu_pocztowego
BEFORE INSERT OR UPDATE ON adresy
FOR EACH ROW
BEGIN
  -- check that the zip code consists of 2 digits, then a dash, then 3 digits
  IF NOT REGEXP_LIKE(:new.kod_pocztowy, '^[0-9]{2}-?[0-9]{3}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Nieprawidłowy kod pocztowy');
  END IF;
END;

INSERT INTO adresy(ulica,miasto,numer,kod_pocztowy) VALUES('Bolkoslowska','Skarszewy','2','83-16');


--trigger 4 which, instead of deleting a record from the customers table, sets the is_deleted column to 'yes'. For this you will need a view clients_view, and for this view a trigger that instead of deleting something
-- from the view will modify the customers tables

--creating view for 'select * from customers'

create view klienci_widok as
select* from klienci;

create or replace trigger klienci_usuwanie
instead of delete on klienci_widok for each row
declare
v_usuwany_rekord klienci.czy_usunieto%type;
begin
select czy_usunieto into v_usuwany_rekord from klienci where id=:old.id;
if (v_usuwany_rekord!='tak') then
update klienci set czy_usunieto='tak' where id=:old.id;
else
raise_application_error(-20002,'Nie można usunąć tego klienta, ponieważ został on już usunięty.');
end if;
end;

delete from klienci_widok where id=2;

--trigger 5 on the table sale tickets updating the number of tickets for a given concert in the table concert when deleting and inserting records from the table sale_tickets
CREATE OR REPLACE TRIGGER zmniejsz_ilosc_biletow
BEFORE INSERT OR DELETE ON sprzedaz_biletow
FOR EACH ROW
DECLARE
v_ilosc_biletow int;
v_ilosc_biletow2 int;
v_id int;
BEGIN
    if inserting then
        SELECT ilosc_biletow INTO v_ilosc_biletow
        FROM koncerty
        WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :NEW.bilety_id);
        
        SELECT id into v_id from koncerty WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :NEW.bilety_id);

        if (:new.ilosc > v_ilosc_biletow) then
            RAISE_APPLICATION_ERROR(-20001, 'Nie można kupić ' || :NEW.ilosc || ' biletów na koncert o ID' ||v_id || ' , ponieważ jest ich dostępnych tylko ' || v_ilosc_biletow || '.');
        else
            UPDATE koncerty
            SET ilosc_biletow = ilosc_biletow - :NEW.ilosc
            WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :NEW.bilety_id);
            SELECT ilosc_biletow INTO v_ilosc_biletow
        FROM koncerty
        WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :NEW.bilety_id);
            dbms_output.put_line('Sprzedano ' || :new.ilosc || ' biletów na koncert o ID ' || v_id|| '. Pozostało ' || v_ilosc_biletow || ' biletów na ten koncert.');
        end if;
    else
        UPDATE koncerty
        SET ilosc_biletow = ilosc_biletow + :old.ilosc
        WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :OLD.bilety_id);
        SELECT id into v_id from koncerty WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :OLD.bilety_id);
        SELECT ilosc_biletow INTO v_ilosc_biletow
        FROM koncerty
        WHERE id = (SELECT koncerty_id FROM bilety WHERE id = :OLD.bilety_id);
        dbms_output.put_line('Anulowano sprzedaz ' || :old.ilosc || ' biletów na koncert o ID ' || v_id ||'. Teraz jest ' || v_ilosc_biletow || ' biletów na ten koncert.');
        
end if;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RAISE_APPLICATION_ERROR(-20002, 'Nie znaleziono biletów o podanym ID');
END;

INSERT INTO sprzedaz_biletow(zamowienia_id,bilety_id,ilosc,sposob_platnosci) VALUES(3,5,45,'przelew');
delete from sprzedaz_biletow where bilety_id=5;