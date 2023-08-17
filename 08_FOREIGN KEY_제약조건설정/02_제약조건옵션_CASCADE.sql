/* 제약조건 옵션
CASCADE : 부모테이블의 제약조건을 비활성화 시키면서
          참조하고 있는 자녀테이블의 제약조건까지 비활성화 
--------------------
ON DELETE CASCADE 
  테이블 간의 관계에서 부모테이블 데이터 삭제시 
  자녀테이블 데이터도 함께 삭제 처리
***************************/
--ORA-02297: cannot disable constraint (MADANG.SYS_C007014) - dependencies exist
-- PRIMARY KEY(NOT NULL + UNIQUE) 해지 -> 참조하고 있는 데이터 있어서 불가
-- 자녀테이블에서 참조하고 있는 상태에서는 부모테이블 PK 비활성화 불가함 
ALTER TABLE DEPT DISABLE PRIMARY KEY; 

--방법1 : 직접 자녀테이블 참조키를 모두 삭제 혹은 비활성화 후 부모테이블 비활성화

--DEPT:PK,EMP01,EMP02,EMP03 : FK 활성화


--방법2 :부모테이블 제약조건 비활성화하면서 CASCADE 옵션 사용 
ALTER TABLE DEPT DISABLE PRIMARY KEY CASCADE;

--ON DELETE CASCADE 
CREATE TABLE C_MAIN (
    MAIN_PK NUMBER PRIMARY KEY,
    MAIN_DATA VARCHAR2(30)
);

CREATE TABLE C_SUB (
    SUB_PK NUMBER PRIMARY KEY,
    SUB_DATA VARCHAR2(30),
    SUB_FK NUMBER,
    
    CONSTRAINT C_SUB_FK FOREIGN KEY (SUB_FK)
    REFERENCES C_MAIN (MAIN_PK) ON DELETE CASCADE 
);
INSERT INTO C_MAIN VALUES (1111,'1번 메인 데이터');
INSERT INTO C_MAIN VALUES (2222,'2번 메인 데이터');
INSERT INTO C_MAIN VALUES (3333,'3번 메인 데이터');

------------------
INSERT INTO C_SUB VALUES (1,'1번 SUB',1111);
INSERT INTO C_SUB VALUES (2,'2번 SUB',2222);
INSERT INTO C_SUB VALUES (3,'3번 SUB',3333);
INSERT INTO C_SUB VALUES (4,'4번 SUB',3333);
------------------
SELECT * FROM C_MAIN;
SELECT * FROM C_SUB;
----------------
-- 메인 테이블 데이터 삭제 
DELETE FROM C_MAIN WHERE MAIN_PK = 1111;
DELETE FROM C_MAIN WHERE MAIN_PK = 3333;
--============================
--부모테이블 삭제시 자녀테이블 있으면 삭제 불가, 부모 테이블 삭제 방법
--방법 1.자녀테이블 참조 제약조건을 삭제 후 부모테이블 삭제 처리
-- 방법2. CASCADE CONSTRAINTS
DROP TABLE C_MAIN; -- 참조테이블(자녀테이블) 있는 경우 삭제 안 됨
DROP TABLE C_MAIN CASCADE CONSTRAINTS;

