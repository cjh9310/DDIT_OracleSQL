2022-0427-01)서브쿼리
    - SQL문 안에 존재하는 또 다른 SQL문
    - SQL문장 안에 보조로 사용되는 중간 결과를 반환하는 SQL문
    - 알려지지 않은 조건에 근거한 값들을 검색하는 SELECT문에 사용
    - 서브쿼리는 검색문(SELECT)뿐만아니라 DML(INSERT,UPDATE,DELETE)문에서도 사용됨
    - ★서브쿼리는 '( )'안에 기술되어야 함 (단,(예외) INSERT문에 사용하는 SUBQUERY는 제외)
    - 서브쿼리는 반드시 연산자 오른쪽에 기술해야함(조건절에서 사용)
    - 단일 결과 반환 서브쿼리(단일행 연산자:>,<,>=,<=,=,!=)
      vs 복수 결과 반환 서브쿼리(복수행 연산자: IN ALL, ANY, SOME, EXISTS)
    - 연관성 있는 서브쿼리 vs 연관성 없는 서브쿼리
    - 일반서브쿼리(SELECT절에 있을때) vs in-line 서브쿼리(FROM절에 있을때 단! 반드시 독립실행되어야한다.)
      vs 중첩서브쿼리(WHERE절에 있을때)   -- 위치에 따라
    
1. 연관성 없는 서브쿼리
    - 메인쿼리의 테이블과 서브쿼리의 테이블이 조인으로 연결되지 않은 경우
    
사용예) 사원테이블에서 사원들의 평균급여보다 많은 급여를 받는 사원을 조회하시오.
        Alias는 사원번호,사원명,부서명,급여
    (메인쿼리 : 사원들의 사원번호,사원명,부서명,급여를 조회 )
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.SALARY AS 급여
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_NAME -- 조인을 사용하는 이유: 부서명 때문에.  
       AND A.SALARY>(평균급여);
    
    (서브쿼리 : 평균급여 ) --평균급여 계산.
    SELECT AVG(SALARY)
      FROM HR.employees
      
    (결합)      
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.SALARY AS 급여
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- 조인을 사용하는 이유: 부서명 때문에.  
       AND A.SALARY>=(SELECT AVG(SALARY)
                             FROM HR.employees);    
                             -- 평균 비교할때마다 AVG계산함.
                             -- 서브쿼리의 사용횟수는 사원 수만큼
    -- 이게 연관성 없는 서브쿼리  (메인쿼리와 서브쿼리가 조인되지 않았음.)
    
    (평균급여 출력)    
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           A.SALARY AS 급여,
           (SELECT ROUND(AVG(SALARY))
                FROM HR.employees) AS 평균급여
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID   
       AND A.SALARY>(SELECT AVG(SALARY)
                             FROM HR.employees);      
    
    (in-line view 서브쿼리)    
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_NAME AS 부서명,
           ROUND(C.ASAL) AS 평균급여
      FROM HR.employees A, HR.DEPARTMENTS B,
            (SELECT AVG(SALARY) AS ASAL               
        --서브쿼리의 컬럼의 AS는 출력용이 아니라 참조용이다 그러므로 여기에는 한글이 아니라 영어를 써줘야함.
        -- 서브쿼리의 수행횟수는 1번!
                             FROM HR.employees) C  --(in-line view 서브쿼리)  그리고 테이블이 3개
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID   --Equi-Join
       AND A.SALARY>C.ASAL;        -- Non Equi-Join
     -- 3개 다 연결해서 이들은 조인을 사용한 것.  + 연관성 있는 서브쿼리
    
2. 연관성 있는 서브쿼리
    - 메인쿼리와 서브쿼리가 조인으로 연결된 경우
    - 대부분의 서브쿼리
    
사용예) 직무변동테이블(JOB_HISTORY)과 부서테이블의 부서번호가 같은 
       자료를 조회하시오.
       Alias는 부서번호,부서명이다.
       
(IN 연산자 이용)
       SELECT A.DEPARTMENT_ID AS 부서번호,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.departments A
        WHERE A.DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                                FROM HR.JOB_HISTORY B
                               WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID);
    -- 바깥쪽 FROM,WHERE절이 먼저 실행되어서 IN뒤에 있는 서브쿼리는 언제든 먼저 실행된 절들을 쓸 수 있음.
    
EXISTS 다음에는 서브쿼리가 나와야함  만약 EXISTS의 서브쿼리 결과가 한 건이라도 나오면 TRUE 없으면 FALSE

(EXISTS 연산자 이용)
       SELECT A.DEPARTMENT_ID AS 부서번호,
              A.DEPARTMENT_NAME AS 부서명
         FROM HR.departments A   --EXISTS자리에는 아무것도 오지 않는다.
        WHERE EXISTS (SELECT 1  --or 1(부서아이디)에 *을 써도 동일한 답
                        FROM HR.JOB_HISTORY B
                       WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID); -- 서로 부서코드가 같으면 1(의미 없는 1이다.)
             -- 1을써도 EXISTS 특성상 뭔가가 출력되면 참이라 결과가 알아서 나옴.
    
    -- 바깥쪽 FROM,WHERE절이 실행되고 내부의 FROM,WHERE절이 실행되는데
    -- EXISTS로 내부 조건절(WHERE)의 결과가 한 건이라도 나오면 출력할 수 있음.
    -- 1은 의미없다. DEPARTMENT_ID(부서번호)이다. 아무거나 들어가도 상관 없는듯?? 
    
