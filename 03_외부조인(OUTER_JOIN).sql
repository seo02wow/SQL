--(번외) 고객 중 한 권도 구입 안 한 사람은 누구??
-- 고객 테이블에는 있는데 주문 테이블에는 없는 사람
-- 방법 1 ) MINUS : 차집합 처리
SELECT CUSTID FROM CUSTOMER -- 1,2,3,4,5
MINUS -- 교집합 빼기
SELECT DISTINCT CUSTID FROM ORDERS ; -- 1,1,2,3,4,1 . . 
-- 방법 2 ) 서브쿼리(SUB QUERY)
SELECT *
FROM CUSTOMER
WHERE CUSTID NOT IN (SELECT CUSTID FROM ORDERS)
;
-- 방법 3 ) 외부조인(OUTER JOIN)
-- 고객 중 한 번도 구입 내역이 없는 고객 명단 구하기 
--LEFT OUTER JOIN : 좌측 테이블 기준
-- 오라클 
SELECT C.CUSTID, C.NAME, C. ADDRESS, C.PHONE
     , O.ORDERID, O.SALEPRICE 
  FROM CUSTOMER C, ORDERS O 
 WHERE C.CUSTID = O.CUSTID (+) --조인조건(LEFT OUTER JOIN)
 -- 왼쪽 기준으로 아우터 조인하겠다
 AND O.ORDERID IS NULL -- 찾을 조건
;
-- 표준 SQL (LEFT OUTER JOIN)
SELECT  C.CUSTID, C.NAME, C. ADDRESS, C.PHONE
FROM CUSTOMER C LEFT OUTER JOIN ORDERS O --조인조건(LEFT OUTER JOIN)
    ON C.CUSTID = O.CUSTID
WHERE O.ORDERID IS NULL
;
-- RIGHT OUTER JOIN  : 우측 테이블 기준
SELECT  C.CUSTID, C.NAME, C. ADDRESS, C.PHONE
FROM ORDERS O RIGHT OUTER JOIN CUSTOMER C
    ON C.CUSTID = O.CUSTID
WHERE O.ORDERID IS NULL
;
-- 오라클
SELECT C.CUSTID, C.NAME, C. ADDRESS, C.PHONE
  FROM CUSTOMER C, ORDERS O 
 WHERE O.CUSTID (+)=  C.CUSTID  --조인조건(RIGHT OUTER JOIN)
 AND O.ORDERID IS NULL -- 찾을 조건
;
------------------------------------
--조인(JOIN,INNER JOIN,내부조인) : 조인테이블 모두에 존재하는 데이터 검색
--외부조인 (OUTER JOIN) : 어느 한 쪽에만 존재하는 데이터 검색 
------------------------------------
CREATE TABLE DEPT (
    ID VARCHAR2(10) PRIMARY KEY,
    NAME VARCHAR2(30)
);
INSERT INTO DEPT VALUES('10','총무부');
INSERT INTO DEPT VALUES('20','급여부');
INSERT INTO DEPT VALUES('30','IT부');
COMMIT;

CREATE TABLE DEPT1 (
    ID VARCHAR2(10) PRIMARY KEY,
    NAME VARCHAR2(30)
);
INSERT INTO DEPT1 VALUES('10','총무부');
INSERT INTO DEPT1 VALUES('20','급여부');
COMMIT;

CREATE TABLE DEPT2 (
    ID VARCHAR2(10) PRIMARY KEY,
    NAME VARCHAR2(30)
);
INSERT INTO DEPT2 VALUES('20','급여부');
INSERT INTO DEPT2 VALUES('30','IT부');
COMMIT;
--=========================================
SELECT * FROM DEPT; -- 10,20,30
SELECT * FROM DEPT1; -- 10,30
SELECT * FROM DEPT2; --20,30
--LEFT OUTER JOIN : 좌측 테이블 기준(모두 표시)
SELECT * 
 FROM DEPT D, DEPT1 D1
WHERE D.ID = D1.ID (+)
;
--RIGHT OUTER JOIN : 우측 테이블 기준
SELECT * 
 FROM DEPT2 D2, DEPT D
WHERE D2.ID (+) = D.ID 
;
-- FULL OUTER JOIN(표준 SQL) : 두 테이블에 있는 데이터 모두 찾기
SELECT *
FROM DEPT1 D1 FULL OUTER JOIN DEPT2 D2 
ON D1.ID = D2.ID
ORDER BY D1.ID
;
-----------------------------------------
--(실습) DEPT1, DEPT2 테이블 사용해서
--1. DERT1 에는 있고, DEPT2에는 없는 데이터 찾기(LEFT OUTER JOIN)
--2. DERT2 에는 있고, DEPT1에는 없는 데이터 찾기(RIGHT OUTER JOIN)
--------------------------------
--1. DERT1 에는 있고, DEPT2에는 없는 데이터 찾기(LEFT OUTER JOIN)
SELECT D1.* 
FROM DEPT1 D1 LEFT OUTER JOIN DEPT2 D2-- 조인테이블,조인방식(좌측기준)
ON D1.ID = D2.ID
WHERE D2.ID IS NULL
;
-- 오라클
SELECT D1.* 
FROM DEPT1 D1, DEPT2 D2 -- 조인테이블
WHERE D1.ID = D2.ID (+) -- 조인조건(좌측 기준)
AND D2.ID IS NULL -- 찾을 조건
;
--2. DERT2 에는 있고, DEPT1에는 없는 데이터 찾기(RIGHT OUTER JOIN)
SELECT D2.* 
FROM DEPT1 D1 RIGHT OUTER JOIN DEPT2 D2-- 조인테이블,조인방식(우측기준)
ON D1.ID = D2.ID
WHERE D1.ID IS NULL -- 찾을 조건
;
-- 오라클
SELECT D2.* 
FROM DEPT1 D1, DEPT2 D2 -- 조인테이블
WHERE D1.ID (+) = D2.ID -- 조인조건(우측 기준)
AND D1.ID IS NULL -- 찾을 조건
;

