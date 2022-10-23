--TYPE1 (거래금액이 60000이상인 거래 id찾기)
SELECT TXN_ID, AMOUNT FROM TRANSACTION WHERE AMOUNT>60000;

--TYPE2 (상대수신인의 이름이 위험인물 리스트에 있는지 확인하고,그 인물의 은행의 정보와 거래 ID를 출력하기)
SELECT B.BANK_ID, B.BRANCH_NAME, T.TXN_ID FROM TRANSACTION T, DNG_PERS D, BANK B
WHERE T.CNTR_NAME = D.NAME AND B.BANK_ID = D.BANK_ID;

--TYPE3 (수신인의 국가별로 거래 수 확인하기 - 국가 코드로 찾아서 출력할때는 국가 이름으로)
/* SELECT T.CNTR_CTRY, C.NAME, COUNT(CNTR_CTRY) FROM TRANSACTION T, COUNTRY_CREDIT C
WHERE T.CNTR_CTRY = C.COUNTRY_CODE
GROUP BY T.CNTR_CTRY
ORDER BY COUNT(*); */ -- error

--TYPE4 (거래를 시도한 계좌의 주인을 출력)
SELECT H.H_ID, H.NAME FROM HOLDER H, ACCOUNT A
WHERE A.ACCOUNT_NUMBER IN (SELECT A.ACCOUNT_NUMBER FROM ACCOUNT A, TRANSACTION T
WHERE T.ACCOUNT_NUMBER = A.ACCOUNT_NUMBER)
AND A.H_ID = H.H_ID;

--TYPE 5 (위험한 계좌를 소유하고있는 고객의 이름)
SELECT H.NAME FROM ACCOUNT A, HOLDER H
WHERE EXISTS(SELECT A.ACCOUNT_NUMBER FROM ACCOUNT A, DNG_ACCT D
WHERE A.ACCOUNT_NUMBER = D.ACCT_NO)
AND A.H_ID = H.H_ID;

-- TYPE 6 (위험계좌에 속한 계좌번호의 거래ID와 날짜 출력 )
SELECT TXN_ID, TXN_DATE FROM TRANSACTION, DNG_ACCT D
WHERE ACCOUNT_NUMBER IN (SELECT ACCT_NO FROM DNG_ACCT)
AND ACCOUNT_NUMBER = D.ACCT_NO;

--TYPE 7 (거래방법별로 거래 보기)
WITH MTABLE AS
(SELECT DISTINCT METHOD, COUNT(METHOD) AS COUNT FROM TRANSACTION GROUP BY METHOD)
SELECT TXN_ID, TXN_DATE, M.METHOD, M.COUNT FROM TRANSACTION T, MTABLE M
WHERE T.METHOD = M.METHOD AND M.COUNT >= ALL(M.COUNT)
ORDER BY M.COUNT, TXN_ID;

--TYPE 8 (은행ID가 13인 국가중, 국가 신용점수가 높은 순으로 고객이름과 국가 출력하기)
SELECT H.H_ID, H.NATIONALITY FROM HOLDER H, COUNTRY_CREDIT C, BANK B
WHERE B.BANK_ID = 13 AND B.BANK_ID = C.BANK_ID
AND H.NATIONALITY = C.NAME
ORDER BY C.CREDIT DESC;

-- TYPE 9 (국가별 거래금액 계산, 국가코드를 보기쉽게 풀네임으로 출력, 그리고 그 국가의 BANK_ID의 주소 출력)
WITH SUMTABLE AS (SELECT CNTR_CTRY, SUM(AMOUNT) AS AMOUNT FROM TRANSACTION
GROUP BY CNTR_CTRY)
SELECT CC.NAME, S.AMOUNT, B.STREET_ADDRESS
FROM COUNTRY_CREDIT CC, SUMTABLE S, BANK B
WHERE CC.COUNTRY_CODE = S.CNTR_CTRY AND CC.BANK_ID = B.BANK_ID
ORDER BY S.AMOUNT DESC;


-- TYPE 10 (국가 신용도가 50 이상인 국가의 은행 정보 출력)
SELECT BANK_ID, BRANCH_NAME, STREET_ADDRESS FROM BANK
WHERE BANK_ID IN((SELECT BANK_ID FROM BANK) MINUS (SELECT BANK_ID FROM COUNTRY_CREDIT WHERE CREDIT < 50))
