--서브쿼리(SUB QUERY) : SQL문 내부에 있는 SQL문
--SQL(SELECT, INSERTM, UPDATE, DELECT)문 내에 있는 쿼리문
--------------------------
SELECT O.ORDERID, O.SALEPRICE, O.ORDERDATE,
       O.CUSTID, C.NAME,
       O.BOOKID,
       (SELECT BOOKNAME FROM BOOK 
       WHERE BOOKID = O.BOOKID) AS BOOKNAME -- 스칼라 서브쿼리(Scalar Subquery)
FROM ORDERS O,
     (SELECT * FROM CUSTOMER WHERE NAME IN ('장미란','추신수')) C -- 서브쿼리,인라인 뷰(Inline View)
WHERE O.CUSTID = C.CUSTID
AND SALEPRICE > (SELECT AVG(SALEPRICE) FROM ORDERS) -- 중첩 서브쿼리(Nested Subquery)
;
--=======================================
--박지성이 구입한 내역을 검색 
SELECT * FROM ORDERS;
SELECT CUSTID FROM CUSTOMER WHERE NAME = '박지성'; -- CUSTID = 1
SELECT * FROM ORDERS
WHERE CUSTID = 1
;
-- 서브쿼리 사용 
SELECT * FROM ORDERS
WHERE CUSTID = (SELECT CUSTID FROM CUSTOMER WHERE NAME = '박지성')
;
-- 조인문 처리 
SELECT C.NAME, O.*
FROM ORDERS O , CUSTOMER C -- 조인테이블
WHERE O.CUSTID = C.CUSTID -- 조인조건
AND C.NAME = '박지성' -- 선택조건
;
--------------------------------
-- WHERE 절에서 서브쿼리 사용시 서브쿼리 조회 결과가 2건 이상인 경우 IN 사용
SELECT * FROM ORDERS
WHERE CUSTID IN (SELECT CUSTID FROM CUSTOMER 
                WHERE NAME IN ('박지성','김연아'))
;
-------------------------
--(서브쿼리) 책 중 정가가 가장 비싼 도서의 이름을 구하시오
SELECT MAX(PRICE) FROM BOOK; -- 35000 : 가장 비싼 책 금액
SELECT * FROM BOOK WHERE PRICE = 35000;
-- 서브쿼리 적용 : WHERE절에 사용 
SELECT BOOKNAME FROM BOOK 
WHERE PRICE = (SELECT MAX(PRICE) FROM BOOK);
-----------------------
-- 서브쿼리를 FROM 절에 사용 (테이블 조인)
SELECT * 
FROM BOOK B,
     (SELECT MAX(PRICE) AS MAX_PRICE FROM BOOK) M
WHERE B.PRICE = M.MAX_PRICE -- 찾을 조건
;
-----------
--(실습) 박지성, 김연아 구입내역 (서브쿼리 - FROM절)
SELECT * FROM CUSTOMER WHERE NAME IN ('박지성','김연아');

SELECT *
FROM ORDERS O, 
    (SELECT * FROM CUSTOMER WHERE NAME IN ('박지성','김연아')) C
WHERE O.CUSTID = C.CUSTID
;    
-- CUSTOMER, ORDERS 테이블 조인
SELECT *
FROM ORDERS O,CUSTOMER C
WHERE O.CUSTID = C.CUSTID
AND NAME IN ('박지성','김연아')
;
--------
-- SELECT 절에 서브쿼리 사용
SELECT * FROM ORDERS;
SELECT ORDERID,CUSTID,BOOKID,
       (SELECT NAME FROM CUSTOMER WHERE O.CUSTID = CUSTID) CUST_NAME, 
       (SELECT BOOKNAME FROM BOOK WHERE BOOKID = O.BOOKID) BOOK_NAME
       ,SALEPRICE, ORDERDATE
FROM ORDERS O
;
------------
-- 박지성이 구매한 책 목록
SELECT * 
FROM BOOK
WHERE BOOKID IN (SELECT BOOKID 
                   FROM ORDERS 
                   WHERE CUSTID IN (SELECT CUSTID
                                    FROM CUSTOMER
                                    WHERE NAME IN ('박지성'))
                   )
;
--==============================================
--(실습) 서브쿼리 이용
--1. 한 번이라도 구매한 내역이 있는 사람
---- (또는 한 번도 구매하지 않은 사람)
--2. 20000원 이상되는 책을 구입한 고객 명단 조회
--3. '대한미디어' 출판사의 책을 구매한 고객이름 조회
--4. 전체 책가격 평균보다 비싼 책의 목록 조회
--=============================================
--1. 한 번이라도 구매한 내역이 있는 사람
---- (또는 한 번도 구매하지 않은 사람)
SELECT * 
FROM CUSTOMER 
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS)
;
SELECT * 
FROM CUSTOMER 
WHERE CUSTID NOT IN (SELECT CUSTID FROM ORDERS)
;
--조인문
SELECT * 
FROM CUSTOMER C, (SELECT CUSTID FROM ORDERS) O
WHERE C.CUSTID = O.CUSTID
;
--2. 20000원 이상되는 책을 구입한 고객 명단 조회
SELECT * FROM ORDERS WHERE SALEPRICE >= 20000;

-- 조인문
SELECT * FROM CUSTOMER C,
                   (SELECT CUSTID FROM ORDERS 
                   WHERE SALEPRICE >= 20000) O  
WHERE C.CUSTID = O.CUSTID
;

SELECT *
FROM CUSTOMER 
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS 
                WHERE SALEPRICE >= 20000)
;

--3. '대한미디어' 출판사의 책을 구매한 고객이름 조회
SELECT * FROM BOOK WHERE PUBLISHER IN ('대한미디어');
--조인문
SELECT * 
FROM CUSTOMER C,
    (SELECT * FROM BOOK WHERE PUBLISHER IN ('대한미디어')) B,
    (SELECT * FROM ORDERS) O
WHERE O.CUSTID = C.CUSTID
AND O.BOOKID = B.BOOKID
;
SELECT *
FROM CUSTOMER C
WHERE CUSTID IN (SELECT CUSTID FROM ORDERS WHERE BOOKID 
                 IN(SELECT BOOKID FROM BOOK 
                    WHERE PUBLISHER IN ('대한미디어'))
                )
;

--4. 전체 책가격 평균보다 비싼 책의 목록 조회
SELECT AVG(PRICE) FROM BOOK; -- 평균금액
SELECT * 
  FROM BOOK
 WHERE PRICE > (SELECT AVG(PRICE) FROM BOOK)
;




