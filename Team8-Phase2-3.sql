-- 한국 점수 86점 보다 낮은 나라 조회 (Type 1)
SELECT NAME, CREDIT FROM COUNTRY_CREDIT WHERE CREDIT < 86

-- 위험하다고 판단되는 계좌주의 신상정보를 조회 (Type 2)
SELECT H.H_ID, H.NAME, H.SEX, H.ADDRESS, H.NATIONALITY, H.PHONE_NUMBER
FROM HOLDER H, DNG_HOLDER D
WHERE H.H_ID = D.H_ID

-- 국가별로 계좌주들의 평균 자산을 출력 (Type 3)
SELECT NATIONALITY, AVG(BALANCE) AS AVG_BAL
FROM HOLDER H, ACCOUNT A
WHERE H.H_ID = A.H_ID
GROUP BY NATIONALITY

-- DNG_TXN의 평균 위험 점수보다 높은 DNG_TXN만 조회 (Type 4)
SELECT * FROM DNG_TXN WHERE SCORE > (SELECT AVG(SCORE) FROM DNG_TXN)

-- 거래 상대의 이름이 위험인물과 일치하는 경우의 TRANSACTION (Type 5)
SELECT * FROM TRANSACTION
WHERE EXISTS ( SELECT * FROM DNG_PERS WHERE NAME=CNTR_NAME )

-- 위험 계좌번호와 TRANSACTION의 상대 계좌번호가 일치하는 경우 (Type 6)
SELECT * FROM TRANSACTION
WHERE (CNTR_ACC_NO) IN (SELECT ACCT_NO FROM DNG_ACCT) ;

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

SELECT REASON FROM DNG_PERS
UNION
SELECT REASON FROM DNG_ACCT
UNION
SELECT REASON FROM DNG_TXN
