2022-05-11)
<학습목표>
1. Procedure(프로시저) + SCHEDULER(스케줄러)
2. Exception
3. Trigger

/*
오라클 스케줄러 사용하기!
스케줄러?
    - 특정한 시간이 되면 자동적으로 질의(query) 명령이 실행되도록 하는 방법
*/
/
SELECT MEM_ID, MEM_MILEAGE
  FROM MEMBER
 WHERE MEM_ID = 'a001';
/
EXEC USP_UP_MEMBER_MIL;
/
CREATE OR REPLACE PROCEDURE USP_UP_MEMBER_MIL
IS
BEGIN

UPDATE MEMBER
   SET MEM_MILEAGE = MEM_MILEAGE +10
 WHERE MEM_ID = 'a001';
 
 COMMIT;
END;
/
-- 스케줄 생성
DECLARE
    -- 스케줄 JOB 고유 아이디. 임의의 숫자
    V_JOB NUMBER(5);
BEGIN
    DBMS_JOB.SUBMIT(
        V_JOB,               -- JOB 아이디
        'USP_UP_MEMBER_MIL;', -- 실행할 프로시저 작업
        SYSDATE,              -- 최초 작업을 실행할 시간
        'SYSDATE + (1/1440)', -- 1분마다
        FALSE                -- 파싱(구문분석, 의미분석)여부
    );
    DBMS_OUTPUT.PUT_LINE('JOB IS ' || TO_CHAR(V_JOB));
    COMMIT;
END;
/
-- 스케줄러에 등록된 작업을 조회
SELECT * FROM USER_JOBS;
/
-- 스케줄러에서 등록된 작업 삭제
BEGIN
    DBMS_JOB.REMOVE();  -- 괄호안에 조회결과 중 지우고 싶은 JOB번호를 적어준다.
END;
/
SELECT SYSDATE,
       TO_CHAR(SYSDATE + (1/1440),'YYYY-MM-DD HH24:MI:SS'), -- 1분뒤
       TO_CHAR(SYSDATE + (1/24),'YYYY-MM-DD HH24:MI:SS'),   -- 1시간뒤
       TO_CHAR(SYSDATE + 1,'YYYY-MM-DD HH24:MI:SS')         -- 1일뒤
  FROM DUAL;
/
/*
EXCEPTION
    - PL/SQL에서 ERROR가 발생하면 EXCEPTION이 발생되고
      해당블록을 중지하며 예외처리부분으로 이동함
    (예외 유형)
    - 정의된 예외
        PL/SQL에서 자주 발생하는 ERROR를 미리 정의함
        선언할 필요가 없고 서버에서 암시적으로 발생함
        1) NO_DATE_FOUND : 결과없음
        2) TOO_MANY_ROWS : 여러행 리턴
        3) DUP_VAR_ON_INDEX : 데이터 중복 오류(P.K / U.K)
        4) VALUE_ERROR : 값 할당 및 변환 시 오류
        5) INVALID_NUMBER : 숫자로 변환이 안됨 EX) TO_NUMBER('개똥이')
        6) HOT_LOGGED_ON : DB에 접속이 안되었는데 실행
        7) LOGIN_DENIED : 잘못된 사용자 / 잘못된 비밀번호
        8) ZERO_DIVIDE : 0으로 나눔
        9) INVALID_CURSOR : 열리지 않은 커서에 접근
        
    - 정의되지 않은 예외
        기타 표준 ERROR
        선언을 해야 하며 서버에서 암시적으로 발생
        
    - 사용자 정의 예외
        프로그래머가 정한 조건에 만족하지 않을 경우 발생
        선언을 해야 하고, 명시적으로 RAISE문을 사용하여 발생
*/
/
SET SERVEROUT ON;
/
-- 정의된 예외
-- 1. 
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME 에 '여성캐주얼' 이 할당됨
    SELECT LPROD_NM INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P201'; 
     DBMS_OUTPUT.PUT_LINE('분류명 : ' || V_NAME);
     -- 해결법
     EXCEPTION
          WHEN NO_DATA_FOUND THEN --. ORA-01403 (오류 보고 해결)
               DBMS_OUTPUT.PUT_LINE('해당 정보가 없습니다.');
          
END;
/
-- 2. LPROD_GU = 'P20%';
/
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME 에 '여성캐주얼' 이 할당됨
    SELECT LPROD_NM INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P20%'; 
     DBMS_OUTPUT.PUT_LINE('분류명 : ' || V_NAME);
     -- 해결법
     EXCEPTION
          WHEN TOO_MANY_ROWS THEN  --ORA-01422
               DBMS_OUTPUT.PUT_LINE('한개 이상의 값이 나왔습니다.');