사용예)2020년 5월 판매된 상품별 판매집계 중 상위 3개 상품의 판매집계정보를 조회하시오.    
        Alias 상품코드,상품명,거래처명(BUYER),판매금액합계(PROD + CART)
(메인쿼리 : 금액기준 상위 3개 상품에 대한 상품코드,상품명,거래처명,판매금액합계)

    SELECT 상품코드,상품명,거래처명,판매금액합계
      FROM PROD A, BUYER C   --CART 테이블은 서브쿼리에서 필요한 건 다 써서 이제 필요없음..
     WHERE A.PROD_ID =(상위 3개 상품의 제품코드)
       AND A.PROD_BUYER =C.BUYER_ID;
(서브쿼리 : 판매기준으로 판매정보 추출)
    SELECT A.CART_PROD AS CID,    --CID : 상품코드
           B.PROD_NAME AS CNAME,
           SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM  --CSUM : CID +SUM   서브쿼리는 영어 선호.
      FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID  
       AND A.CART_NO LIKE '202005%'   --LIKE연산자는 범위지정할때 절대로 쓸 수 없음.
     GROUP BY A.CART_PROD, B.PROD_NAME
     ORDER BY 3 DESC;
     
(결합)
    SELECT C.CID AS 상품코드,
           C.CNAME AS 상품명,
           B.BUYER_NAME AS 거래처명,
           C.CSUM AS 판매금액합계
      FROM PROD A, BUYER B ,
            (SELECT A.CART_PROD AS CID,    --CID : 상품코드
                    B.PROD_NAME AS CNAME,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM  --CSUM : CID +SUM   서브쿼리는 영어 선호.
               FROM CART A, PROD B
              WHERE A.CART_PROD = B.PROD_ID  
                AND A.CART_NO LIKE '202005%'   --LIKE연산자는 범위지정할때 절대로 쓸 수 없음.
              GROUP BY A.CART_PROD, B.PROD_NAME
              ORDER BY 3 DESC) C
              WHERE A.PROD_ID =C.CID
                AND A.PROD_BUYER =B.BUYER_ID
                AND ROWNUM<=3;
     
사용예)2020년 상반기에 구매액기준 1000만원 이상을 구매한 회원정보를 조회하시오.
        Alias는 회원번호,회원명,직업,구매액,마일리지
(메인쿼리:회원정보(회원번호,회원명,직업,구매액,마일리지)를 조회)

        SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
               B.    AS 구매액,
               A.MEM_MIELAGE AS 마일리지
          FROM MEMBER A, 
                    (1000만원 이상을 구매한 회원)B
         WHERE A.MEM_ID = B.회원번호;
(서브쿼리: 2020년 상반기에 구매액기준 1000만원 이상)
-- 서브쿼리를 쓰면 A테이블과 B테이블의 공통컬럼이 있어야하고 조인을 무엇으로 할지 생각하기.
        SELECT A.CART_MEMBER AS  BID,
               SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
          FROM CART A, PROD B 
         WHERE A.CART_PROD = B.PROD_ID --CART에 없는 단가를 꺼내오기 위해서 조인.
           AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
         GROUP BY A.CART_MEMBER
        HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000
        

(결합- INLINE VIEW 사용) -- FROM절에

        SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
               B.BSUM AS 구매액,
               A.MEM_MILEAGE AS 마일리지
          FROM MEMBER A, 
                    (SELECT A.CART_MEMBER AS  BID,
                            SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
                       FROM CART A, PROD B 
                      WHERE A.CART_PROD = B.PROD_ID --CART에 없는 단가를 꺼내오기 위해서 조인.
                        AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                      GROUP BY A.CART_MEMBER
                     HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B
                      WHERE A.MEM_ID = B.BID;

(결합- 중첩서브쿼리) -- WHERE절에
    SELECT A.MEM_ID AS 회원번호,
               A.MEM_NAME AS 회원명,
               A.MEM_JOB AS 직업,
           --    B.BSUM AS 구매액,
               A.MEM_MILEAGE AS 마일리지
      FROM MEMBER A 
     WHERE A.MEM_ID IN(SELECT B.BID    -- B테이블에 있는 BID
                         FROM (SELECT A.CART_MEMBER AS  BID,
                                      SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
                                 FROM CART A, PROD B 
                                WHERE A.CART_PROD = B.PROD_ID --CART에 없는 단가를 꺼내오기 위해서 조인.
                                  AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                                GROUP BY A.CART_MEMBER
                               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B);
    
    -- REMAIN(재고 수불테이블)
 --REMAIN_I (입고량) REMAIN_O (출고량) REMAIN_J_99(기말재고) 
 -- REMAIN_DATE