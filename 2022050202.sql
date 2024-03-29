2022-0502-02) SEQUENCE
    - 연속적으로 증가(또는 감소) 되는 값을 반환하는 객체
    - 특정 테이블에 종속되지 않음
    - 기본키로 설정할 특정 항목이 없는 경우 주로 사용
    
    - 
(사용형식)
    CREATE SEQUENCE 시퀀스명
    [START WITH n] -- n부터 생성  ,시작값 생략되어지면 초기값이 들어감 (초기값도 생략되면 1이 들어간다.)
    [INCREMENT BY n] -- 증가 감소값(n)
    [MAXVALUE n|NOMAXVALUE] -- 최종값 설정, 기본은 NOMAXVALUE이며 10^27
    [MINVALUE n|NOMINVALUE] -- 최소값 설정, 기본은 NOMINVALUE이며 값은 1 임
    [CYCLE|NOCYCLE] : -- 최종/최소 값까지 도달한 후 다시 생성할지 여부(기본은 CYCLE)
    [CACHE n|NOCACHE] : -- 생성된 순서값을 캐쉬메모리에 저장할 것인지 여부
                        -- 기본은 CACHE 20 
    [ORDER | NOORDER] : --정의된대로 생성의 보장여부 기본은 NOORDER  ,명령
    
    
*시퀸스 사용이 제한되는 곳
    . SELECT, UPDATE, DELETE 문의 SUBQUERY
    . VIEW를 대상으로하는 QUERY
    . DISTINCT가 사용된 SELECT문
    . GROUP BY, ORDER BY절이 사용된 SELECT문
    . 집합연산자에 사용된 SELECT문
    . SELECT문의 WHERE 절
    
* 시퀀스에 사용되는 의사컬럼
    시퀀스명.CURRVAL : 시퀀스객체의 현재값
    시퀀스명.NEXTVAL : 시퀀스객체의 다음값
*시퀀스가 생성되고 첫 번째 수행해야할 명령은 반드시 NEXTVAL 가 되어야 함.

    -- SEQUENCE가 삭제될 필요가 있으면 DROP SEQUENCE 시퀀스명
사용예)분류테이블에 사용할 시퀀스를 생성하시오.
      시작값은 10이고 1씩 증가해야함
    CREATE SEQUENCE SEQ_LPROD  -- 생성기
     START WITH 10;
    
    SELECT SEQ_LPROD.NEXTVAL FROM DUAL; -- 10으로 시작함. (되돌아갈 수 없다. 해결방법 : 삭제 후 스타트)
    SELECT SEQ_LPROD.CURRVAL FROM DUAL;

    DROP SEQUENCE SEQ_LPROD  -- 삭제

사용예) 다음자료를 분류테이블에 저장하시오
    [자료]
    LPROD_ID       LPROD_GU       LRPOD_NM
    --------------------------------------
    시퀀스사용        P501          농산물
    시퀀스사용        P502          수산물
    시퀀스사용        P503          임산물
    
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P501','농산물');
    
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P502','수산물');
        
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P503','임산물');
        
        
3. SYNONYM(동의어)
    - 오라클에서 사용되는 객체에 부여한 또 다른 이름
    - 긴 객체명이나 사용하기 어려운 객체명을 사용하기 쉽고 기억하기 쉬운
      이름으로 사용

(사용형식)
    CREATE OR REPLACE SYNONYM 별칭 FOR 객체명;
        .'객체명'을 '별칭'으로 또 다른 이름 부여

사용예) HR계정의 사원테이블과 부서테이블을 EMP, DEPT로 별칭(동의어)을 부여하시오
    CREATE OR REPLACE SYNONYM EMP FOR HR.employees;
    CREATE OR REPLACE SYNONYM DEMP FOR HR.departments; 
    SELECT * FROM EMP;


 3. INDEX
 - 테이블에 저장된 자료를 효율적으로 검색하기 위한 기술
 - 오라클서버는 사용자로부터 검색명령이 입력되면 전체를 대상으로 검색(FULL SCAN)을 할 지
   또는 인덱스 스캔(INDEX SCAN)을 할 지를 결정함
 - 인덱스가 필요한 컬럼
   . 자주 검색하는 컬럼
   . WHERE 절에서 '='연산자로 특정 자료를 검색하는 경우
   . 기본키 --자동으로 INDEX됨
   . SORT(ORDER BY)나 JOIN연산에 자주 사용되는 컬럼
 - 인덱스의 종류
   . Unique / Non-Unique
   . Single / Composite
   . Normal / Bitmap / Function-Based
   
 (사용형식)
 CREATE [UNIQUE|BITMAP] INDEX 인덱스명
   ON 테이블(컬럼명[,컬럼명,...] [ASC|DESC]);
  . 'ASC|DESC' : 오름차순 또는 내림차순으로 인덱스 생성, 기본은 ASC
  
 사용예)
 CREATE INDEX IDX_MEM_NAME
  ON MEMBER(MEM_NAME);
  
 SELECT *FROM MEMBER
  WHERE MEM_NAME='육평회';
  
 DROP INDEX IDX_MEM_NAME;
 
 사용예)
 CREATE INDEX IDX_PROD
   ON PROD(SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9));-- 9글자부터 끝까지.
   
 SELECT * FROM PROD
  WHERE SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9)='P202013'
  -- 기존은 P202000013 이지만 1~5, 9~나머지 자리만 적어두면 연속으로 적어둔다.
 ** 인덱스 재구성
  - 인덱스를 다른 테이블스페이스로 이동시키는 경우
  - 데이터테이블이 이동된 경우
  - 삽입 삭제가 다수 발생된 직후
  ALTER 인덱스명 REBUILD;

 
 
