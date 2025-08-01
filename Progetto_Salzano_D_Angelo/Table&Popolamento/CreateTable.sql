--TABLE CLIENTE
CREATE TABLE CLIENTE ( 
USERNAME VARCHAR2(18) CONSTRAINT PK_CLIENTE PRIMARY KEY,
NOME VARCHAR2(16) NOT NULL,
COGNOME VARCHAR2(16) NOT NULL,
ETA NUMBER CHECK (ETA > 17), 
EMAIL VARCHAR2(20) UNIQUE,
CITTA VARCHAR2(14) NOT NULL,
VIA VARCHAR2(20) NOT NULL,
CAP NUMBER(5),
NUMERO_TELEFONO NUMBER UNIQUE,
CONSTRAINT EMAIL_MASK CHECK (
REGEXP_LIKE(email,'^\w+.*@{1}\w+.*$')) -- mail@gmail.com
);



--TABLE ABBONAMENTO
CREATE TABLE ABBONAMENTO ( 
NOME_ABBONAMENTO VARCHAR2(20) CONSTRAINT PK_ABBONAMENTO PRIMARY KEY,
DURATA NUMBER(2), -- IN MESI
COSTO NUMBER(3) 
);



--TABLE EFFETTUA
CREATE TABLE EFFETTUA ( 
NOME_ABBONAMENTO VARCHAR2(20) NOT NULL,
USERNAME VARCHAR2(18) NOT NULL,
DATA_INIZIO_ABB DATE,
DATA_FINE_ABB DATE,
CHECK (DATA_INIZIO_ABB <= DATA_FINE_ABB),
PRIMARY KEY(NOME_ABBONAMENTO,USERNAME),
CONSTRAINT FK_EFFETTUA_ABB FOREIGN KEY (NOME_ABBONAMENTO) REFERENCES ABBONAMENTO(NOME_ABBONAMENTO),
CONSTRAINT FK_EFFETTUA_USER FOREIGN KEY (USERNAME) REFERENCES CLIENTE(USERNAME)
);



--TABLE RELEASE DAY
CREATE TABLE RELEASE_DAY ( 
NOME_RELEASE VARCHAR2(20) CONSTRAINT PK_RELEASE_DAY PRIMARY KEY,
DATA_RELEASE DATE UNIQUE,
TIPO_RELEASE VARCHAR2(30) NOT NULL
);



--TABLE DA ACCESSO
CREATE TABLE DA_ACCESSO ( 
NOME_RELEASE VARCHAR2(20) NOT NULL,
NOME_ABBONAMENTO VARCHAR2(20) NOT NULL,
PRIMARY KEY(NOME_RELEASE,NOME_ABBONAMENTO),
CONSTRAINT FK_ACCESSO_REL FOREIGN KEY (NOME_RELEASE) REFERENCES RELEASE_DAY(NOME_RELEASE),
CONSTRAINT FK_ACCESSO_ABB FOREIGN KEY (NOME_ABBONAMENTO) REFERENCES ABBONAMENTO(NOME_ABBONAMENTO)
);



--TABLE PROMO
CREATE TABLE PROMO ( 
CODICE_PROMO VARCHAR2(20) CONSTRAINT PK_PROMO PRIMARY KEY,
SCONTO NUMBER DEFAULT 0,
DATA_INIZIO_PROMO DATE,
DATA_FINE_PROMO DATE,
CHECK (DATA_INIZIO_PROMO <= DATA_FINE_PROMO),
--OLTRE AL CHECK PER IL CONTROLLO DELLA DATA,INSERITO ANCHE QUELLO DELLA DURATA
--CHE, ESSENDO VARIABILE, NON DEVE MAI SUPERARE I 10 GIORNI
CHECK ((DATA_FINE_PROMO - DATA_INIZIO_PROMO) <= 10),
NOME_PROMO VARCHAR2(20) NOT NULL
);



