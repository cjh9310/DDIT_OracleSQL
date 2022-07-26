2022-0422-01 TABLE JOIN
    - 관계형 DB의 가장 핵심 기능
    - 복수개의 테이블 사이에 존재하는 관계를 이용한 연산
    - 정규화를 수행하면 테이블이 분활되고 필요한 자료가 복수개의 테이블에 
        분산 저장된 경우 사용하는 연산
    - JOIN의 종류
     . 일반조인 vs ANSI JOIN
     . INNER JOIN VS OUTER JOIN
     . Equi-Join vs Non Equi-Join
     . 기타(Cartesian Product,Self Join ,... etc)
    - 사용형식(ANSI 조인)
    SELECT 컬럼list
      FROM 테이블명1 [별칭1],테이블명2 [별칭2][,테이블명3 [별칭3],...]
     WHERE 조인조건
      [AND 일반조건]
    . 테이블 별칭은 복수개의 테이블에 동일한 컬럼명이 존재하고 해당 컬럼을 참조하는 
      경우 반드시 사용되어야 함
    . 사용되는 테이블이 n개 일때 조인조건은 적어도 n-1개 이상이어야 한다.
    . 조인조건은 두 테이블에 사용된 공통의 컬럼을 사용한다.
     
     
     
     
1. Cartesian Product
    - 조인조건이 없거나
 조인조건에 잘못된 경우 발생
 - 최악의 경우(조인조건이 없는 경우) A테이블(a행 b열)과 B테이블(c행 d열)이
    Cartesian Product를 수행하면 결과는 a*c행, b+d열을 반환
 - ANSI에서는 CROSS JOIN이라고 하며 반드시 필요한 경우가 아니면 수행하지
    말아야하는 JOIN이다.
    
    (사용형식-일반조인)
    SELECT 컬럼list
        FROM 테이블명1 [별칭1],테이블명2 [별칭2][,테이블명3 [별칭3],...]
 
    (사용형식-ANSI조인)
    SELECT 컬럼list
        FROM 테이블명1 [별칭1]        
     CROSS JOUN 테이블명2;  -- 
    
사용예)
    SELECT COUNT(*)  -- 행의 수
        FROM PROD;
    
    SELECT COUNT(*)
        FROM CART;
     
    SELECT COUNT(*)
      FROM BUYPROD;
      
     SELECT COUNT(*)
        FROM PROD A,CART B, BUYPROD;
    
    SELECT COUNT(*)
        FROM PROD A
     CROSS JOIN CART B
     CROSS JOIN BUYPROD C;
    
2. Equi Join
    - 조인 조건에 '='연산자가 사용된 조인으로 대부분의 조인이 이에 포함된다.
    - 복수개의 테이블에 존재하는 공통의 컬럼값의 동등성 평가에 의한 조인
    (일반조인 사용형식)
    SELECT 컬럼list
      FROM 테이블1 별칭1, 테이블2 별칭2[,테이블3 별칭3,...] 
     WHERE 조인조건
    
    (ANSI조인 사용형식) --테이블 1 과 테이블2는 직접 조인이 되어서 반드시 공통의 컬럼이 있어야하고 
    -- 테이블3은 테이블1과 공통의 컬럼이 없어도 테이블2와 공통의 컬럼을 가지고 있으면 문제가 없음.
    
    SELECT 컬럼list
      FROM 테이블1 별칭1
     INNER JOIN 테이블2 별칭2 ON(조인조건 [AND 일반조건])
     [INNER JOIN 테이블3 별칭3 ON(조인조건 [AND 일반조건])
              :
     [WHERE 일반조건]
      . 'AND 일반조건' : ON절에 기술된 일반조건은 해당 INNER JOIN 절에의해 
        조인에 참여하는 테이블에 국한된 조건
      . 'WHERE 일반조건' : 모든 테이블에 적용되어야 하는 조건기술
    
사용예) 2020년 1월 제품별 매입집계를 조호하시오.
    Alias는 제품코드,제품명,매입금액합계이며 제품코드순으로 출력하시오
    SELECT A.BUY_PROD AS 제품코드,
           B.PROD_NAME AS 제품명,
           SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액합계
      FROM BUYPROD A,PROD B
     WHERE A.BUY_PROD = B.PROD_ID  -- 조인 조건
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND
                              TO_DATE('20200131')
     GROUP BY A.BUY_PROD, B.PROD_NAME
     ORDER BY 1; 
  
    (ANSI JOIN)    
     SELECT A.BUY_PROD AS 제품코드,
           B.PROD_NAME AS 제품명,
           SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액합계
      FROM BUYPROD A
     INNER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID  -- 조인 조건
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))
     GROUP BY A.BUY_PROD, B.PROD_NAME
     ORDER BY 1;    
    
