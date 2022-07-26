2022-0426-01) 집합연산자
    - SQL연산의 결과를 데이터 집합(set)이라고도 함
    - 이런 집합들 사이의 연산을 수행하기 위한 연산자를 집합연산자라고 함
    - UNION, UNION ALL, INTERSECT, MINUS 가 제공
    - 집합연산자로 연결되는 각 SELECT문의 SELECT절의 컬럼의 갯수,순서,타입이 일치해야함
    - ORDER BY 절은 맨 마지막 SELECT문에만 사용 가능
    - 출력은 첫 번째 SELECT문의 SELECT절이 기준이됨
    -- UNION ALL 두 번이상(중복된 갯수만큼) 검색결과 (전체 + 중복된 부분)
    -- INTERSECT 공통 부분의 검색결과를 알려줌
    -- -MINUS 차집합( 공통되지 않는 부분을 알려줌)
(사용형식)
    SELECT 컬럼LIST
      FROM 테이블명
    [WHERE 조건]
    UNION|UNION ALL|INTERSECT|MINUS  --UNION|UNION ALL 합집합
    SELECT 컬럼LIST
      FROM 테이블명
    [WHERE 조건]
          :
  UNION|UNION ALL|INTERSECT|MINUS
    SELECT 컬럼LIST
      FROM 테이블명
    [WHERE 조건]
    [ORDER BY 컬럼명|컬럼idex [ASC|DESC,...];
      
      
1.UNION 
    - 중복을 허락하지 않은 합집합의 결과를 반환
    - 각 SELECT문의 결과를 모두 포함
    
사용예)회원테이블에서 20대 여성회원과 충남거주회원의 회원번호,회원명,직업,
        마일리지를 조회하시오. -- 한 명이 충남에 거주중이면서 여성인 회원 한 명이 '송경희'인데 첫번째 값이 11명 두번째 값이 3명
        -- 그 중 '송경희'는 둘 다 포함되서 마지막 전체 결과에는 한 번만 출력,
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)) 
                BETWEEN 20 AND 29
           AND SUBSTR(MEM_REGNO2,1,1) IN(2,4)
         UNION
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_ADD1 LIKE '충남%'    --SUBSTR도 가능
         ORDER BY 1;
        
2. INTERSECT
    - 교집합(공통부분)의 결과 반환
        
사용예)회원테이블에서 20대 여성회원과 충남거주회원 중 마일리지가2000이상인 회원번호,회원명,직업,
        마일리지를 조회하시오.        
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)) 
                BETWEEN 20 AND 29
           AND SUBSTR(MEM_REGNO2,1,1) IN(2,4)
UNION
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_ADD1 LIKE '충남%'    --SUBSTR도 가능
                
INTERSECT
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_JOB AS 직업,
               MEM_MILEAGE AS 마일리지
          FROM MEMBER
         WHERE MEM_MILEAGE>2000   
         ORDER BY 1; 
        
3. UNION ALL
    - 중복을 허락하여 합집합의 결과를 반환
    - 각 SELECT문의 결과를 모두 포함(중복 포함)
사용예) 1번 DEPTS 테이블에서 PARENT_ID가 NULL인 자료의 부서코드,부서명,상위부서코드(PARENT_ID),
        레벨(결과 왼쪽에 나오는 숫자)을 조회하시오.
        단, 상위부서코드는 0이고 레벨은 1이다.
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           0 AS PARENT_ID,
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL;   -- 중요! = 으로는 NULL을 찾을 수 없다 IS사용
        
2번 DEPTS 테이블에서 상위부서코드가 NULL인 부서코드를 상워부서코드로 가진 
        부서의 부서코드,부서명,상위부서코드,레벨을 조회하시오.
        단, 레벨은 2이고 부서명은 왼쪽에서 4칸의 공백을 삽입 후 부서명 출력
    해석 = 총무기획부의 DEPARTMENT_ID와 같은 코드의 부서를 찾아라.
    
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,  --RPAD 오른쪽 공백
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B  --같은 테이블이 두 개가 사용 중.
     WHERE A.PARENT_ID IS NULL     -- 총무기획부 => 기준이 되는 테이블.
       AND B.PARENT_ID=A.DEPARTMENT_ID;
      -- 한 테이블에 별칭 두개를 부여해서 서로 다른 테이블로 간주
      -- B테이블은 A(기준)와 비교하는 테이블
      -- 총무기획부의 부서번호(A.DEPARTMENT_ID)  나머지 부서의 부서번호(B.PARENT_ID)가 같으면 
         -- 총무기획부에 소속되어있는 부서를 찾는 것
