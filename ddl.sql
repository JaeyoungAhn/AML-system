CREATE TABLE BANK (
    BANK_ID VARCHAR2(10) NOT NULL,
    LOCATION VARCHAR2(50),  
    PRIMARY KEY (BANK_ID)
);

CREATE TABLE ACCOUNT(
	ACCOUNT_NUMBER VARCHAR2(20) NOT NULL,
	BALANCE NUMBER(12),
	PASSWORD VARCHAR2(10) NOT NULL,
	H_ID CHAR(10) NOT NULL,
	PRIMARY KEY(ACCOUNT_NUMBER)
);

CREATE TABLE TRANSACTION (
    TXN_ID NUMBER(10) NOT NULL,
	TXN_DATE DATE NOT NULL,
    METHOD CHAR(5) NOT NULL,
    AMOUNT NUMBER(12) NOT NULL,
    CNTR_NAME VARCHAR2(50) NOT NULL,
    CNTR_CTRY CHAR(3) NOT NULL,
    CNTR_ACC_NO CHAR(12) NOT NULL,
    ACCOUNT_NUMBER VARCHAR2(20) NOT NULL,
    PRIMARY KEY (TXN_ID),
    FOREIGN KEY (ACCOUNT_NUMBER) REFERENCES ACCOUNT (ACCOUNT_NUMBER)
);

CREATE TABLE DNG_TXN (
    TXN_ID NUMBER(10) NOT NULL,
    SCORE NUMBER(3) NOT NULL,
    REASON VARCHAR2(50) NOT NULL,
    FOREIGN KEY (TXN_ID) REFERENCES TRANSACTION (TXN_ID)
);

CREATE TABLE HOLDER(
	H_ID CHAR(10) NOT NULL,
	ADDRESS VARCHAR2(50),
	COUNTRY VARCHAR2(20) NOT NULL,
	PHONE_NUMBER VARCHAR2(20) NOT NULL,
	PRIMARY KEY(H_ID),
	UNIQUE(PHONE_NUMBER)
);

CREATE TABLE INITIATION (
    TXN_ID NUMBER(10) NOT NULL,
    BANK_ID VARCHAR2(10) NOT NULL,
    H_ID CHAR(10) NOT NULL,
    FOREIGN KEY (TXN_ID) REFERENCES TRANSACTION (TXN_ID),
    FOREIGN KEY (BANK_ID) REFERENCES BANK (BANK_ID),
    FOREIGN KEY (H_ID) REFERENCES HOLDER (H_ID),
    PRIMARY KEY (TXN_ID)
);


CREATE TABLE DNG_HOLDER(
	H_ID CHAR(10) NOT NULL,
	SCORE NUMBER(3) NOT NULL,
	PRIMARY KEY(H_ID)
);

ALTER TABLE DNG_HOLDER ADD FOREIGN KEY (H_ID) 
REFERENCES HOLDER(H_ID);

ALTER TABLE ACCOUNT ADD FOREIGN KEY (H_ID) 
REFERENCES HOLDER(H_ID);


CREATE TABLE DNG_PERS (
    DNG_ID      NUMBER          NOT NULL,
    DNAME       VARCHAR2(20)    NOT NULL,
    REASON      VARCHAR2(50),
    BANK_ID     VARCHAR2(5),
    PRIMARY KEY (DNG_ID)
);

CREATE TABLE DNG_ACCT (
    ACCT_NO     VARCHAR2(20)     NOT NULL,
    REASON      VARCHAR2(50),
    BANK_ID     VARCHAR2(5),
    PRIMARY KEY (ACCT_NO)
);

CREATE TABLE COUNTRY_CREDIT (
    NAME        VARCHAR2(20)     NOT NULL,
    CREDIT      Number,
    BANK_ID     VARCHAR2(5),
    PRIMARY KEY (NAME)
);

ALTER TABLE DNG_PERS ADD FOREIGN KEY (BANK_ID) REFERENCES BANK(BANK_ID);
ALTER TABLE DNG_ACCT ADD FOREIGN KEY (BANK_ID) REFERENCES BANK(BANK_ID);
ALTER TABLE COUNTRY_CREDIT ADD FOREIGN KEY (BANK_ID) REFERENCES BANK(BANK_ID);