사용예) 상품테이블에서 판매가가 50만원이상인 제품을 조회하시오.
        Alias는 상품코드,상품명,분류명,거래처명,판매가격이고 판매가격이 큰 상품순으로
        출력하시오...
        SELECT A.PROD_ID AS 상품코드,
               A.PROD_NAME AS 상품명,
               B.LPROD_NM AS 분류명,
               C.BUYER_NAME AS 거래처명,
               A.PROD_PRICE AS 판매가격
          FROM PROD A,LPROD B,BUYER C
         WHERE A.PROD_LGU =B.LPROD_GU  -- 분류명을 가져옴.     조인조건
         --    A.PROD_LGU = C.BUYER_LGU  -- 거래처명을 거져옴. 조인조건
            AND A.PROD_BUYER=C.BUYER_ID  -- 거래처명을 거져옴. 조인조건
            AND A.PROD_PRICE >=500000  --일반조건
         ORDER BY 5;
    -- WHERE 문에서 테이블을 동기화 시킬 때 한가지 컬럼으로 3개이상을 다 같은 컬럼을 쓰게 되면 결과에 중복이 발생하므로
    -- 3가지 이상 테이블을 동기화 할때 컬럼을 다른 것으로 써줘서  동기화 시켜야한다. 
    --EX) A.PROD_LGU =B.LPROD_GU (LGU코드) 그리고  A.PROD_BUYER=C.BUYER_ID(BUYER아이디 코드)
    
    
    SELECT A.PROD_ID AS 상품코드,
                   A.PROD_NAME AS 상품명,
                   B.LPROD_NM AS 분류명,
                   C.BUYER_NAME AS 거래처명,
                   A.PROD_PRICE AS 판매가격
              FROM PROD A  
             INNER JOIN LPROD B ON(A.PROD_LGU =B.LPROD_GU)
             INNER JOIN BUYER C ON(A.PROD_BUYER=C.BUYER_ID)  
             WHERE A.PROD_PRICE >=500000 
             ORDER BY 5 DESC;    
    
        
    SELECT A.PROD_ID AS 상품코드,
                   A.PROD_NAME AS 상품명,
                   B.LPROD_NM AS 분류명,
                   C.BUYER_NAME AS 거래처명,
                   A.PROD_PRICE AS 판매가격
              FROM PROD A  
             INNER JOIN LPROD B ON(A.PROD_LGU =B.LPROD_GU)
             INNER JOIN BUYER C ON(A.PROD_BUYER=C.BUYER_ID AND
                              A.PROD_PRICE >=500000 )  
             ORDER BY 5 DESC;
    
사용예) 2020년 상반기 거래처별 판매액집계를 구하시오.
    Alias는 거래처코드,거래처명,판매액합계
    SELECT A.BUYER_ID AS 거래처코드,
           A.BUYER_NAME AS 거래처명,
           SUM(B.CART_QTY*C.PROD_PRICE) AS 판매액합계
      FROM BUYER A, CART B, PROD C
     WHERE SUBSTR(B.CART_NO,1,6) BETWEEN '202001' AND '202006'
       AND B.CART_PROD=C.PROD_ID --조인조건(단가를 추출하기 위해서)
       AND A.BUYER_ID = C.PROD_BUYER -- 조인조건(거래처 추출)
     GROUP BY A.BUYER_ID,A.BUYER_NAME
     ORDER BY 1;
    
    
사용예) HR계정에서 미국 이외의 국가에 위치한 부서에 근무하는 사원정보를
       조회하시오.
       Alias는 사원번호,사원명,부서명,직무코드,근무지주소
       미국의 국가코드는 'US'이다.
        SELECT A.EMPLOYEE_ID AS 사원번호,
               A.EMP_NAME AS 사원명,
               B.DEPARTMENT_NAME AS 부서명,
               A.JOB_ID AS 직무코드,
               C.STREET_ADDRESS||' '||CITY||', '||STATE_PROVINCE AS 근무지주소
          FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,HR.LOCATIONS C
         WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID --조인조건(부서추출)
           AND B.LOCATION_ID = C.LOCATION_ID --조인조건(해당 부서의 위치코드와 주소 추출)
           AND C.COUNTRY_ID NOT IN('US')   -- 아니면 C.COUNTRY_ID != 'US' 도 가능
         ORDER BY 1;
    
사용예) 2020년 4월 거래처별 매입금액을 조회하시오.
        Alias는 거래처코드,거래처명,매입금액합계
        
        SELECT A.BUYER_ID AS 거래처코드,
               A.BUYER_NAME AS 거래처명,
               SUM(B.BUY_QTY*C.PROD_COST) AS 매입금액합계 --C.PROD_COST 대신 B.BUY_COST를 써도 되지만 더 많은 걸 쓰자.
          FROM BUYER A, BUYPROD B, PROD C
         WHERE B.BUY_PROD = C.PROD_ID
           AND C.PROD_BUYER = A.BUYER_ID
           AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND  LAST_DAY(TO_DATE('20200401'))
         GROUP BY A.BUYER_ID,A.BUYER_NAME
(ANIS)         
         SELECT C.BUYER_ID AS 거래처코드,
               C.BUYER_NAME AS 거래처명,
               SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액합계 
          FROM BUYPROD A        --첫번째 조인은 반드시 JOIN이 되어야해서 
         INNER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID AND
               A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
         INNER JOIN BUYER C ON(B.PROD_BUYER = C.BUYER_ID)
         GROUP BY C.BUYER_ID,C.BUYER_NAME
         ORDER BY 1;
        
