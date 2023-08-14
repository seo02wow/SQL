/* ===================
SELECT * | [ DISTINCT ] {컬럼명, 컬럼명, ...}
  FROM 테이블명
[WHERE 조건절]
[GROUP BY {컬럼명, ....}
    [HAVING 조건] ] --GROUP BY 절에 대한 조건 / 단독으로 못 씀
[ORDER BY {컬럼명 [ASC | DESC], ....}] 
===================== */
-- GROUP BY : 데이터를 그룹핑해서 처리할 경우 사용 
-- GROUP BY문을 사용하면 SELECT (절)항목에 사용할 수 있는 데이터가 제한됨
---- GROUP BY 절에 사용된 컬럼 또는 그룹함수(COUNT,SUM,AVG,MAX,MIN) 사용 가능 
--- 상수값 사용가능(하나의 문자열, 숫자, 날짜 값)
---------------------------
-- HAVING 절은 단독으로 사용할 수 없고, 반드시 GROUP BY 절과 함께 사용 (종속절)
-- HAVING 절 : GROUP BY 절에 의해서 만들어진 데이터에서 검색(선택)조건 부여
--=========================
-- 출판사별 출판한 책의 개수 구하기
SELECT PUBLISHER, COUNT(*),
       SUM(PRICE), AVG(PRICE), MAX(PRICE),MIN(PRICE)
  FROM BOOK
  GROUP BY PUBLISHER
;
-- 구매 고객별로 구매금액 합계를 구하시오 
SELECT CUSTID,SUM(SALEPRICE) 
  FROM ORDERS
  GROUP BY CUSTID
;
-- 이름표시 : 이름으로 그룹핑
SELECT C.NAME, SUM(O.SALEPRICE)
  FROM ORDERS O, CUSTOMER C
 WHERE O.CUSTID = C.CUSTID
 GROUP BY C.NAME
--ORDER BY SUM(O.SALEPRICE) DESC -- 많이 구입한 금액부터
 ORDER BY 2 DESC -- SELECT절의 위치로 표시 가능 
;
--
SELECT C.NAME, SUM(O.SALEPRICE) AS SUM_PRICE
  FROM ORDERS O, CUSTOMER C
 WHERE O.CUSTID = C.CUSTID
 GROUP BY C.NAME
 ORDER BY SUM_PRICE DESC -- 별칭으로도 가능
;
--------------------
--주문(판매) 테이블의 고객별 데이터 조회(건수,합계,평균,최소,최대금액)
SELECT CUSTID,
       COUNT(*),SUM(SALEPRICE),TRUNC(AVG(SALEPRICE)),
       MIN(SALEPRICE),MAX(SALEPRICE)
  FROM ORDERS 
  GROUP BY CUSTID
;
--고객별 데이터 중 박지성, 추신수 데이터 조회(건수,합계,평균,최소,최대금액)
SELECT C.NAME,
       COUNT(*),SUM(O.SALEPRICE),TRUNC(AVG(O.SALEPRICE)),
       MIN(O.SALEPRICE),MAX(O.SALEPRICE)
  FROM ORDERS O, CUSTOMER C
  WHERE O.CUSTID = C.CUSTID
    AND C.NAME IN ('박지성','추신수')
  GROUP BY C.NAME
;
--------------------------------
--(실습) 고객명 기준으로 고객별 데이터 조회 (건수,합계,평균,최소,최대금액)
-- 추신수,장미란 고객 2명만 조회(검색)

-- 표준 SQL
SELECT C.NAME,
       COUNT(*),SUM(O.SALEPRICE),TRUNC(AVG(O.SALEPRICE)),
       MIN(O.SALEPRICE),MAX(O.SALEPRICE)
  FROM CUSTOMER C INNER JOIN ORDERS O
        ON C.CUSTID = O.CUSTID
 WHERE C.NAME IN ('장미란','추신수')
   GROUP BY C.NAME
;
--
SELECT C.NAME,
       COUNT(*),SUM(O.SALEPRICE),TRUNC(AVG(O.SALEPRICE)),
       MIN(O.SALEPRICE),MAX(O.SALEPRICE)
FROM CUSTOMER C, ORDERS O
WHERE C.CUSTID = O.CUSTID
  GROUP BY C.NAME
  HAVING C.NAME IN ('장미란','추신수')
