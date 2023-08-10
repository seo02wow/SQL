-- 테이블 조인(JOIN) : 2개 이상의 테이블 데이터를 연결해서 1개의 테이블인 것처럼 사용 
SELECT * FROM CUSTOMER WHERE CUSTID = 1; -- 박지성
SELECT * FROM ORDERS WHERE CUSTID = 1; -- 박지성 구입 내역

-- CUSTOMER, ORDERS 테이블 데이터 동시 조회(검색)
-- 조인 문장 
-- (주의)SELECT 절대 동일 컬럼명 2개가 올 수 없다. 별칭사용해서 다른 이름으로 변경 처리
SELECT * 
FROM CUSTOMER, ORDERS -- 조인테이블
WHERE CUSTOMER.CUSTID = ORDERS.CUSTID -- 조인 조건 
  AND CUSTOMER.NAME = '박지성' -- 선택조건(찾을 조건)
;
-------------------------------------------
--테이블 별칭(alias) 사용 : 테이블명을 간단하게 사용하기 위함
-- (주의) 테이블 별칭 사용시 반드시 별칭을 사용해야 함
SELECT *
FROM CUSTOMER C, ORDERS O -- 조인테이블에 대한 별칭 사용 
WHERE C.CUSTID = O.CUSTID -- 조인 조건
AND C.NAME = '박지성' -- 선택 조건
;
--표준 조인 쿼리문
SELECT * 
  FROM CUSTOMER C INNER JOIN ORDERS O -- 조인테이블 정의 (내부조인 - 교집합)
       ON C.CUSTID = O.CUSTID --  조인조건
 WHERE C.NAME = '박지성' -- 선택조건
;
-----------------------------------------------
-- 판매된 책 목록 확인 (BOOK, ORDERS)
SELECT * FROM BOOK;
SELECT * FROM ORDERS; -- 유의미하게 연결 BOOKID
-- 출판한 책 중, 판매된 책 목록 (미디어로 끝나는 출판사)
SELECT O.ORDERID, O.BOOKID,
       B.BOOKID AS B_BOOKID, -- (주의) 동일한 컬럼명이 두 번 사용될 수 없음(별칭 사용)
       B.BOOKNAME, B.PUBLISHER, B.PRICE, O.SALEPRICE, O.ORDERDATE 
 FROM BOOK B, ORDERS O -- 조인테이블
WHERE B.BOOKID = O.BOOKID -- 조인 조건
AND   B.PUBLISHER LIKE '%미디어'
ORDER BY B.PUBLISHER ,  B.BOOKNAME
;
--=================================
--(문제해결) 테이블 조인을 통해서 요청한 데이터 찾기
--실습 : '야구를 부탁해'라는 책이 팔린 내역을 확인(책제목, 판매금액, 판매일자)
--실습 : '야구를 부탁해'라는 책이 몇 권이 팔렸는지 확인
------
--실습 : '추신수'가 구입한 책값과 구입일자를 확인(책값, 구입일자)
--실습 : '추신수'가 구입한 합계금액을 확인
--실습 : 박지성, 추신수가 구입한 내역을 확인(이름, 구입(판매)금액, 구입(판매)일자)
--=================================
--실습 : '야구를 부탁해'라는 책이 팔린 내역을 확인(책제목, 판매금액, 판매일자)
SELECT B.BOOKNAME, O.SALEPRICE, O.ORDERDATE
  FROM BOOK B INNER JOIN ORDERS O -- 교집합 데이터를 찾겠다 
    ON B.BOOKID = O.BOOKID -- 조인조건
 WHERE B.BOOKNAME ='야구를 부탁해' -- 찾을 조건
;

SELECT B.BOOKNAME, O.SALEPRICE, O.ORDERDATE
  FROM BOOK B, ORDERS O
 WHERE B.BOOKID = O.BOOKID -- 조인조건
   AND B.BOOKNAME ='야구를 부탁해'-- 찾을 조건
   ;
--실습 : '야구를 부탁해'라는 책이 몇 권이 팔렸는지 확인
SELECT COUNT(*)
  FROM BOOK B INNER JOIN ORDERS O
    ON B.BOOKID = O.BOOKID
 WHERE B.BOOKNAME ='야구를 부탁해'
;

SELECT COUNT(*)
  FROM BOOK B, ORDERS O 
 WHERE B.BOOKID = O.BOOKID
   AND B.BOOKNAME ='야구를 부탁해'
