   (4)기타연산자
        1. IN 연산자
         - ★불연속적이거나 규칙성이 없는 자료를 비교할 때 사용
         - OR연산자, =ANY, =SOME연산자로 변환가능 --ANY 와 SOME은 거의 유사하다.
         - IN 연산자에는 '=' 기능이 내포됨
         (사용형식)
         expr IN(값1, 값2, ...값n)    
         - 'expr'(수식)을 평가한 결과가 '값1' ~ '값n' 중 
            어느 하나와 일치하면 전체가 참(true)을 반환

(사용예) 사원테이블에서 20번, 70번, 90번, 110번 부서에 근무하는 
        사원을 조회하시오.
        Alias는 사원번호, 사원명, 부서번호, 급여이다.
(OR 연산자 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호,
           SALARY AS 급여
      FROM HR.employees
     WHERE DEPARTMENT_ID = 20
        OR DEPARTMENT_ID = 70
        OR DEPARTMENT_ID = 90
        OR DEPARTMENT_ID = 110;
     
(IN 연산자 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호,
           SALARY AS 급여
      FROM HR.employees
     WHERE DEPARTMENT_ID = IN(20,70,90,110);
     
(=ANY(=SOME) 연산자 사용)
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서번호,
           SALARY AS 급여
      FROM HR.employees
     WHERE DEPARTMENT_ID = ANY(20,70,90,110);
   --  WHERE DEPARTMENT_ID = SOME(20,70,90,110);
   
        (2) ANY, SOME 연산자
            - 등호(=)의 기능이 포함되지 않은 IN연산자와 같은 기능 수행
        (사용형식)
        expr 관계연산자 ANY(SOME) (값1,...값n)
사용예)  회원테이블에서 직업이 공무원인 회원들의 마일리지보다 많은 마일리지를
        보유한 회원들을 조회하시오.
        Alias는 회원번호,회원명,직업,마일리지
        1) 직업이 공무원인 회원의 마일리지 구하기.
        SELECT MEM_MILEAGE 
        FROM MEMBER
        WHERE MEM_JOB='공무원';
        
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_MILEAGE < ANY(1700,900,2200,3200)
        ORDER BY 4;
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_MILEAGE > ANY(SELECT MEM_MILEAGE 
                                   FROM MEMBER
                                  WHERE MEM_JOB='공무원')
        ORDER BY 4;
        
        
        (3)ALL 연산자
            -ALL다음에 기술된 값들 모두를 만족시킬때만 조건이 참(true)을 반환
        (사용형식)
        expr 관계연산자 ALL(값1,...값n)
   
(사용예) 회원테이블에서 직업이 공무원인 회원 중 가장 많은 마일리지를 보유한 회원보다
        더 많은 마일리지를 보유한 학생을 조회하시오.
        Alias는 회원번호,회원명,직업,마일리지
        
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_MILEAGE >ALL(SELECT MEM_MILEAGE         -- <- 서브쿼리
                                  FROM MEMBER              -- <- 서브쿼리
                                 WHERE MEM_JOB= '공무원')   -- <- 서브쿼리
         ORDER BY 4;

        (4) BETWEEN  
          - 제시된 자료의 범위를 지정할때 사용
          - AND 연산자와 같은 기능
          - 모든 데이터 타입에 사용 가능
        (사용형식)
        expr BETWEEN 하한값 AND 상한값
        . '하한값'과 '상한값'의 타입은 동일해야 함
(사용예) 상품테이블에서 매입가격이 100000만원~200000원 사이의 상품을 조회하시오.
        Alias는 상품코드,상품명,매입가,매출가이며, 매입가순으로 출력해라.
        SELECT PROD_ID AS 상품코드,
               PROD_NAME AS 상품명,
               PROD_COST AS 매입가,
               PROD_PRICE AS 매출가
          FROM PROD
         WHERE PROD_COST >=100000 AND PROD_COST<= 200000
         ORDER BY 3;
