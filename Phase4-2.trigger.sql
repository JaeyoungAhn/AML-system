SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE get_name(
    CNTR_NAME VARCHAR2,
    NAME_ALERT OUT VARCHAR2
)
    IS 
    BEGIN
    -- insert into name_alert
    SELECT NAME INTO NAME_ALERT
    FROM DNG_PERS WHERE CNTR_NAME = NAME;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN dbms_output.put_line('Watchlist NAME과 일치하는 데이터 없음.');
END;
/
CREATE OR REPLACE PROCEDURE get_acct(
    ACCOUNT_NUMBER VARCHAR2,
    ACCOUNT_ALERT OUT VARCHAR2
)
    IS 
    BEGIN
    -- insert into account_alert
    SELECT ACCT_NO INTO ACCOUNT_ALERT
    FROM DNG_ACCT WHERE ACCOUNT_NUMBER = ACCT_NO;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN dbms_output.put_line('Watchlist ACCOUNT와 일치하는 데이터 없음.');
END;
/
CREATE OR REPLACE TRIGGER TXN_ALERT
BEFORE INSERT ON TRANSACTION
FOR EACH ROW
    DECLARE 
    NAME_ALERT VARCHAR2(50) := NULL;
    ACCOUNT_ALERT VARCHAR2(20) := NULL;
    SCORE NUMBER(3);
    REASON VARCHAR2(50);
    STATUS CHAR(1);
    
    BEGIN
    get_name(:NEW.CNTR_NAME, NAME_ALERT);
    get_acct(:NEW.ACCOUNT_NUMBER, ACCOUNT_ALERT);
    
    STATUS := '0'; --judging...
    dbms_output.put_line('Trigger Logic ing...');
    
    -- insert into dng_txn
    IF :NEW.AMOUNT>1000000 AND NAME_ALERT IS NOT NULL AND ACCOUNT_ALERT IS NOT NULL THEN
    REASON := 'Suspicious person & account & transfer too much money.';
    SCORE := 999;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF :NEW.AMOUNT>1000000 AND NAME_ALERT IS NOT NULL THEN
    REASON := 'Suspicious person & transfer too much money.';
    SCORE := 750;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF :NEW.AMOUNT>1000000 AND ACCOUNT_ALERT IS NOT NULL THEN
    REASON := 'Suspicious account & transfer too much money.';
    SCORE := 750;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN VALUES (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF NAME_ALERT IS NOT NULL AND ACCOUNT_ALERT IS NOT NULL THEN
    REASON := 'Suspicious person & account.';
    SCORE := 800;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF NAME_ALERT IS NOT NULL THEN
    REASON := 'Suspicious person.';
    SCORE := 600;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF ACCOUNT_ALERT IS NOT NULL THEN
    REASON := 'Suspicious account.';
    SCORE := 600;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSIF :NEW.AMOUNT>1000000 THEN
    REASON := 'transfer too much money.';
    SCORE := 500;
    :NEW.STATUS := '0';
    INSERT INTO DNG_TXN (TXN_ID, SCORE, REASON, STATUS) VALUES
    (:NEW.TXN_ID, SCORE, REASON, STATUS);
    dbms_output.put_line('New Alert of Transaction occured.: '||:New.TXN_ID);
    dbms_output.put_line('REASON: '||REASON);
    
    ELSE
    :NEW.STATUS := '1';
    dbms_output.put_line('Transaction successd.');
    END IF;
    
    EXCEPTION
    WHEN OTHERS THEN dbms_output.put_line('<<ERROR>>>');
    dbms_output.put_line('에러코드 : ' || SQLCODE);
    dbms_output.put_line('에러내용 : ' || SUBSTR(SQLERRM,1,100));
END TXN_ALERT;