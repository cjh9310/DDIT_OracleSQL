2022-0419-01) 집계함수
    - 자료를 그룹화하고 그룹내에서 합계,자료수,평균,최대,최소 값을 구하는 함수
    - SUM, AVG, COUNT, MAX, MIN 이 제공돔
    - SELECT 절에 그룹함수가 일반 컬럼과 같이 사용된경우 반드시 GROUP BY 절이 
    기술되어야 함.
    (사용형식)
    SELECT 컬럼명1, 
           [컬럼명2,.....]
           집계함수
      FROM 테이블명
    [WHERE 조건]
    [GROUP BY 컬럼명1[, 컬럼명2,...]] -- 집계함수를 제외한 모든 일반컬럼은 GROUP BY에 기수해줘야함.
   [HAVING 조건]
    [ORDER BY 인덱스 | 컬럼명 [ASC|DESC][,...]]
        - GROUP BY절에 사용된 컬럼명은 왼쪽에 기술된 순서대로 대분류, 소분류의 기준 컬럼명    
        - HAVING 조건 : 집계함수에 조건이 부여된 경우

    1. SUM(co1)
        - 각 그룹내의 'co1'컬럼에 저장된 값을 모두 합하여 반환
    2. AVG(co1) --ROUND(AVG(co1))로 소수점 제거
        - 각 그룹내의 'co1'컬럼에 저장된 값의 평균을 구하여 반환
    3. COUNT(*|co1)
        - 각 그룹내의 행의 수를 반환
        - '*'를 사용하면 NULL값도 하나의 행으로 취급
        - 컬럼명을 기술하면 해당 컬럼의 값이 NULL이아닌 갯수를 반환
    4. MAX(co1), MIN(co1)
        - 각 그룹내의 'co1'컬럼에 저장된 값 중 최대값과 최소값을 구하여 반환
     *** 집계함수는 다른 집계함수를 포함할 수 없다 ***
사용예) 사원테이블에서 전체사원의 급여합계를 구하시오
사용예) 사원테이블에서 전체사원의 평균급여를 구하시오 
    SELECT SUM(SALARY) AS 급여합계,
           ROUND(AVG(SALARY)) AS 평균급여,
           MAX(SALARY) AS 최대급여,
           MIN(SALARY) AS 최소급여,
           COUNT(*) AS 사원수
      FROM HR.employees;
      
    SELECT AVG(TO_NUMBER(SUBSTR(PROD_ID,2,3)))
    FROM PROD;

사용예) 사원테이블에서 부서별 급여합계를 구하시오.
    SELECT DEPARTMENT_ID AS 부서별, 
           SUM(SALARY) AS 급여합계,
           ROUND(AVG(SALARY)) AS 평균급여,
           COUNT(EMPLOYEE_ID) AS 사원수,
           MAX(SALARY) AS 최대급여
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
     ORDER BY 1;
       
사용예) 사원테이블에서 부서별 평균급여가 6000이상인 부서를 조회하시오.
    SELECT DEPARTMENT_ID AS 부서별, 
           ROUND(AVG(SALARY)) AS 평균급여
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY)>=6000 --집계함수에 조건이 들어가면 WHERE을 쓸 수 없고 HAVING을 써줘야한다.
     ORDER BY 2 DESC;

사용예) 장바구니테이블에서 2020년 5월 회원별 구매수량합계를 조회하시오.
    SELECT CART_MEMBER AS 회원,     
           
           SUM(CART_QTY) AS 합계
     FROM CART    
     WHERE CART_NO LIKE '202005%'
     GROUP BY CART_MEMBER
     
     ORDER BY 1;
사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6월) 월별, 제품별 매입집계를 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월별,
           BUY_PROD AS 제품코드,
           SUM(BUY_QTY) AS 수량합계,
           SUM(BUY_QTY*BUY_COST) AS 매입금액합계
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND
               TO_DATE('20200630')
      GROUP BY EXTRACT(MONTH FROM BUY_DATE),BUY_PROD  -- 사용된 함수까지 집계함수.
      ORDER BY 1,2;    
사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6월) 월별 매입집계를 조회하되 
        매입금액이 1억원 이상인 월만 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE) AS 월,
           SUM(BUY_QTY) AS 매입수량합계,
           SUM(BUY_QTY*BUY_COST)AS 매입금액합계
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
     GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     HAVING SUM(BUY_QTY*BUY_COST) >=100000000
     ORDER BY 1;
 -- 집계함수는 WHERE절에 올 수 없으니 HAVING 절에 써준다 단! GROUP BY 절 다음에 써줘야함.
사용예) 회원테이블에서 성별 평균 마일리지를 조회하시오.
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('1','3') THEN
                     '남성회원'
            -- WHEN SUBSTR(MEM_REGNO2,1,1) =1 THEN '남성'
            -- WHEN SUBSTR(MEM_REGNO2,1,1) =3 THEN '남성'
               ELSE
                '여성회원'
           END AS 성별,
          ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
      FROM MEMBER
     GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('1','3') THEN
                     '남성회원'
            -- WHEN SUBSTR(MEM_REGNO2,1,1) =1 THEN '남성'
            -- WHEN SUBSTR(MEM_REGNO2,1,1) =3 THEN '남성'
               ELSE
                '여성회원'
           END;
   
사용예) 회원테이블에서 연령대별 평균 마일리지를 조회하시오.
    SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
           ROUND(AVG(MEM_MILEAGE)) AS 마일리지
    FROM MEMBER
    GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
    ORDER BY 1;