;
--실습 : '추신수'가 구입한 책값과 구입일자를 확인(책값, 구입일자)
SELECT C.NAME, O.SALEPRICE, O.ORDERDATE
  FROM CUSTOMER C INNER JOIN ORDERS O 
    ON C.CUSTID = O.CUSTID
 WHERE C.NAME = '추신수'
;

SELECT C.NAME, O.SALEPRICE, O.ORDERDATE
  FROM CUSTOMER C, ORDERS O  
 WHERE C.CUSTID = O.CUSTID
   AND C.NAME = '추신수'
;
--실습 : '추신수'가 구입한 합계금액을 확인
-- 그룹함수는 결과 데이터가 한 개이기 때문에 결과값이 여러개인 거랑 같이 쓸 수 없음
SELECT SUM(O.SALEPRICE) AS SUM_PRICE
  FROM CUSTOMER C INNER JOIN ORDERS O 
    ON C.CUSTID = O.CUSTID
 WHERE C.NAME = '추신수'
;

SELECT SUM(O.SALEPRICE)
  FROM CUSTOMER C, ORDERS O
 WHERE C.CUSTID = O.CUSTID
   AND C.NAME = '추신수'
;
--실습 : 박지성, 추신수가 구입한 내역을 확인(이름, 구입(판매)금액, 구입(판매)일자)
SELECT C.NAME, O.SALEPRICE, O.ORDERDATE
  FROM CUSTOMER C INNER JOIN ORDERS O 
    ON C.CUSTID = O.CUSTID
 WHERE C.NAME = '추신수' OR C.NAME='박지성'
;

SELECT C.NAME, O.SALEPRICE, O.ORDERDATE
  FROM CUSTOMER C, ORDERS O
 WHERE C.CUSTID = O.CUSTID
-- AND (C.NAME = '추신수' OR C.NAME='박지성')
   AND C.NAME IN ('추신수','박지성')
;
--==================================
SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;
-- 3개 테이블 조인하기 : CUSTOMER,BOOK,ORDERS
-- 고객명, 책제목, 판매가격, 판매일자, 출판사명(3개 테이블 조인)
-- ORDERS 테이블 기준
-- 조인조건 : O = B, O = C
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE, O.ORDERDATE, B.PUBLISHER 
  FROM ORDERS O, BOOK B, CUSTOMER C -- 조인 대상 테이블
 WHERE O.BOOKID = B.BOOKID -- 조인 조건
   AND O.CUSTID = C.CUSTID -- 조인 조건
;
--------
SELECT  *
  FROM ORDERS O INNER JOIN BOOK B -- 조인테이블
    ON O.BOOKID = B.BOOKID -- 조인 조건1
    INNER JOIN CUSTOMER C -- 조인테이블
    ON O.CUSTID = C.CUSTID -- 조인 조건2
 WHERE C.NAME = '추신수' -- 찾을 조건
;
----------------------------
--조인 조건 : B = O , O = C
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE, O.ORDERDATE, B.PUBLISHER 
  FROM ORDERS O, BOOK B, CUSTOMER C -- 조인 대상 테이블
 WHERE B.BOOKID = O.BOOKID -- 조인 조건
   AND O.CUSTID = C.CUSTID -- 조인 조건
;
--(실습) BOOK, CUSTOMER, ORDERS 테이블 데이터를 조회
--1.장미란이 구입한 책제목, 출판사, 구입가격, 구입일자
--2.장미란이 구입한 책 중에 2014-01-01 ~ 2014-07-08까지 구입한 내역
--3.'야구를 부탁해'라는 책을 구입한 사람과 구입일자를 확인
--4.추신수, 장미란이 구입한 책제목, 구입금액, 구입일자 확인
---- (정렬 : 고객명, 구입일자 순으로)
--5.추신수가 구입한 책갯수, 합계금액, 평균값, 가장 큰금액, 가장 작은금액
--=======================================================
--1.장미란이 구입한 책제목, 출판사, 구입가격, 구입일자
SELECT B.BOOKNAME, B.PUBLISHER, O.SALEPRICE, O.ORDERDATE
FROM BOOK B INNER JOIN ORDERS O 
    ON B.BOOKID = O.BOOKID
    INNER JOIN CUSTOMER C
    ON O.CUSTID = C.CUSTID
WHERE C.NAME = '장미란'
;

