CREATE TABLE BANK (
    BANK_ID NUMBER(2) NOT NULL,
    LOCATION VARCHAR2(50),  
    PRIMARY KEY (BANK_ID)
);

CREATE TABLE TRANSACTION (
    TXN_ID NUMBER(10) NOT NULL,
    DATE DATE NOT NULL,
    METHOD CHAR(5) NOT NULL,
    AMOUNT NUMBER(12) NOT NULL,
    CNTR_NAME VARCHAR2(50) NOT NULL,
    CNTR_CTRY CHAR(3) NOT NULL,
    CNTR_ACC_NO CHAR(12) NOT NULL,
    ACCOUNT_NUMBER CHAR(12) NOT NULL,
    PRIMARY KEY (TXN_ID),
    FOREIGN KEY (ACCOUNT_NUMBER) REFERENCES ACCOUNT (ACCOUNT_NUMBER) ON DELETE SET NULL
);

CREATE TABLE DNG_TXN (
    TXN_ID NUMBER(10) NOT NULL,
    SCORE NUMBER(3) NOT NULL,
    REASON VARCHAR2(50) NOT NULL,
    FOREIGN KEY (TXN_ID) REFERENCES TRANSACTION (TXN_ID) ON DELETE SET NULL
);

CREATE TABLE INITIATION (
    TXN_ID NUMBER(10) NOT NULL,
    BANK_ID NUMBER(2) NOT NULL,
    H_ID NUMBER(30) NOT NULL,
    FOREIGN KEY (TXN_ID) REFERENCES TRANSACTION (TXN_ID) ON DELETE SET NULL,
    FOREIGN KEY (BANK_ID) REFERENCES BANK (BANK_ID) ON DELETE SET NULL,
    FOREIGN KEY (H_ID) REFERENCES HOLDER (H_ID) ON DELETE SET NULL,
    PRIMARY KEY (TXN_ID)
);