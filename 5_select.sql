--Author Tomasz Rycko 19744, PBDiOU

--widok 1. a view containing data about the performers and the number of tickets sold for their concerts and the total price of tickets sold

CREATE VIEW v_bilety_sprzedane_wykonawcy AS
SELECT w.id AS "ID wykonawcy",
       w.nazwa AS "Nazwa wykonawcy",
       (SELECT SUM(ilosc) FROM sprzedaz_biletow sb
       WHERE sb.bilety_id IN (SELECT b.id FROM bilety b 
       WHERE b.koncerty_id IN (SELECT k.id from koncerty k where k.wykonawcy_id=w.id)))
       AS "Liczba sprzedanych biletów",
       (SELECT SUM(cena) FROM sprzedaz_biletow sb
       WHERE sb.bilety_id IN (SELECT b.id FROM bilety b 
       WHERE b.koncerty_id IN (SELECT k.id from koncerty k where k.wykonawcy_id=w.id)))
       AS "Cena sprzedanych biletów"
FROM wykonawcy w;

select * from v_bilety_sprzedane_wykonawcy

-- view2. a view containing data about customers and the number of purchased tickets for concerts
CREATE VIEW v_bilety_kupione_klienci AS
SELECT k.id AS "ID wykonawcy",
       k.imie AS "Imię klienta",
       k.nazwisko AS "Nazwisko klienta",
       (SELECT NVL(SUM(ilosc),0) FROM sprzedaz_biletow sb
       WHERE sb.zamowienia_id IN (SELECT z.id FROM zamowienia z 
       WHERE z.klienci_id =k.id))
       AS "Liczba kupionych biletów"
FROM klienci k ORDER BY "Liczba kupionych biletów" DESC,"Nazwisko klienta";

select * from v_bilety_kupione_klienci