END;
/
-- 3. LPROD_NM+10
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME 에 '여성캐주얼' 이 할당됨
    SELECT LPROD_NM+10 INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P201'; 
     DBMS_OUTPUT.PUT_LINE('분류명 : ' || V_NAME);
     -- 해결법
     EXCEPTION
          WHEN NO_DATA_FOUND THEN --. ORA-01403 (오류 보고 해결)
               DBMS_OUTPUT.PUT_LINE('해당 정보가 없습니다.');
          WHEN TOO_MANY_ROWS THEN  --ORA-01422
               DBMS_OUTPUT.PUT_LINE('한개 이상의 값이 나왔습니다.');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('기타 에러 : ' || SQLERRM);
END;
/

-- 정의되지 않은 예외
/
DECLARE
    -- excetion 타입의 exp_reference 변수 선언
    exp_reference EXCEPTION; --1
    -- EXCEPTION_INIT을 통해 예외이름과 오류번호를 컴파일러에게 등록함
    PRAGMA EXCEPTION_INIT(exp_reference, -2292); --1
BEGIN
    -- ORA-02292 오류 발생 -- 해결방법(1)
    DELETE FROM LPROD WHERE LPROD_GU = 'P101';
    DBMS_OUTPUT.PUT_LINE('분류 삭제');
    EXCEPTION --1
        WHEN exp_reference THEN--1
             DBMS_OUTPUT.PUT_LINE('삭제 불가');--1
END;
/
SELECT *
  FROM USER_CONSTRAINTS
 WHERE CONSTRAINT_NAME ='FR_BUYER_LGU';
 /
 
    -- 사용자 정의 예외
ACCEPT p_lgu PROMPT '등록하려는 분류코드 입력: '
DECLARE
    -- exception 타입의 변수 선언
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); --p_lgu에서 UPPER 대문자로 반환되고 v_lgu에 저장
BEGIN
    IF v_lgu IN('P101','P102','P201','P202') THEN
    -- 실행부에서 RAISE문장으로 명시적으로 EXCEPTION을 발생함
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_LGU || '는 등록가능');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(v_lgu || '는 이미 등록된 코드입니다.');
END;
/

SELECT LPROD_GU FROM LPROD;

/

-- DEPARTMENT 테이블에 학과코드를 '컴공',
-- 학과명을 '컴퓨터공학과', 전화번호를 '765-4100'
-- 으로 INSERT
/
DECLARE
BEGIN
    INSERT INTO DEPARTMENT(DEPT_ID,DEPT_NAME,DEPT_TEL)
    VALUES('컴공','컴퓨터공학과','765-4100');
    COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             DBMS_OUTPUT.PUT_LINE('중복된 인덱스 예외 발생!');
        WHEN OTHERS THEN
            NULL;
END;
/

SELECT *FROM USER_CONSTRAINTS
 WHERE CONSTRAINT_NAME ='DEPARTMENT_PK';
 /
/*
COURSE 테이블의 과목코드가 'L1031'에 대하여
추가 수강료(COURSE_FEES)를 '삼만원;으로 수정해보자
[숫자형 데이터타입의 데이터 오류 발생]
*/
/
DECLARE
BEGIN
UPDATE COURSE
   SET COURSE_FEES ='삼만원'
 WHERE COURSE_ID ='L1031';
    COMMIT;
    EXCEPTION
        WHEN INVALID_NUMBER THEN
            DBMS_OUTPUT.PUT_LINE('잘못된 숫자 예외 발생!');
        WHEN OTHERS THEN
        NULL;
END;
/
/*
SG_SCORES 테이블에 저장된 SCORE 컬럼의 점수가
100점이 초과되는 값이 있는지 조사하는 블록을 작성해보자
단, 100점 초과 시 OVER_SCORE 예외를 선언해보자
[사용자정의 예외로 처리해보자]
*/
INSERT INTO SG_SCORES(STUDENT_ID,COURSE_ID,SCORE,SCORE_ASSIGNED)
VALUES('A1701','L0013',107,'2010/12/29');
COMMIT;
/
DECLARE
    OVER_SCORE EXCEPTION;
    V_SCORE SG_SCORES.SCORE%TYPE;
BEGIN
    -- 반복문을 사용하여 SCORE가 100을 초과하면
    -- 그 SCORE값을 V_SCORE 변수에 넣고
    -- RAISE OVER SCORE;를 수행함
    -- [예외메세지 : 107점으로 100점을 초과합니다]
    IF SCORE >100 THEN
    V_SCORE NUMBER  := SCORE;
     RAISE VALUE_ERROR SCORE;
    END IF;
        EXCEPTION
        WHEN  VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE(V_SCORE || '는 107점으로 100점을 초과합니다.');
    
END;
/