사용예) 회원테이블에서 거주지별 평균 마일리지를 조회하시오.
    SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지,
           ROUND(AVG(MEM_MILEAGE)) AS 마일리지
           FROM MEMBER  
       GROUP BY SUBSTR(MEM_ADD1,1,2)
                
사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6월) 제품별 매입집계를 조회하되
       금액 기준 상위 5개 제품만 조회하시오.
SELECT A.BID AS 제품코드,
       A.QSUM AS 수량합계,
       A.CSUM AS 금액합계
 FROM (SELECT BUY_PROD AS BID, 
           SUM(BUY_QTY) AS QSUM, 
           SUM(BUY_QTY*BUY_COST) AS CSUM
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')

     GROUP BY BUY_PROD
     ORDER BY 3 DESC) A
  WHERE ROWUM<=5;   
     -- 상위 5개 추출하기
    -- 의사컬럼  상위 5개이면 5보다 작거나 같은 수 ROWNUM<=5
    -- 서브쿼리 SELECT를 두 번 써줌. WHERE에 AND쓰고 같이 써주면 기존 상위5개와 다른 숫자가 나오므로
    -- 전부 다 계산하고 마지막에 상위 5개만 추출해준다.
    -- 서브쿼리는 영어로 써줘야 그대로 가져올 수 있음...
    
     -- + WHERE 절에 조건이 두개면 AND로 연결( BETWEEN AND는 문법)

    5. ROLLUP 과 CURE
        1) ROLLUP
            - GROUP BY 절안에 사용하여 레벨별 집계의 결과를 반환
            (사용형식)
             GROUP BY [컬럼명,]ROLLUP(컬럼명1,[컬럼명2,...,컬럼명n])
             . 컬럼명1,컬럼명2,...,컬럼명n 을(가장 하위레벨) 기준으로 그룹구성하여
               그룹함수 수행한 후 오른쪽에 기술된 컬럼명을 하나씩 제거한 기준으로 그룹
               구성, 마지막으로 전체 (가장 상위레벨)합계 반환
             . n개의 컬럼이 사용된 경우 n+1종류의 집계반환 --n+1가지의 집계종류가 반환   +1 = 전체집계
             
사용예) 장바구니테이블에서 2020년 월별,회원별,제품별,판매수량집계를 조회하시오
    (GROUP BY절만 사용) 
        SELECT SUBSTR(CART_NO,5,2) AS 월,
               CART_MEMBER AS 회원번호,
               CART_PROD AS 제품코드,
               SUM(CART_QTY) AS 판매수량집계
          FROM CART
         WHERE SUBSTR(CART_NO,1,4)='2020'
         GROUP BY SUBSTR(CART_NO,5,2),CART_MEMBER, CART_PROD
         ORDER BY 1;
 
     (ROLLUP 절만 사용) 
        SELECT SUBSTR(CART_NO,5,2) AS 월,
               CART_MEMBER AS 회원번호,
               CART_PROD AS 제품코드,
               SUM(CART_QTY) AS 판매수량집계
          FROM CART
         WHERE SUBSTR(CART_NO,1,4)='2020'
         GROUP BY ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER, CART_PROD)
         ORDER BY 1;
 
  ** 부분 ROLLUP
  . 그룹을 분류 기준 컬럼이 ROLLUP절 밖(GROUP BY 절 안)에 기술된 경우를
    부분 ROLLUP 이라고 함.
  . ex) GROUP BY 컬럼명1, ROLLUP(컬럼명2,컬럼명3) 인경우
  => 컬럼명1,컬럼명2,컬럼명3 모두가 적용된 집계
     컬럼명1,컬럼명2가 반영된 집계
     컬럼명1 만 반영된 집계
 -- ROOLUP절 밖에 있는 컬럼명은 항상 고정된 기준으로 적용되어진다.
 
 
 (부분 ROLLUP 절만 사용) 
        SELECT SUBSTR(CART_NO,5,2) AS 월,
               CART_MEMBER AS 회원번호,
               CART_PROD AS 제품코드,
               SUM(CART_QTY) AS 판매수량집계
          FROM CART
         WHERE SUBSTR(CART_NO,1,4)='2020'
         GROUP BY CART_PROD, ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER)
         ORDER BY 1;
 
        2) CUBE
            - GROUP BY절 안에서 사용(ROLLUP과 동일)
            - 레벨개념이 없음
            - CUBE내에 기술된 컬럼들의 조합 가능한 경우마다 집계반환(2의 n승수 만큼의 집계반환)
        (사용형식)                                              -- n => 사용된 컬럼의 개수
        GROUP BY CUBE(컬럼명1,...컬럼명n);
    
 사용예) 장바구니테이블에서 2020년 월별,회원별,제품별,판매수량집계를 조회하시오
    (CUBE BY절만 사용) 
        SELECT SUBSTR(CART_NO,5,2) AS 월,
               CART_MEMBER AS 회원번호,
               CART_PROD AS 제품코드,
               SUM(CART_QTY) AS 판매수량집계
          FROM CART
         WHERE SUBSTR(CART_NO,1,4)='2020'
         GROUP BY CUBE(SUBSTR(CART_NO,5,2),CART_MEMBER, CART_PROD)
         ORDER BY 1;
 
 
 
 
 
 
 
 
 
 
 
 