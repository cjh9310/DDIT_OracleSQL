2022-0412-01) 연산자
1. 연산자의 종류
 - 산술연산자, 논리연산자, 관계연산자, 기타연산자 
 
    1) 산술연산자
    . 사칙연산자(+,-,/,*)

사용예) 사원테이블 (HR계정의 EMPLOYEES)에서 사원들의 지급액을 계산하여
        출력하시오.
        보너스 = 급여(SAYLARY)의 30%
        지급액 = 급여 + 보너스
        Alias는 사원번호, 사원명,급여,보너스,지급액이며
        지급액이 많은 직원부터 출력하시오.
  
        
SELECT  EMPLOYEE_ID AS 사원번호,
        FIRST_NAME || ' ' || LAST_NAME AS 사원명,
        SALARY AS 급여,
        ROUND(SALARY*0.3) AS  보너스, -- ROUND() 소수점 지울때
        SALARY + ROUND(SALARY*0.3) AS 지급액 
    FROM HR.employees  -- 다른 곳에서 가져올때 계정명.컬럼명 입력
  ORDER BY 5 DESC --SALARY + ROUND(SALARY*0.3)가 SELECT기준 5번째 위치해 있어서 간단하게 활용
  
사용예) 매입테이블(BUYPROD)에서 2020년 2월 일자별 매입집계를 조회하시오.
        Alias는 일자, 매입수량합계, 매입금액합계이며 일자순으로 출력하시오.
        
        SELECT BUY_DATE AS 일자,
               SUM(BUY_QTY) AS 매일수량합계,
               SUM(BUY_QTY*BUY_COST) AS 매일금액합계
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND
               LAST_DAY(TO_DATE('20200201'))
               GROUP BY BUY_DATE
               ORDER BY 1;
        
        
        
        
        
        
        
        SELECT BUY_DATE AS 일자,
            SUM(BUY_QTY) AS 매입수량합계,
            SUM(BUY_QTY*BUY_COST) AS 매입금액합계
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND
            LAST_DAY(TO_DATE('20200201')) -- (월에 마지막 날...) 20200201의 LAST_DAY -> 2020년 2월 마지막날까지
        GROUP BY BUY_DATE
        ORDER BY 1;

        SELECT 12323*435234323/1234542
            FROM DUAL;
    
    2) 관계연산자
    . 조건식을 구성할때 사용됨
    . 데이터의 대소관계를 판단하며 결과는 true,false이다.
    . >,<,>=,<=,=,!=(<>)  -- 크다와 작다가 같이 쓰일 수 없다?  ex) ><
    -- In연산자에는 쓸 수 없지만 or,any,some등의 연산자에는 쓸 수 있다.
    . WHERE 절의 조건식과 표현식(CASE WHEN THEN)의 조건식에 사용
    
사용예) 상품테이블(PROD)에서 판매가(PROD_PRICE)가 200000만원 이상인 상품을 --WHERE절 필요
        조회하시오.
        Alias는 상품코드, 상품명, 매입가격, 판매가격이며 
        --cost 매입단가./ price 판매가격 
        상품코드순으로 출력할 것.
        SELECT PROD_ID AS 상품코드,
             PROD_NAME AS 상품명,
             PROD_COST AS 매입가격,
             PROD_PRICE AS 판매가격
        FROM PROD
        WHERE PROD_PRICE>=200000
        ORDER BY 1;
        
        
        
        
사용예) 회원테이블(MEMBER)에서 마일리지가 5000이상인 회원정보를 조회하시오.
        Alias는 회원번호, 회원명, 마일리지, 구분이며 '구분'난에는 '여성회원'
        또는 '남성회원'을 출력할 것.
       
            
        SELECT MEM_ID AS 회원번호,
             MEM_NAME AS 회원명,
             MEM_MILEAGE AS 마일리지,
             
            CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                      SUBSTR(MEM_REGNO2,1,1)='3' THEN
                      '남성회원'
                ELSE  -- 조건식의 결과는 참 거짓 중에 하나?
                      '여성회원'
            END AS  구분
            FROM MEMBER
        WHERE MEM_MILEAGE>=5000;
    
    3) 논리연산자
        - 두 개이상의 조건식의 평가(AND,OR)나 또는 특정 조건식의 부정(NOT)의 
            결과를 반환  --not : 반대되는 연산자 ( 그 것의 반대?)
        - 진리표   -- AND,OR 두 개의 연산자 필요/ NOT 하나의 연산자만 있으면 된다.