;
---------------------------------------
-- HAVING 절은 단독으로 사용할 수 없고, 반드시 GROUP BY 절과 함께 사용 (종속절)
-- HAVING 절 : GROUP BY 절에 의해서 만들어진 데이터에서 검색(선택)조건 부여 
---------------
-- 3건 이상 구입한 고객 조회 (이름,구입수량)
SELECT C.NAME, COUNT(*) AS CNT
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID = C.CUSTID
 GROUP BY C.NAME
 HAVING COUNT(*) >=3
;
--------------------------
-- 구매한 책 중에 20000원 이상인 책을 구입한 사람의 통계 데이터
SELECT C.NAME, COUNT(*) AS CNT,
       SUM(O.SALEPRICE),TRUNC(AVG(O.SALEPRICE)),
       MIN(O.SALEPRICE),MAX(O.SALEPRICE)
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID = C.CUSTID
  AND O.SALEPRICE >= 20000  -- 20000원 이상의 책들만 대상
 GROUP BY C.NAME
;

SELECT C.NAME,
       SUM(O.SALEPRICE),TRUNC(AVG(O.SALEPRICE)),
       MIN(O.SALEPRICE),MAX(O.SALEPRICE)
FROM ORDERS O, CUSTOMER C
WHERE O.CUSTID = C.CUSTID
 GROUP BY C.NAME
 HAVING MAX(O.SALEPRICE) >= 20000 -- 20000원 이상 책을 1권이라도 구입한 사람
--HAVING O.SALEPRICE >= 20000  이건 20000원 이상만 구매한 사람 -> 없음
;
--=============================================
--(실습) 필요시 조인(JOIN)과 GROUP BY ~ HAVING 구문을 사용해서 처리
--1. 고객이 주문한 도서의 총판매건수, 판매액, 평균값, 최저가, 최고가 구하기
--2. 고객별로 주문한 도서의 총수량, 총판매액 구하기
--3. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색
--4. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객명으로 정렬
--5. 고객별로 주문한 건수, 합계금액, 평균금액을 구하고(3권 보다 적게 구입한 사람 검색)
--(번외) 고객 중 한 권도 구입 안 한 사람은 누구??
---------------------------
--1. 고객이 주문한 도서의 총판매건수, 판매액, 평균값, 최저가, 최고가 구하기
-- (별치사용시 주의) 빈칸,특수문자 사용시 쌍따옴표("")로 묶어서 표기  , 한글 사용 자제 
SELECT COUNT(*)AS TOTAL_CNT 
      ,SUM(SALEPRICE)AS "판매액 합계" -- 한글 사용 가능하나, 사용 지양 
      ,TRUNC(AVG(SALEPRICE)) 평균값 -- AS 생략 가능
      ,MIN(SALEPRICE) 최저가_MIN -- 언더바 사용 가능 
      ,MAX(SALEPRICE) "최고가(MAX)" --특수문자 사용시 쌍따옴표("")로 묶어서 표기 
  FROM ORDERS
;
--2. 고객별로 주문한 도서의 총수량, 총판매액 구하기
SELECT C.NAME, COUNT(*),SUM(O.SALEPRICE)
  FROM ORDERS O INNER JOIN CUSTOMER C
  ON O.CUSTID = C.CUSTID
GROUP BY C.NAME
;
--3. 고객의 이름과 고객이 주문한 도서의 판매가격을 검색
SELECT C.NAME, O.SALEPRICE, O.ORDERDATE
  FROM CUSTOMER C INNER JOIN ORDERS O 
  ON C.CUSTID = O.CUSTID 
;
--4. 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객명으로 정렬
SELECT C.NAME, SUM(O.SALEPRICE)AS SUM_PRICE
  FROM CUSTOMER C INNER JOIN ORDERS O 
  ON C.CUSTID = O.CUSTID 
GROUP BY C.NAME
ORDER BY C.NAME
;
--5. 고객별로 주문한 건수, 합계금액, 평균금액을 구하고(3권 보다 적게 구입한 사람 검색)
SELECT C.NAME, COUNT(*)AS CNT, SUM(O.SALEPRICE)AS SUM_PRICE
      , TRUNC(AVG(O.SALEPRICE)) AS AVG_PRICE
  FROM CUSTOMER C INNER JOIN ORDERS O 
    ON C.CUSTID = O.CUSTID 
GROUP BY C.NAME
HAVING COUNT(*) < 3
--ORDER BY SUM(O.SALEPRICE)DESC -- 컬럼명
--ORDER BY 3 DESC -- 컬럼 위치값
ORDER BY SUM_PRICE DESC -- 컬럼 별칭 사용 
;