사용예) 2020년 4월 거래처별 매출금액을 조회하시오.
        Alias는 거래처코드,거래처명,매출금액합계 
        
        SELECT A.BUYER_ID AS 거래처코드,
               A.BUYER_NAME AS 거래처명,
               SUM(B.CART_QTY * C.PROD_PRICE) AS 매출금액합계
          FROM BUYER A, CART B, PROD C
         WHERE C.PROD_BUYER = A.BUYER_ID
           AND B.CART_PROD = C.PROD_ID
           AND SUBSTR(B.CART_NO,1,8) BETWEEN '20200401' AND '20200430'
         GROUP BY A.BUYER_ID,A.BUYER_NAME
(ANIS) 
        SELECT A.BUYER_ID AS 거래처코드,
               A.BUYER_NAME AS 거래처명,
               SUM(B.CART_QTY * C.PROD_PRICE) AS 매출금액합계
          FROM BUYER A
         INNER JOIN PROD C ON(A.BUYER_ID = C.PROD_BUYER) 
         INNER JOIN CART B ON(C.PROD_ID = B.CART_PROD AND B.CART_NO LINE '202004%')
         GROUP BY A.BUYER_ID, A.BUYER_NAME
         ORDER BY 1;
          
 사용예) 2020년 4월 거래처별 매입/매출금액을 조회하시오.
        Alias는 거래처코드,거래처명,매입금액합계 ,매출금액합계  
        SELECT A.BUYER_ID AS 거래처코드,
               A.BUYER_NAME AS 거래처명,
               SUM(D.BUY_QTY*C.PROD_COST) AS 매입금액합계,
               SUM(B.CART_QTY * C.PROD_COST) AS 매출금액합계
          FROM BUYER A, CART B, PROD C, BUYPROD D
         WHERE C.PROD_BUYER = A.BUYER_ID
           AND D.BUY_PROD = C.PROD_ID
           AND B.CART_PROD = C.PROD_ID
           AND SUBSTR(B.CART_NO,1,8) BETWEEN '20200401' AND '20200430'
           AND B.CART_NO LIKE '202004%'
         GROUP BY A.BUYER_ID,A.BUYER_NAME 
         ORDER BY 1;
(ANSI)
        SELECT A.BUYER_ID AS 거래처코드,
               A.BUYER_NAME AS 거래처명,
               SUM(B.BUY_QTY*D.PROD_COST) AS 매입금액합계,
               SUM(C.CART_QTY * D.PROD_COST) AS 매출금액합계
          FROM BUYER A
         INNER JOIN PROD D ON(D.PROD-BUYER = A.BUYER_ID)
         INNER JOIN BUYPROD B ON(D.PROD_ID = B.BUY_PROD AND
               B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
         INNER JOIN CART C ON(D.PROD_ID = C.CART_PROD AND
               C.CART_NO LIKE '202004%')
         GROUP BY A.BUYER_ID,A.BUYER_NAME 
         ORDER BY 1;
         
   (해결 : 서브쿼리+외부조인)
     SELECT TB.CID AS 거래처코드,
            TB.CNAME AS 거래처명,
            NVL(TA.BUYSUM,0) AS 매입금액합계,
            NVL(TB.SELLSUM,0) AS 매출금액합계
       FROM (SELECT A.BUYER_ID AS BID,
                    A.BUYER_NAME AS BNAME,
                    SUM(C.BUY_QTY*C.BUY_COST) AS BUYSUM
               FROM BUYER A
              INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
              INNER JOIN BUYPROD C ON (C.BUY_PROD = B.PROD_ID)
              WHERE C.BUY_DATE BETWEEN ('20200401') AND LAST_DAY('20200401')
              GROUP BY A.BUYER_ID, A.BUYER_NAME) TA,
                    (SELECT A.BUYER_ID AS CID, -- 서브쿼리
                            A.BUYER_NAME AS CNAME,
                            SUM(C.CART_QTY*B.PROD_PRICE) AS SELLSUM
               FROM BUYER A
              INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
              INNER JOIN CART C ON (C.CART_PROD = B.PROD_ID)
              WHERE C.CART_NO LIKE ('202004%')
              GROUP BY BUYER_ID, BUYER_NAME) TB
       WHERE TA.BID(+)=TB.CID -- 외부조인조건: 데이터가 적은 쪽에(+)을 붙여야한다! 
       ORDER BY 1;
              
 사용예)사원테이블에서 전체사원의 평균급여보다 더 많은 급여를 받는 사원을 조회하시오.
       Alias는 사원번호,사원명,부서코드,급여
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           A.DEPARTMENT_ID AS 부서코드,
           A.SALARY AS 급여
      FROM HR.employees A, 
           (SELECT AVG(SALARY) AS BSAL
              FROM HR.employees) B
     WHERE A.SALARY>B.BSAL
     ORDER BY 3;     
        
        
        
        
        
        
        
        
        
        
        