--TABLE ACQUISTO
CREATE TABLE ACQUISTO ( 
CODICE_ACQUISTO VARCHAR2(20) CONSTRAINT PK_CODICE_ACQUISTO PRIMARY KEY,
CODICE_PROMO VARCHAR2(20) NOT NULL,
DATA_ACQUISTO DATE NOT NULL,
IMPORTO_ACQUISTO NUMBER CHECK (IMPORTO_ACQUISTO IS NOT NULL AND IMPORTO_ACQUISTO < 12000), --TETTO MASSIMO D'ACQUISTO
SPESE_SPEDIZIONE NUMBER CHECK (SPESE_SPEDIZIONE BETWEEN 10 AND 20),  
CONSTRAINT FK_PROMO_ACQUISTO FOREIGN KEY (CODICE_PROMO) REFERENCES PROMO(CODICE_PROMO)
);



--TABLE CATALOGO
CREATE TABLE CATALOGO ( 
NOME_CATALOGO VARCHAR2(16) CONSTRAINT PK_CATALOGO PRIMARY KEY,
NOME_ABBONAMENTO VARCHAR2(20) NOT NULL,
GENERE CHAR(1) CHECK (GENERE IN ('M','F','U')), --UOMO,DONNA,UNISEX
FASCIA_D_ETA VARCHAR2(16) NOT NULL,
CONSTRAINT FK_CATALOGO FOREIGN KEY (NOME_ABBONAMENTO) REFERENCES ABBONAMENTO(NOME_ABBONAMENTO)
);



--TABLE CARTA
CREATE TABLE CARTA ( 
NUMERO_CARTA NUMBER(8) CONSTRAINT PK_CARTA PRIMARY KEY,
USERNAME VARCHAR2(18) NOT NULL,
CODICE_ACQUISTO VARCHAR2(20) NOT NULL,
TIPO_CARTA VARCHAR2(14) NOT NULL,
SCADENZA DATE NOT NULL,
CODICE_SICUREZZA NUMBER(3),
CONSTRAINT FK_CARTA_USER FOREIGN KEY (USERNAME) REFERENCES CLIENTE(USERNAME),
CONSTRAINT FK_CARTA_ACQUISTO FOREIGN KEY (CODICE_ACQUISTO) REFERENCES ACQUISTO(CODICE_ACQUISTO)
);



--TABLE MAGAZZINO
CREATE TABLE MAGAZZINO ( 
NUMERO_MAGAZZINO VARCHAR2(5) CONSTRAINT PK_MAGAZZINO PRIMARY KEY,
CAPIENZA NUMBER CHECK (CAPIENZA < 301),
LUOGO VARCHAR2(14) NOT NULL
);



--TABLE PRODOTTO
CREATE TABLE PRODOTTO ( 
ID_PRODOTTO VARCHAR2(20) CONSTRAINT PK_PRODOTTO PRIMARY KEY,
NOME_CATALOGO VARCHAR2(16) NOT NULL,
CODICE_ACQUISTO VARCHAR2(20) NOT NULL,
BRAND VARCHAR2(16) NOT NULL,
DATA_PUBBLICAZIONE DATE, --PUBBLICAZIONE SUL SITO
CONSTRAINT FK_PRODOTTO_CATALOGO FOREIGN KEY (NOME_CATALOGO) REFERENCES CATALOGO(NOME_CATALOGO),
CONSTRAINT FK_PRODOTTO_ACQUISTO FOREIGN KEY (CODICE_ACQUISTO) REFERENCES ACQUISTO(CODICE_ACQUISTO)
);



--TABLE CAPI HYPE
CREATE TABLE CAPI_HYPE ( 
ID_PRODOTTO VARCHAR2(20) CONSTRAINT PK_CAPI_HYPE PRIMARY KEY,
NOME_CAPO VARCHAR2(20) NOT NULL,
TAGLIA VARCHAR2(4) CHECK (TAGLIA IN ('XS','S','M','L','XL','XXL')),
PREZZO_CAPO NUMBER(4),
TIPOLOGIA VARCHAR2(16) NOT NULL,
TESSUTO VARCHAR2(16) NOT NULL,
CONSTRAINT FK_CAPI FOREIGN KEY (ID_PRODOTTO) REFERENCES PRODOTTO(ID_PRODOTTO)
);



