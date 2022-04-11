-- LAND
INSERT INTO Land (Landname) VALUES ('Spanien');
INSERT INTO Land (Landname) VALUES ('Frankreich');
INSERT INTO Land (Landname) VALUES ('Grichenland');
INSERT INTO LAND (Landname) VALUES ('Deutschland');
INSERT INTO LAND (Landname) VALUES ('Schweiz');
INSERT INTO Land (Landname) VALUES ('Italien');

-- TOURISTENATTR
INSERT INTO Touristenattr (TaName, Beschreibung) VALUES ('Wasserpark', 'Ein toller Wasserpark fuer die ganze Familie');
INSERT INTO Touristenattr (TaName, Beschreibung) VALUES ('Kletterpark', 'Ein toller Kletterpark fuer die ganze Familie');

-- ADRESSE
INSERT INTO Adresse (AdrID, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000001', 'Spanien', 43460, 12, 'Weinbergstrasse', 'Barcelona');
INSERT INTO Adresse (AdrId, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000002', 'Italien', 87271, 3, 'Tavernenstrasse', 'Rom');
INSERT INTO Adresse (AdrId, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000003', 'Frankreich', 54524, 135, 'Schneckengasse', 'Paris');
INSERT INTO Adresse (AdrID, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000004', 'Deutschland', 72770, 8, 'Wallensteinstrasse', 'Reutlingen');
INSERT INTO Adresse (AdrId, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000005', 'Schweiz', 8000, 1, 'Blumengaessle', 'Zuerich');
INSERT INTO Adresse (AdrId, Landname, PLZ, HausNr, Strasse, Stadt) VALUES ('000000000006', 'Grichenland', 54524, 69, 'Traubenstrasse', 'Athen');

-- AUSSTATTUNG
INSERT INTO Ausstattung (AusstattungName) VALUES ('Sauna');
INSERT INTO Ausstattung (AusstattungName) VALUES ('Pool');
INSERT INTO Ausstattung (AusstattungName) VALUES ('Gym');

-- KUNDE
INSERT INTO Kunde (Email, Kundenname, IBAN, Passwort, Newsletter, AdrID) VALUES ('uwe@gmail.com', 'Uwe Schmitt', 'DE650002355', 'IchBinDerUwe!', '1', '000000000004');
INSERT INTO Kunde (Email, Kundenname, IBAN, Passwort, Newsletter, AdrID) VALUES ('jochen@web.de', 'Jochen Schwarz', 'DE735102347', 'IchBinDerJochen!', '0', '000000000005');
INSERT INTO Kunde (Email, Kundenname, IBAN, Passwort, Newsletter, AdrID) VALUES ('rudolf@gmx.com', 'Rudolf Stein', 'DE850350341', 'IchBinDerRudolf!', '0', '000000000006');

-- FERIENWHNG
INSERT INTO FERIENWHNG (FwID, Preis, FwName, AnzZimmer, Groesse, Bild, AdrID) 
    VALUES ('000000000001', 345.00, 'Villa Kunterbunt', 12, 1399, 'https://bordesholmer.land/wp-content/uploads/2019/03/villa-kunterbunt.jpg', '000000000001');
INSERT INTO FERIENWHNG (FwID, Preis, FwName, AnzZimmer, Groesse, Bild, AdrID) 
    VALUES ('000000000002', 35.50, 'Villa Sorgenlos', 4, 500, 'https://www.allkauf-ausbauhaus.de/fileadmin/_processed_/4/a/csm_allkauf-fertighaus-city-villa-02-alt_f8691c4d86.jpg', '000000000002');
INSERT INTO FERIENWHNG (FwID, Preis, FwName, AnzZimmer, Groesse, Bild, AdrID) 
    VALUES ('000000000003', 199.99, 'Villa Sonnenschein', 8, 900, 'https://q-cf.bstatic.com/images/hotel/max1024x768/163/163300408.jpg', '000000000003');
INSERT INTO FERIENWHNG (FwID, Preis, FwName, AnzZimmer, Groesse, Bild, AdrID) 
    VALUES ('000000000004', 109.49, 'Villa Rosenstein', 5, 300, 'https://q-cf.bstatic.com/images/hotel/max1024x768/163/163300408.jpg', '000000000003');

-- ENTFERNUNG_FW_TA
INSERT INTO ENTFERNUNG_FW_TA (TaName, FwID, Entfernung) VALUES ('Wasserpark', '000000000001', 12.5);
INSERT INTO ENTFERNUNG_FW_TA (TaName, FwID, Entfernung) VALUES ('Kletterpark', '000000000001', 3.2);
INSERT INTO ENTFERNUNG_FW_TA (TaName, FwID, Entfernung) VALUES ('Wasserpark', '000000000002', 874.7);
INSERT INTO ENTFERNUNG_FW_TA (TaName, FwID, Entfernung) VALUES ('Kletterpark', '000000000003', 235.9);

-- BUCHUNG
INSERT INTO Buchung (BuchungsNr, FwID, Email, BuchDatum, AnrDatum, AbrDatum, RechnungsNr, RechnungsDatum, RechnungsBetrag, BewDatum, AnzSterne) VALUES ('000000000001', '000000000001', 'rudolf@gmx.com', TO_DATE('09.12.2019', 'dd.mm.yyyy'), TO_DATE('20.07.2020', 'dd.mm.yyyy'), TO_DATE('14.08.2020', 'dd.mm.yyyy'), '000000000001', TO_DATE('09.12.2019', 'dd.mm.yyyy'), 1300.99, TO_DATE('24.08.2020', 'dd.mm.yyyy'), 5);
INSERT INTO Buchung (BuchungsNr, FwID, Email, BuchDatum, AnrDatum, AbrDatum, RechnungsNr, RechnungsDatum, RechnungsBetrag, BewDatum, AnzSterne) VALUES ('000000000002', '000000000003', 'jochen@web.de', TO_DATE('09.12.2019', 'dd.mm.yyyy'), TO_DATE('20.07.2020', 'dd.mm.yyyy'), TO_DATE('23.12.2020', 'dd.mm.yyyy'), '000000000002', TO_DATE('27.12.2019', 'dd.mm.yyyy'), 2300.99, TO_DATE('24.01.2020', 'dd.mm.yyyy'), 4);
-- BESITZTAUSSTATTUNG
INSERT INTO besitztAusstattung (AusstattungName, FWID) VALUES ('Sauna', '000000000001');
INSERT INTO besitztAusstattung (AusstattungName, FWID) VALUES ('Pool', '000000000001');
INSERT INTO besitztAusstattung (AusstattungName, FWID) VALUES ('Gym', '000000000001');
INSERT INTO besitztAusstattung (AusstattungName, FWID) VALUES ('Pool', '000000000002');
INSERT INTO besitztAusstattung (AusstattungName, FWID) VALUES ('Sauna', '000000000002');
INSERT INTO besitztAusstattung (AusstattungName, FwID) VALUES ('Gym', '000000000003');
