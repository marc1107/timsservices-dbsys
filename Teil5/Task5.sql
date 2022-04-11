
CREATE TABLE StornierteBuchungen(
    BuchungsNr      CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( BuchungsNr, '^[0-9]{12}$' )),
    FWID            CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( FWID, '^[0-9]{12}$' )),
    Email           VARCHAR(50) NOT NULL,
    BuchDatum       DATE NOT NULL,
    AnrDatum        DATE NOT NULL,
    AbrDatum        DATE NOT NULL,
    RechnungsNr     CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( RechnungsNr, '^[0-9]{12}$' )),
    RechnungsDatum  DATE NOT NULL,
    RechnungsBetrag NUMBER(8, 2) NOT NULL,
    BewDatum        DATE NOT NULL,
    AnzSterne       INTEGER NOT NULL CHECK (AnzSterne >= 1 AND AnzSterne <= 5),
    StornierDatum   DATE
);

DELETE FROM Buchung WHERE BuchungsNr = 000000000002;
--ROLLBACK;

CREATE OR REPLACE TRIGGER TriggerInsertStorniert 
BEFORE DELETE
    ON Buchung
    FOR EACH ROW
BEGIN
    INSERT INTO StornierteBuchungen(
    BuchungsNr,
    FWID,
    EMAIL,
    BuchDatum,
    AnrDatum,
    AbrDatum,
    RechnungsNr,
    RechnungsDatum,
    RechnungsBetrag,
    BewDatum,
    AnzSterne,
    StornierDatum
    )
    VALUES (
    :OLD.BuchungsNr,
    :OLD.FWID,
    :OLD.EMAIL,
    :OLD.BuchDatum,
    :OLD.AnrDatum,
    :OLD.AbrDatum,
    :OLD.RechnungsNr,
    :OLD.RechnungsDatum,
    :OLD.RechnungsBetrag,
    :OLD.BewDatum,
    :OLD.AnzSterne,
    TO_DATE(SYSDATE, 'dd.mm.yyyy')
    );
END;
/

--DROP TABLE ANZAHLUNG;

CREATE OR REPLACE VIEW Kunde_Buchung as
select EMAIL, COUNT(DISTINCT BuchungsNr) as
Anzahl_Buchungen, sum(RechnungsBetrag) as
Summe_Zahlungen
FROM Buchung
GROUP BY EMAIL;

CREATE OR REPLACE VIEW Kunde_Stornierung
as SELECT EMAIL, COUNT(BuchungsNr) AS
Anzahl_Stornierungen
FROM StornierteBuchungen
GROUP BY EMAIL;

CREATE OR REPLACE VIEW Kundenstatistik AS
SELECT Kunde.EMAIL AS Mail_Adresse,
nvl(Anzahl_Buchungen, 0) AS Anzahl_Buchungen, nvl(Anzahl_Stornierungen, 0) AS
Anzahl_Stornierungen, nvl(Summe_Zahlungen, 0) AS Summe_Zahlungen
FROM Kunde LEFT OUTER JOIN Kunde_Buchung ON
Kunde.EMAIL = Kunde_Buchung.Email
LEFT OUTER JOIN Kunde_Stornierung ON
Kunde.Email = Kunde_Stornierung.Email;

SELECT * FROM Kundenstatistik;   