--TABLE SCARPE
CREATE TABLE SCARPE (
ID_PRODOTTO VARCHAR2(20) CONSTRAINT PK_SCARPE PRIMARY KEY,
NOME_SCARPE VARCHAR2(26) NOT NULL,
MODELLO VARCHAR2(16) NOT NULL,
MATERIALE VARCHAR2(16) NOT NULL,
PREZZO_SCARPE NUMBER(4),
CONSTRAINT FK_SCARPE FOREIGN KEY (ID_PRODOTTO) REFERENCES PRODOTTO(ID_PRODOTTO)
);




--TABLE TAGLIA SCARPE
CREATE TABLE TAGLIA_SCARPE ( 
NUMERO_TAGLIA NUMBER(2) CONSTRAINT PK_TAGLIA_SCARPE PRIMARY KEY,
CHECK (NUMERO_TAGLIA BETWEEN 36 AND 51),
PREZZO_TAGLIA NUMBER(4)
);



--TABLE SUDDIVISE IN 
CREATE TABLE SUDDIVISE_IN (
ID_PRODOTTO VARCHAR2(20),
NUMERO_TAGLIA NUMBER(2),
PRIMARY KEY(ID_PRODOTTO,NUMERO_TAGLIA),
CONSTRAINT FK_SUDDIVIS_SCARPE FOREIGN KEY (ID_PRODOTTO) REFERENCES SCARPE(ID_PRODOTTO),
CONSTRAINT FK_SUDDIVIS_TAGLIA FOREIGN KEY (NUMERO_TAGLIA) REFERENCES TAGLIA_SCARPE(NUMERO_TAGLIA)
);



--TABLE FORNITORE
CREATE TABLE FORNITORE ( 
AZIENDA_FORNITORE VARCHAR2(18) CONSTRAINT PK_FORNITORE PRIMARY KEY,
NOME_FORNITORE VARCHAR2(16) NOT NULL,
COGNOME_FORNITORE VARCHAR2(16) NOT NULL,
RECAPITO_TEL NUMBER UNIQUE
);



--TABLE FORNITURA
CREATE TABLE FORNITURA ( 
ID_FORNITURA VARCHAR2(5) CONSTRAINT PK_FORNITURA PRIMARY KEY,
AZIENDA_FORNITORE VARCHAR2(18) NOT NULL,
ID_PRODOTTO VARCHAR2(20) NOT NULL,
DATA_FORNITURA DATE NOT NULL,
QUANTITA NUMBER(3),
TAGLIA_FORNITA VARCHAR2(5) NOT NULL,
PREZZO_FORNITURA NUMBER CHECK (PREZZO_FORNITURA IS NOT NULL AND PREZZO_FORNITURA < 15000), --TETTO SPESA MASSIMO 
CONSTRAINT FK_AZIENDA_FORNITA FOREIGN KEY (AZIENDA_FORNITORE) REFERENCES FORNITORE(AZIENDA_FORNITORE),
CONSTRAINT FK_PRODOTTO_FORNITA FOREIGN KEY (ID_PRODOTTO) REFERENCES PRODOTTO(ID_PRODOTTO)
);



--TABLE E' CONTENUTA IN 
CREATE TABLE E_CONTENUTA_IN ( 
NUMERO_MAGAZZINO VARCHAR2(5),
ID_FORNITURA VARCHAR2(5),
QUANTITA_DISTRIB NUMBER(3), --QUANTITA' PRECISA DI UNA SINGOLA FORNITURA IN UN MAGAZZINO
PRIMARY KEY(NUMERO_MAGAZZINO,ID_FORNITURA),
CONSTRAINT FK_CONTIENE_MAGAZZINO FOREIGN KEY (NUMERO_MAGAZZINO) REFERENCES MAGAZZINO(NUMERO_MAGAZZINO),
CONSTRAINT FK_CONTIENE_FORNITURA FOREIGN KEY (ID_FORNITURA) REFERENCES FORNITURA(ID_FORNITURA)
);


