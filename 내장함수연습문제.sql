--내장 함수 연습문제 
SELECT ABS(-15) FROM DUAL; -- 15 : 절대값 반환
SELECT CEIL(15.7)FROM DUAL; -- 16 : 큰 숫자
SELECT COS(3.14159) FROM DUAL; 
SELECT FLOOR(15.7) FROM DUAL; -- 15 : 작은 숫자
SELECT LOG(10,100) FROM DUAL; -- 2 : 10을 몇 번 제곱하면 100이 되는지 
SELECT MOD (11,4) FROM DUAL; -- 3 : 나머지값
SELECT POWER(3,2) FROM DUAL; -- 9 : 3의 2제곱
SELECT ROUND(15.7) FROM DUAL; -- 16 :  반올림
SELECT SIGN(-15) FROM DUAL; -- 부호값 반환 : 음수 -1
SELECT TRUNC(15.7) FROM DUAL; -- 15: 정수만 남기고 소수부 버림
SELECT CHR(67) FROM DUAL; -- C : 아스키코드에 해당하는 문자 

SELECT CONCAT('HAPPY','BIRTHDAY')FROM DUAL; -- HAPPYBIRTHDAY : 문자열 연결
SELECT LOWER('BIRTHDAY')FROM DUAL; -- birthday : 소문자 변경
SELECT LPAD('PAGE 1',15,'*.')FROM DUAL;-- *.*.*.*.*PAGE 1 : 삽입될 문자를 왼쪽에 삽입
SELECT LTRIM ('Page 1','ae') FROM DUAL;
SELECT REPLACE ('JACK','J','BL')FROM DUAL; -- BLACK : J를 BL 로 변경
SELECT RPAD ('Page 1',15,'*.')FROM DUAL; -- Page 1*.*.*.*.* : 삽입될 문자를 오른쪽에 삽입
SELECT SUBSTR('ABCDEFG',3,4)FROM DUAL; -- CDEF : 3번째부터 4개 
SELECT TRIM(LEADING 0 FROM '00AA00')FROM DUAL;
-- AA00 : LEADING 문자열 왼쪽에서 지정한 문자나 공백 제거 
SELECT UPPER('Birthday') FROM DUAL; -- BIRTHDAY : 대문자 변경
SELECT ASCII('A') FROM DUAL; -- 65 : 아스키코드 해당 번호 
SELECT INSTR('CORPORATE FLOOR','OR',3,2) FROM DUAL;
-- 14 : 3번째부터 시작해서 nth번째로 찾은 위치값
SELECT LENGTH('Birthday') FROM DUAL; -- 8 : 문자열길이
SELECT ADD_MONTHS('14/05/21',1) FROM DUAL;-- 0014/06/21 : +1개월
SELECT LAST_DAY(SYSDATE) FROM DUAL; -- 2023/08/31 : 현재 날짜가 속한 달의 마지막 날짜
SELECT NEXT_DAY(SYSDATE,'화') FROM DUAL; -- 2023/08/15 : 다음 번에 있는 화요일
SELECT ROUND(SYSDATE) FROM DUAL; -- 2023/08/10 :
SELECT SYSDATE FROM DUAL; -- 2023/08/09
SELECT TO_CHAR (SYSDATE) FROM DUAL; -- 2023/08/09 : 날짜 -> 문자 
SELECT TO_CHAR (123) FROM DUAL; -- 123 : 날짜 -> 문자
SELECT TO_DATE('12 05 2014', 'DD MM YYYY') FROM DUAL; -- 2014/05/12 : 문자 -> 날짜 
SELECT TO_NUMBER('12.3') FROM DUAL; -- 12.3 : 문자 -> 날짜 
SELECT DECODE(1,1,'aa','bb')FROM DUAL; 
-- aa : 첫번째 두번째 같으면 세번째, 다르면 네번째 리턴
SELECT NULLIF(123, 345) FROM DUAL; 
-- 123 : 두 개의 인수 값이 같으면 NULL, 다르면 첫번째 인수값 리턴
