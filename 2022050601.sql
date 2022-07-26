PL/SQL (절차적인 언어로써의 구조화된 질의 언어)
- 버스타고 가자
Package(패키지)
User Function(사용자정의 함수)
Stored Procedure(저장 프로시저)
Trigger(트리거)
Anonymous Block(익명의 블록)

                                CURSOR(커서)
/
SET SERVEROUTPUT ON;
/
    DECLARE
        -- SCALAR(일반)변수
        V_BUY_PROD VARCHAR2(10);
        V_QTY NUMBER(10);
        CURSOR CUR IS -- 결과에 CUR라는 이름을 붙여줌 
        SELECT BUY_PROD, SUM(BUY_QTY)
        FROM    BUYPROD
       WHERE    BUY_DATE LIKE '2020%'
       GROUP BY BUY_PROD -- 같은 PROD끼리 묶어줌 
       ORDER BY BUY_PROD ASC; --정렬 ASC 오름차순  ,DESC 내림차순
       -- LIKE + % (여러글자) , LIKE + _ (한글자)
    BEGIN
       OPEN CUR; -- 메모리 할당(올라감) = 바인드
       
       --페따출 
       --페(FETCH)
       FETCH CUR INTO V_BUY_PROD, V_QTY; -- V_PROD와 V_QTY에 결과값을 넣어줌 (V_변수의 약자)
       -- FETCH 다음 행으로 넘어감(결과물에 있는 행1,행2,행3~~등), 행이 존재하는지 체킹
        (FOUND : 데이터존재? / NOTFOUND : 데이터가 없는지? /ORWCOUNT : 행의 수)
       WHILE(CUR%FOUND) LOOP --반복문
       DBMS_OUTPUT.PUT_LINE(V_BUY_PROD ||','|| V_QTY);-- 출 (출력)
       FETCH CUR INTO V_BUY_PROD, V_QTY;--따(따지고)
        END LOOP;
       CLOSE CUR;  -- 사용중인 메모리를 반환(필수)
    END;

-- 회원테이블에서 회원명과 마일리지를 출력해보자
-- 단, 직업이 '주부'인 회원만 출력하고 회원명은 오름차순 정렬해보자
-- ALIAS : MEM_NAME,MEM_MILEAGE
-- CUR이름의 CURSOR를 정의하고 익명블록으로 표현
DECLARE 
    
    V_NAME MEMBER.MEM_NAME%TYPE;--VARCHAR2(20);  MEMBER에 MEM_NAME이라는 컬럼의 타입 --REFERENCE변수 
    V_MILEAGE NUMBER(10);  --SCALAR변수
CURSOR CUR IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB LIKE '주부' --MEM_JOB = '주부'
     ORDER BY MEM_NAME ASC;
BEGIN
    OPEN CUR;
    LOOP
    FETCH CUR INTO V_NAME, V_MILEAGE;
    EXIT WHEN CUR%NOTFOUND; -- CUR의 행이 남아있는게 없으면 끝냄
    DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||V_NAME||', '||V_MILEAGE); --ROWCOUNT  행 번호.
    END LOOP;
    CLOSE CUR;
END;
/

-- 직업을 입력받아서 FOR LOOP를 이용하는 CURSOR
DECLARE 
CURSOR CUR (V_JOB VARCHAR2) IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB = V_JOB 
     ORDER BY MEM_NAME ;
BEGIN
    -- FOR문으로 반복하는 동안 커서를 자동으로 OPEN하고
    -- 모든 행이 처리되면 자동으로 커서를 CLOSE함
    -- REC : 자동선언되는 묵시적 변수
    FOR REC IN CUR('학생') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||REC.MEM_NAME||', '||REC.MEM_MILEAGE); 
    END LOOP;
END;
/

DECLARE 
CURSOR CUR (V_JOB VARCHAR2) IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB = V_JOB 
     ORDER BY MEM_NAME ;
BEGIN
    FOR REC IN CUR('학생') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||REC.MEM_NAME||', '||REC.MEM_MILEAGE); 
    END LOOP;
END;
/

CURSOR 문제
--2020년도 회원별 판매금액의(판매가(PROD_SALE)
--                         * 구매수량(CART_QTY))의 합계를
-- CURSOR와 FOR문을 통해 출력해보자
-- ALIAS : MEM_ID, MEM_NAME, SUM_AMT
-- 출력예시 : a001, 김은대, 2000
--           b001, 이쁜이, 1750
    SELECT A.MEM_ID,
           A.MEM_NAME,
           SUM(B.PROD_SALE * C.CART_QTY)
      FROM MEMBER A, PROD B, CART C
     WHERE A.MEM_ID = C.CART_MEMBER
       AND C.CART_PROD = B.PROD_ID
       AND CART_NO LIKE '2020%'
     GROUP BY A.MEM_ID, A.MEM_NAME
     ORDER BY MEM_ID;




ANSI조인
DECLARE
    CURSOR CUR IS
    SELECT A.MEM_ID,
           A.MEM_NAME,
           SUM(B.PROD_SALE * C.CART_QTY) OUT_AMT --OUT_AMT 판매된 것
      FROM PROD B INNER JOIN CART C   ON(C.CART_PROD = B.PROD_ID)
                  INNER JOIN MEMBER A ON(A.MEM_ID = C.CART_MEMBER)
     WHERE CART_NO LIKE '2020%'
     GROUP BY A.MEM_ID, A.MEM_NAME
     ORDER BY MEM_ID;
BEGIN
    FOR REC IN CUR LOOP
    IF MOD(CUR%ROWCOUNT,2) !=0 THEN    --짝수만 뽑기
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||
                             REC.MEM_ID || ','||
                             REC.MEM_NAME||','|| 
                             REC.OUT_AMT);
    END IF;
    END LOOP;

END;



