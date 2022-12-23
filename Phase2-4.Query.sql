-- JY

-- 한국 점수 86점 보다 낮은 나라 조회 (Type 1)
SELECT NAME, CREDIT FROM COUNTRY_CREDIT WHERE CREDIT < 86;

-- 위험하다고 판단되는 계좌주의 신상정보를 조회 (Type 2)
SELECT H.H_ID, H.NAME, H.SEX, H.ADDRESS, H.NATIONALITY, H.PHONE_NUMBER
FROM HOLDER H, DNG_HOLDER D
WHERE H.H_ID = D.H_ID;

-- 국가별로 계좌주들의 평균 자산을 출력 (Type 3)
SELECT NATIONALITY, ROUND(AVG(BALANCE), 2) AS AVG_BAL
FROM HOLDER H, ACCOUNT A
WHERE H.H_ID = A.H_ID
GROUP BY NATIONALITY;

-- DNG_TXN의 평균 위험 점수보다 높은 DNG_TXN만 조회 (Type 4)
SELECT * FROM DNG_TXN WHERE SCORE > (SELECT AVG(SCORE) FROM DNG_TXN);

-- 거래 상대의 이름이 위험인물과 일치하는 경우의 TRANSACTION (Type 5)
SELECT * FROM TRANSACTION
WHERE EXISTS ( SELECT * FROM DNG_PERS WHERE NAME=CNTR_NAME );

-- 위험 계좌번호와 TRANSACTION의 상대 계좌번호가 일치하는 경우 (Type 6)
SELECT * FROM TRANSACTION
WHERE (CNTR_ACC_NO) IN (SELECT ACCT_NO FROM DNG_ACCT);

-- 조인된 HOLDER-INITIATION-TXN에서
-- TRANSACTION가 INITIATION 됐을 당시 계좌주의 국가의 점수를 출력 (Type 7)
SELECT TXN_ID, CREDIT AS HLDR_CTRY_CREDIT
FROM (
  SELECT T.TXN_ID AS TXN_ID, H.NATIONALITY AS HLDR_COUNTRY
  FROM HOLDER H, INITIATION I, TRANSACTION T
  WHERE H.H_ID = I.H_ID AND I.TXN_ID = T.TXN_ID
), COUNTRY_CREDIT
WHERE HLDR_COUNTRY = NAME;

-- 계좌주들의 신상 정보와 TRANSACTION 기록을 계좌주의 ID 순서로 먼저 정렬하고
-- 동일 계좌주인 경우 TXN_ID 순서로 출력 (Type 8)
SELECT *
FROM HOLDER H, TRANSACTION T, INITIATION I
WHERE H.H_ID = I.H_ID AND I.TXN_ID = T.TXN_ID
ORDER BY H.H_ID, I.TXN_ID ASC;

-- 위험하다고 판단되는 계좌주들의 국가를 기준으로 평균 점수 도출 (Type 9)
SELECT H.NATIONALITY, AVG(D.SCORE)
FROM DNG_HOLDER D, HOLDER H, COUNTRY_CREDIT C
WHERE C.NAME = H.NATIONALITY AND H.H_ID = D.H_ID
GROUP BY H.NATIONALITY
ORDER BY H.NATIONALITY ASC;

-- 감시대상이 되는 것들의 사유들을 한눈에 조회 (Type 10)
SELECT REASON FROM DNG_PERS UNION
SELECT REASON FROM DNG_ACCT UNION
SELECT REASON FROM DNG_TXN;

-- 특정 TXN_ID를 가진 TRANSACTION 조회
SELECT * FROM TRANSACTION WHERE TXN_ID = 1

-- 특정 TXN_ID를 가진 DNG_TXN 조회
SELECT * FROM DNG_TXN WHERE TXN_ID = 1

-- 특정 TXN_ID를 가진 DNG_TXN의 STATUS를 업데이트
UPDATE DNG_TXN SET STATUS = ? WHERE TXN_ID = 1

-- DY

-- TYPE 1 (used for phase3)
-- 2022년 9월 한 달동안 발생한 거래의 거래 날짜, 거래 금액, 상대방 국가 조회
SELECT T.TXN_DATE, T.AMOUNT, CNTR_CTRY
FROM TRANSACTION T
WHERE T.TXN_DATE BETWEEN TO_DATE('2022-09-01', 'yyyy-mm-dd') AND TO_DATE('2022-09-30', 'yyyy-mm-dd');

-- TYPE 2 (used for phase3)
-- 90000 이상을 거래한 (입금, 출금 모두에 대해) 고객의 id, 이름, 거래 날짜, 거래 금액 조회
SELECT H.H_ID, H.Name, T.TXN_DATE, T.AMOUNT
FROM INITIATION I, HOLDER H, TRANSACTION T
WHERE I.H_ID=H.H_id AND I.TXN_ID=T.TXN_ID AND T.AMOUNT >= 90000;

