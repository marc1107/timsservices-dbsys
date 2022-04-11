CREATE TABLE Land(
    LandName    VARCHAR(100) PRIMARY KEY,
    CONSTRAINT  size_Land CHECK (LENGTH(LandName) >= 2)
);

CREATE TABLE Adresse(
    AdrID       CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( AdrID, '^[0-9]{12}$' )), 
    LandName    VARCHAR(100) NOT NULL,
    PLZ         VARCHAR(10) NOT NULL,
    HausNr      VARCHAR(10) NOT NULL,
    Strasse     VARCHAR(100) NOT NULL,
    Stadt       VARCHAR(100) NOT NULL,
    CONSTRAINT  pk_Adresse PRIMARY KEY(AdrID),
    CONSTRAINT  fk_Adresse FOREIGN KEY(LandName) REFERENCES Land(LandName)
);

CREATE TABLE Kunde(
    Email       VARCHAR(50) NOT NULL,
    KundenName  VARCHAR(50) NOT NULL,
    IBAN        VARCHAR(30) NOT NULL,
    Passwort    VARCHAR(50) NOT NULL,
    Newsletter  CHAR(1) NOT NULL CHECK (Newsletter in ( '1', '0' )),
    AdrID       CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( AdrID, '^[0-9]{12}$' )),
    CONSTRAINT  pk_Kunde PRIMARY KEY(Email),
    CONSTRAINT  fk_Kunde FOREIGN KEY(AdrID) REFERENCES Adresse(AdrID)
);

CREATE TABLE Buchung(
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
    CONSTRAINT  pk_Buchung PRIMARY KEY(BuchungsNr),
    CONSTRAINT  fk_Buchung FOREIGN KEY(EMail) REFERENCES Kunde(Email)
);

CREATE TABLE FerienWhng(
    FWID        CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( FWID, '^[0-9]{12}$' )),
    Preis       NUMBER(8, 2) NOT NULL,
    FWName      VARCHAR(50) NOT NULL,
    AnzZimmer   INTEGER NOT NULL,
    Groesse     NUMBER(6, 2) NOT NULL,
    Bild        VARCHAR(500) NOT NULL,
    AdrID       CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( AdrID, '^[0-9]{12}$' )),
    CONSTRAINT  pk_FerienWhng PRIMARY KEY(FWID),
    CONSTRAINT  fk_FerienWhng FOREIGN KEY(AdrID) REFERENCES Adresse(AdrID)
);

CREATE TABLE TouristenAttr(
    TAName          VARCHAR(50) NOT NULL,
    Beschreibung    VARCHAR(300) NOT NULL,
    CONSTRAINT  pk_TouristenAttr PRIMARY KEY(TAName)
);

CREATE TABLE Entfernung_FW_TA(
    TAName      VARCHAR(50) NOT NULL,
    FWID        CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( FWID, '^[0-9]{12}$' )),
    Entfernung  NUMBER(4, 1) NOT NULL,
    
    CONSTRAINT  fk_Entfernung1 FOREIGN KEY(TAName) REFERENCES TouristenAttr(TAName) ON DELETE CASCADE,
    CONSTRAINT  fk_Entfernung2 FOREIGN KEY(FWID) REFERENCES FerienWhng(FWID) ON DELETE CASCADE,
    CONSTRAINT  pk_Entfernung PRIMARY KEY(TAName, FWID)
);

CREATE TABLE Anzahlung(
    AnzID       CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( AnzID, '^[0-9]{12}$' )),
    RechnungsNr  CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( RechnungsNr, '^[0-9]{12}$' )),
    AnzBetrag   NUMBER(8, 2) NOT NULL CHECK (AnzBetrag >= 0),
    AnzDatum    DATE NOT NULL,
    CONSTRAINT  pk_Anzahlung PRIMARY KEY(AnzID)
);

CREATE TABLE Ausstattung(
    AusstattungName VARCHAR(50) NOT NULL,
    CONSTRAINT  pk_Ausstattung PRIMARY KEY(AusstattungName)
);

CREATE TABLE besitztAusstattung(
    AusstattungName VARCHAR(50) NOT NULL,
    FWID            CHAR(12) NOT NULL CHECK(REGEXP_LIKE ( FWID, '^[0-9]{12}$' )),
    CONSTRAINT  fk_besitztAusstattung1 FOREIGN KEY(AusstattungName) REFERENCES Ausstattung(AusstattungName) ON DELETE CASCADE,
    CONSTRAINT  fk_besitztAusstattung2 FOREIGN KEY(FWID) REFERENCES FerienWhng(FWID) ON DELETE CASCADE,
    CONSTRAINT  pk_besitztAusstattung PRIMARY KEY(AusstattungName, FWID)
);