----------------------------------------
        입력값          출력값
    X       Y        AND     OR
----------------------------------------
    0       0         0       0
    0       1         0       1              -- 1이 실행.
    1       0         0       1
    1       1         1       1
    
- 연산순서는 NOT->AND->OR

사용예) 회원테이블에서 회원의 출생년도를 추출하여 윤년과 평년을 구별하여 출력하시오.
        Alias는 회원번호,회원이름,출생년월일,비고
        ** 윤년 = 4의배수이며 100의배수가 아니거나 400의 배수가 되는 해
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원이름,
               MEM_REGNO1 AS 출생년월일,                           -- MOD : 나머지를 구하는 함수
               CASE WHEN (MOD(EXTRACT(YEAR FROM MEM_BIR),4)=0 AND -- EXTRACT : 추출할 수 있는 함수.
                         MOD(EXTRACT(YEAR FROM MEM_BIR),100)!=0) OR
                         MOD(EXTRACT(YEAR FROM MEM_BIR),400)=0 THEN
                         '윤년'
                         ELSE
                         '평년'
          END AS 비고
          FROM MEMBER
          
    ** 사원테이블에 EMP_NAME varchar2(80)컬럼을 추가하고 FIRST_NAME과 LAST_NAME을 
       결합하여 EMP_NAME에 저장하세요.
       1) 컬럼을 추가
          ALTER TABLE HR.employees
          ADD EMP_NAME varchar2(80);
          UPDATE HR.employees
          -- 이미 저장되어 있는거라 INSERT가 아니라 업데이트로 불러오기
             SET EMP_NAME=FIRST_NAME||' '||LAST_NAME;
             COMMIT;
             SELECT * FROM HR.employees
사용예) 사원테이블에서 10부서에서 50번부서에 속한 사원정보를 조회하시오.
        Alias는 사원번호,사원명,부서번호,입사일,직책코드이며
        부서번호순으로 출력하시오.

        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               DEPARTMENT_ID AS 부서번호,
               HIRE_DATE AS 입사일,
               JOB_ID AS 직책코드
          FROM HR.employees
         WHERE 10<=DEPARTMENT_ID AND DEPARTMENT_ID<=50    --범위 연산자 AND 혹은 BETWEEN 사용
         -- 아니면 WHERE DEPARTMENT_ID BETWENN 10 AND 50 으로 써도 
         ORDER BY 3;   -- DEPARTMENT_ID AS 부서번호,  3번째줄에 있음

사용예) 장바구니테이블에서 2020년 6월 제품별 판매수량집계와 판매금액 집계를 조회하시오.
       출력은 제품코드, 제품명, 판매수량합계, 판매금액합계이며 
       판매금액이 많은 순부터 차례대로 출력하세요.
        --SELECT 제품코드, 제품명, 판매수량합계, 판매금액합계 -- SELECT는 마지막에 생성됨.
          --FROM CART A, --테이블에 붙여진 별칭 CART를 A라고도 사용하겠다.
          --  실행하면 FROM절이 젤 빨리 실행됨. 고로 FROM은 다른 곳에 실행할 수 있음.
        SELECT A.CART_PROD AS 제품코드, 
               B.PROD_NAME AS 제품명, 
               SUM(A.CART_QTY) AS 판매수량합계, 
               SUM(A.CART_QTY*B.PROD_PRICE) AS 판매금액합계 
          FROM CART A,PROD B
         WHERE A.CART_PROD=B.PROD_ID
           AND /*1번 SUBSTR(A.CART_NO,1,8)>='20200601' AND
                 SUBSTR(A.CART_NO,1,8)>='20200630' */
                 --2번 SUBSTR(A.CART_NO,1,6) = '203006'
                 /*3번*/ A.CART_NO LIKE '202006%'
         GROUP BY A.CART_PROD,B.PROD_NAME
         ORDER BY 4 DESC;
-- 절대 까먹지 말 것. SUM AVG C.OUNT MAX MIN

 