SELECT B.BOOKNAME, B.PUBLISHER, O.SALEPRICE, O.ORDERDATE
  FROM BOOK B, ORDERS O, CUSTOMER C
 WHERE B.BOOKID = O.BOOKID AND O.CUSTID = C.CUSTID --조인조건
   AND C.NAME = '장미란' -- 찾을 조건
;
--2.장미란이 구입한 책 중에 2014-01-01 ~ 2014-07-08까지 구입한 내역
SELECT *
FROM BOOK B INNER JOIN ORDERS O 
    ON B.BOOKID = O.BOOKID
    INNER JOIN CUSTOMER C
    ON O.CUSTID = C.CUSTID
WHERE C.NAME = '장미란' 
AND O.ORDERDATE BETWEEN TO_DATE('2014-01-01','YYYY-MM-DD') 
                    AND TO_DATE('2014-07-08','YYYY-MM-DD') 
-- AND O.OREDERDATE >= TO_DATE('2014-01-01','YYYY-MM-DD')
-- AND O.OREDERDATE <= TO_DATE('2014-07-08','YYYY-MM-DD')
;

SELECT *
  FROM BOOK B, ORDERS O, CUSTOMER C
 WHERE B.BOOKID = O.BOOKID
   AND O.CUSTID = C.CUSTID
   AND C.NAME = '장미란' 
   AND O.ORDERDATE BETWEEN TO_DATE('2014-01-01','YYYY-MM-DD') AND TO_DATE('2014-07-08','YYYY-MM-DD') 
   -- 날짜 타입은 날짜타입으로 형변환하기
;
--3.'야구를 부탁해'라는 책을 구입한 사람과 구입일자를 확인
SELECT B.BOOKNAME, C.NAME, O.ORDERDATE
FROM BOOK B INNER JOIN ORDERS O 
    ON B.BOOKID = O.BOOKID
    INNER JOIN CUSTOMER C
    ON O.CUSTID = C.CUSTID
WHERE B.BOOKNAME = '야구를 부탁해'
;

SELECT B.BOOKNAME, C.NAME, O.ORDERDATE
  FROM BOOK B, ORDERS O, CUSTOMER C
 WHERE B.BOOKID = O.BOOKID
   AND O.CUSTID = C.CUSTID
   AND B.BOOKNAME = '야구를 부탁해'
;
--4.추신수, 장미란이 구입한 책제목, 구입금액, 구입일자 확인
---- (정렬 : 고객명, 구입일자 순으로)
SELECT C.NAME, B.BOOKNAME, O.SALEPRICE, O.ORDERDATE
FROM BOOK B INNER JOIN ORDERS O 
    ON B.BOOKID = O.BOOKID
    INNER JOIN CUSTOMER C
    ON O.CUSTID = C.CUSTID
WHERE C.NAME IN ('추신수','장미란')
ORDER BY C.NAME, O.ORDERDATE
;

SELECT C.NAME, B.BOOKNAME, O.SALEPRICE, O.ORDERDATE
  FROM BOOK B, ORDERS O, CUSTOMER C
 WHERE B.BOOKID = O.BOOKID
   AND O.CUSTID = C.CUSTID
   AND C.NAME IN ('추신수','장미란')
   ORDER BY C.NAME, O.ORDERDATE
;

--5.추신수가 구입한 책갯수, 합계금액, 평균값, 가장 큰금액, 가장 작은금액
-- 조인할 테이블 확인하기
SELECT COUNT(*)AS CNT, 
       SUM(O.SALEPRICE)AS SUM_PRICE, 
       AVG(O.SALEPRICE)AS AVG_PRICE, 
       MAX(O.SALEPRICE)AS MAX_PRICE,
       MIN(O.SALEPRICE)AS MIN_PRICE
FROM ORDERS O INNER JOIN CUSTOMER C
    ON O.CUSTID = C.CUSTID
WHERE C.NAME = '추신수'
;
-------------------
-- 고객별 구입한 내역 
SELECT C.NAME,  
       COUNT(*)AS CNT,
       SUM(O.SALEPRICE)AS SUM_PRICE, 
       AVG(O.SALEPRICE)AS AVG_PRICE, 
       MAX(O.SALEPRICE)AS MAX_PRICE,
       MIN(O.SALEPRICE)AS MIN_PRICE
  FROM ORDERS O, CUSTOMER C
 WHERE O.CUSTID = C.CUSTID
   --AND C.NAME IN('추신수','장미란')
   GROUP BY C.NAME
;