(결합)    
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID,
           --0 AS PARENT_ID,  도 가능
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL 
     UNION ALL  --SELECT
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, 
             -- 나중에 2 대신 LEVEL을 사용 
             -- 2-1인 이유 : 계층쿼리로 만들었을 때 상수가 아니라 LEVEL이 온다.
             -- 숫자2 자리에 LEVEL이 들어가는데 위쪽 SELECT는 빈칸을 생성하지 않아서 1-1을 적용해주고
             -- 아래의 SELECT은 빈칸을 생성하므로 2-1로 사용한다.
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS     
      FROM HR.DEPTS A, HR.DEPTS B  
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID;
       
       -- A테이블이 가지고있는 부서코드 10
       
       
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID,
           1 AS LEVELS,
           PARENT_ID || DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL 
     
     UNION ALL  
     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS,
           B.PARENT_ID||B.DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS A, HR.DEPTS B  
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID;
     UNION ALL  
    SELECT C.DEPARTMENT_ID,
           LPAD(' ',4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           C.PARENT_ID AS PARENT_ID,
           3 AS LEVELS,
           B.PARENT_ID||C.PARENT_ID||C.DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS A, HR.DEPTS B ,HR.DEPTS C
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID
       AND C.PARENT_ID=B.DEPARTMENT_ID
       ORDER BY 5;
       -- A 총무기획부 담당                              1LEVEL
       -- B 총무기획부의 직속 소속 되어있는 6개의 부서       2LEVEL
       -- C 6개의 하위 부서를 담당                        3LEVEL
       -- 망함... 복붙 시급

**계층형쿼리
    - 계층적 구조를 지닌 테이블의 내용을 출력할때 사용
    - 트리구조를 이용한 방식
    (사용형식)
    SELECT 컬럼list
      FROM 테이블명
     START WITH 조건 -- 조건 => 루트(root)노드 지정
   CONNECT BY NOCYCLE|PRIOR 계층구조 조건 --계층구조가 어떤식으로 연결 되었는지
   -- NOCYCLE : 무한루프 방지 / PRIOR : 대부분
** CONNECT BY PRIOR 자식컬럼 = 부모컬럼 :부모에서 자식으로 트리구성(TOP DOWN)
** CONNECT BY PRIOR 부모컬럼 = 자식컬럼 :자식에서 부모로 트리구성(BOTTOM UP)

** PRIOR 사용위치에 따른 방향
    CONNECT BY PRIOR 컬럼1 = 컬럼2
                     <--------------
    CONNECT BY 컬럼1 = PRIOR 컬럼2
                     --------------->
** 계층형 쿼리 확장
    CONNECT_BY_ROOT 컬럼명 : 루트노드 찾기
    CONNECT_BY_ISCYCLE : 중복참조값 찾기
    CONNECT_BY_ISLEAF : 단말노드 찾기
       
        SELECT DEPARTMENT_ID AS 부서코드,
               LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS 부서명,
               LEVEL AS 레벨
          FROM HR.DEPTS
         START WITH PARENT_ID IS NULL
       CONNECT BY PRIOR DEPARTMENT_ID = PARENT_ID
--     CONNECT BY PRIOR PARENT_ID = DEPARTMENT_ID; 
         ORDER SIBLINGS BY DEPARTMENT_NAME; --정렬
        
        
        
        
        
사용예) 장바구니테이블에서 4월과 6월에 판매된 모든 상품정보를 중복되지 않게 조회하시오. --CART
       Alias는 상품번호,상품명,판매수량 이며 상품번호 순으로 출력하시오.
       SELECT B.PROD_ID AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 판매수량 --4월에 판매된 중복된 제품OR번호를 합친 것.
         FROM CART A,PROD B              --월별로 추출됨.
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='04'
        GROUP BY B.PROD_ID,B.PROD_NAME
   UNION
       SELECT B.PROD_ID AS 상품번호,
              B.PROD_NAME AS 상품명,
              SUM(A.CART_QTY) AS 판매수량
         FROM CART A,PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        GROUP BY B.PROD_ID,B.PROD_NAME
        ORDER BY 1;
사용예) 장바구니테이블에서 4월에도 판매되고 6월에도 판매된 모든 상품정보를 조회하시오.
       Alias는 상품번호,상품명이며 상품번호 순으로 출력하시오.       
       SELECT B.PROD_ID AS 상품번호,
              B.PROD_NAME AS 상품명
         FROM CART A,PROD B              
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='04'
   UNION ALL
       SELECT B.PROD_ID AS 상품번호,
              B.PROD_NAME AS 상품명
         FROM CART A,PROD B
        WHERE A. CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        ORDER BY 1;      
       
       
사용예) 장바구니테이블에서 4월과 6월에 판매된 상품 중 6월에만 판매된 상품정보를 조회하시오.
       Alias는 상품번호,상품명,판매수량 이며 상품번호 순으로 출력하시오.             
       
       SELECT B.PROD_ID AS 상품번호,
              B.PROD_NAME AS 상품명,
              A.CART_QTY AS 판매수량
         FROM CART A,PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        ORDER BY 1;
       
       
       
       