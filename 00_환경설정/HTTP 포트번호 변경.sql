-- SQL 에서 한 줄 주석 부호(--)
-- HTTP 포트 변경 : 8080 -> 8090
SELECT DBMS_XDB.getHttpPort()FROM dual; 
SELECT DBMS_XDB.getHttpPort()FROM DUAL;

-- HTTP 포트 8090으로 변경
exec dbms_xdb.setHttpPort(8090);

SELECT DBMS_XDB.getHttpPort()FROM DUAL;