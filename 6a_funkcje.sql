--Autor Tomasz Rycko 19744, PBDiOU

--function 1. returns the percentage share of concerts of a given genre (entered as a parameter) in relation to all concerts

create or replace function pokaz_liczbe_koncertow (p_nazwa_gatunku varchar2) return integer
is
v_liczba_koncertow int;
v_liczba_wszystkich_koncertow int;
begin
select count(id) into v_liczba_koncertow from koncerty k
       WHERE k.wykonawcy_id IN (SELECT gw.wykonawcy_id FROM gatunki_wykonawcy gw
       WHERE gw.gatunki_muzyki_id IN (SELECT gm.id from gatunki_muzyki gm  where gm.nazwa=p_nazwa_gatunku));
select count(id) into v_liczba_wszystkich_koncertow from koncerty;

return v_liczba_koncertow*100/v_liczba_wszystkich_koncertow;
end;

select pokaz_liczbe_koncertow('Rock') from dual;

--function 2. returning concerts that will take place within the number of days given as a parameter
CREATE OR REPLACE FUNCTION zwroc_najblizsze_koncerty (p_liczba_dni INTEGER)
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
END;

--clear reading of the result:
DECLARE
  -- Zmienna przechowująca zestaw wyników zwrócony przez funkcję
  v_cursor SYS_REFCURSOR;
  -- A variable that stores the result set returned by the function
  v_data_koncertu DATE;
  v_wykonawca VARCHAR2(255);
BEGIN
  -- Calling a function and assigning a result set to a variable
  v_cursor := zwroc_najblizsze_koncerty(1200);

  -- Loop iterating through the result set
  LOOP
    -- Reading a single line
    FETCH v_cursor INTO v_data_koncertu, v_wykonawca;
    -- If there are no more rows, break the loop
    EXIT WHEN v_cursor%NOTFOUND;
    -- Print data from the row
    DBMS_OUTPUT.PUT_LINE('Data koncertu: ' || v_data_koncertu);
    DBMS_OUTPUT.PUT_LINE('Wykonawca: ' || v_wykonawca);
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
  END LOOP;

  -- Closing a result set
  CLOSE v_cursor;
END;


--function 3. which checks whether the artist with the given id plays more concerts in a given month and year than the average number of concerts of other artists in a given month and year
CREATE OR REPLACE FUNCTION czy_wieksza_niz_srednia (p_id_wykonawcy IN INT, p_miesiac IN NUMBER, p_rok IN NUMBER)
RETURN BOOLEAN
AS
    v_liczba_koncertow NUMBER;
    v_srednia NUMBER;
BEGIN
    -- Get the number of concerts of a given artist in a given month
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
END;

begin
if(czy_wieksza_niz_srednia (1,6,2020))
then
dbms_output.put_line('tak');
else
dbms_output.put_line('nie');
end if;
end;

--function 4th function returning a list of invoices that were paid at least a week later than they were issued. In addition, there is information about customers and how many days late the invoice was paid.
CREATE OR REPLACE FUNCTION zwroc_opoznione_platnosci
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
END;

--reading the result:
VARIABLE v_cursor REFCURSOR;
BEGIN
    :v_cursor := zwroc_opoznione_platnosci;
END;
/

PRINT v_cursor;

--function 5. function returning a boolean value checking whether the ticket with the given id is popular and is often bought.
CREATE OR REPLACE FUNCTION czy_bilet_popularny (
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
END;

begin
if(czy_bilet_popularny(8)) then
dbms_output.put_line('tak');
else
dbms_output.put_line('nie');
end if;
end;

--function overloaded
create or replace function pokaz_liczbe_koncertow (p_id_gatunku int) return number
is
v_liczba_koncertow int;
v_liczba_wszystkich_koncertow int;
begin
select count(id) into v_liczba_koncertow from koncerty k
       WHERE k.wykonawcy_id IN (SELECT gw.wykonawcy_id FROM gatunki_wykonawcy gw
       WHERE gw.gatunki_muzyki_id IN (SELECT gm.id from gatunki_muzyki gm  where gm.id=p_id_gatunku));
select count(id) into v_liczba_wszystkich_koncertow from koncerty;

return round(v_liczba_koncertow*100/v_liczba_wszystkich_koncertow,2);
end;