-- TYPE 3
-- 은행 지점별 출금 거래량 조회 (거래량이 많은 순으로)
SELECT B.BRANCH_NAME, SUM(T.AMOUNT)
FROM INITIATION I JOIN BANK B ON I.BANK_ID=B.BANK_ID JOIN TRANSACTION T on I.TXN_ID = T.TXN_ID
WHERE T.TRANSFER_DIRECTION = 0
GROUP BY B.BRANCH_NAME
ORDER BY SUM(T.AMOUNT) DESC;

-- TYPE 4
-- 평균 계좌 금액(일의 자리까지 반올림)보다 금액을 많이 갖고 있는 고객의 이름, 성별, 국적을 조회
SELECT H.NAME, H.SEX, H.NATIONALITY
FROM HOLDER H JOIN ACCOUNT A ON H.H_ID=A.H_ID
WHERE A.BALANCE > (SELECT ROUND(AVG(AC.BALANCE)) FROM ACCOUNT AC);

-- TYPE 5
-- 위험 고객의 이름과 국적 조회
SELECT H.NAME, H.NATIONALITY
FROM HOLDER H
WHERE EXISTS (SELECT * FROM DNG_HOLDER D WHERE H.H_ID=D.H_ID);

-- TYPE 6
-- 고객 id가 12번(아마 위험인물일 가능성이 높은 고객)인 고객이 거래한 사람들의 국가들을 상대로, 한 번이라도 거래를 한 적이 있는 고객들의 이름 조회
SELECT DISTINCT H.NAME FROM INITIATION I JOIN HOLDER H on I.H_ID = H.H_ID JOIN TRANSACTION T ON I.TXN_ID=T.TXN_ID
WHERE T.CNTR_CTRY IN (select DISTINCT T.CNTR_CTRY
FROM INITIATION I JOIN HOLDER H ON I.H_ID = H.H_ID JOIN TRANSACTION T on I.TXN_ID = T.TXN_ID
WHERE H.H_ID=12);

-- TYPE 7 (used for phase3)
-- 두 개이상의 계좌를 갖고있는 고객들중 국가코드가 'GTM'인 상대와 거래한 적이 있는 고객의 이름, 거래 날짜, 거래 방식, 거래 금액을 조회
WITH TEMP_H AS (SELECT A.H_ID
FROM ACCOUNT A
GROUP BY A.H_ID
HAVING COUNT(*) >= 2
)
SELECT H.Name, T.TXN_DATE, T.METHOD, T.AMOUNT
FROM INITIATION I JOIN TEMP_H TH ON I.H_ID=TH.H_ID JOIN TRANSACTION T ON I.TXN_ID = T.TXN_ID JOIN HOLDER H ON H.H_id=TH.H_ID
WHERE T.CNTR_CTRY = 'GTM';

-- TYPE 8
-- 위험 고객 중 계좌 잔액이 가장 많은 순으로 이름과 계좌번호를 조회
SELECT H.NAME, A.ACCOUNT_NUMBER
FROM HOLDER H, DNG_HOLDER D, ACCOUNT A
WHERE H.H_ID=D.H_ID AND H.H_ID=A.H_ID
ORDER BY A.BALANCE DESC;

-- TYPE 9
-- 고객의 국적과 거래 방향(출금인지 입금인지)별로 거래 금액의 평균(일의 자리까지 반올림), 최대, 최소를
-- 거래방향의 오름차순, 평균 거래금액의 내림차순으로 조회
SELECT H.NATIONALITY, T.TRANSFER_DIRECTION,
       ROUND(AVG(T.AMOUNT)) AS AVG_AMNT, MAX(T.AMOUNT) AS MAX_AMNT, MIN(T.AMOUNT) AS MIN_AMNT
FROM INITIATION I JOIN HOLDER H ON I.H_ID = H.H_ID JOIN TRANSACTION T ON I.TXN_ID = T.TXN_ID
GROUP BY H.NATIONALITY, T.TRANSFER_DIRECTION
ORDER BY T.TRANSFER_DIRECTION ASC, AVG_AMNT DESC;

-- TYPE 10
-- 위험 고객의 계좌가 아닌 계좌를 모두 조회
-- 두 번째 subquery는 natural join
(SELECT A.ACCOUNT_NUMBER FROM ACCOUNT A)
MINUS
(SELECT A.ACCOUNT_NUMBER FROM ACCOUNT A JOIN DNG_HOLDER D ON A.H_ID=D.H_ID);

-- SJ
--TYPE1 (거래금액이 60000이상인 거래 id찾기)
SELECT TXN_ID, AMOUNT FROM TRANSACTION WHERE AMOUNT>60000;

--TYPE2 (상대수신인의 이름이 위험인물 리스트에 있는지 확인하고,그 인물의 은행의 정보와 거래 ID를 출력하기)
SELECT B.BANK_ID, B.BRANCH_NAME, T.TXN_ID FROM TRANSACTION T, DNG_PERS D, BANK B
WHERE T.CNTR_NAME = D.NAME AND B.BANK_ID = D.BANK_ID;

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