(BETWEEN)
         SELECT PROD_ID AS 상품코드,
               PROD_NAME AS 상품명,
               PROD_COST AS 매입가,
               PROD_PRICE AS 매출가
          FROM PROD
         WHERE PROD_COST BETWEEN 100000 AND 200000
         ORDER BY 3;
(사용예) 사원테이블에서 2006년~2007년사이에 입사한 사원들을 조회하시오.
       
        Alias는 사원번호,사원명,입사일,부서코드이며 입사일 순으로 출력
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명,
               HIRE_DATE AS 입사일,
               DEPARTMENT_ID AS 부서코드
          FROM HR.employees
         WHERE HIRE_DATE BETWEEN TO_DATE('20060101') AND TO_DATE('20071231')
         ORDER BY 3;
(사용예) 상품의 분류코득'P101'번대('P100'-'P999')인 상품을 거래하는 
        거래처정보를 조회하시오.
        Alias는 거래처코드,거래처명,주소,분류코드
        SELECT BUYER_ID AS 거래처코드,
               BUYER_NAME AS 거래처명,
               BUYER_ADD1||' '||BUYER_ADD2 AS 주소,
               BUYER_LGU AS 분류코드
        FROM BUYER
        WHERE BUYER_LGU BETWEEN 'P100' AND 'P199'
        ORDER BY 4;
   
        (5) LIKE 연산자 ★(문자열만을 비교할때 쓰는 연산자)★
            - 패턴을 비교하는 연산자
            - 와일드카드(패턴비교문자열) : '%' 와 '_'이 사용되어 패턴을 구성함
        (사용형식)
        expr LIKE '패턴문자열' 
        1) '%' : '%'이 사용된 위치에서 이후의 모든 문자열을 허용
        EX) SNAME LIKE '김%' => SNAME의 값이 '김'으로 시작하는 모든 값과 대응됨
            SNAME LIKE '%김%' => SNAME의 값 중에 '김'이 있는 모든 값과 대응됨
            SNAME LIKE '%김' => SNAME의 값 중에 '김'으로 끝나는 모든 값과 대응됨
        2) '_' : '_'이 사용된 위치에서 이후의 모든 문자열을 허용
        EX) SNAME LIKE '김_' => SNAME의 값이 2글자이며 '김'으로 시작하고 
                                                       문자열과 대응됨
            SNAME LIKE '_김_' => SNAME의 값 중에 3글자로 구성된 값 중 
                             중간에 글자가 '김'이 있는 데이터와 대응됨
            SNAME LIKE '_김' => SNAME의 값 중 2글자이며 '김'으로 끝나는 문자열과 대응됨   
            
사용예) 장바구니테이블(CART)에서 2020년 6월에 판매된 자료를 조회하시오
       Alias는 판매일자,상품코드,판매수량이며 판매일 순으로 출력하시오.
       SELECT SUBSTR(CART_NO,1,8) AS 판매일자,
              CART_PROD AS 상품코드,
              CART_QTY AS 판매수량
         FROM CART
        WHERE CART_NO LIKE '202006%'
        ORDER BY 1;
사용예) 매입테이블(BUYPROD)에서 2020년 6월에 매입한 자료를 조회하시오.
       Alias는 구매일자,상품코드,구매수량(QTY),구매금액이며 구매일 순으로 출력하시오.
        SELECT BUY_DATE AS 구매일자,
               BUY_PROD AS 상품코드,
               BUY_QTY AS 구매수량,
               BUY_QTY*BUY_COST AS 구매금액
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
         ORDER BY 1;
사용예)회원테이블에서 충남에 거주하는 회원을 조회하시오.
       Alias는 회원번호,회원명,주소,마일리지
       SELECT  MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,     
               MEM_ADD1||' '||MEM_ADD2 AS 주소,
               MEM_MLEAGE AS 마일리지
         WHERE MEM_ADD1 LIKE '충남%'
         ORDER BY 1;
            
            
            
            
            
            
            
            
            
            
    