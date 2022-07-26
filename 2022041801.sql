2022-0418-01)
    06) WIDTH_BUCKET(n,min,max,b)
        - min에서 max값의 범위를 b개의 구간으로 나누고 주어진 값 n이 속한 구간의 
        인덱스 값을 반환
        - max 값은 구간에 포함되지 않으며, min보다 작은 n값은 0(번)구간
        max보다 큰 값은 b+1구간인덱스를 반환함(n과 같으면 안된다.)
사용예)
    SELECT WIDTH_BUCKET(60,20,80, 4) AS COL1,
           WIDTH_BUCKET(80,20,80, 4) AS COL2, -- MAX 값 초과
           WIDTH_BUCKET(20,20,80, 4) AS COL3,
           WIDTH_BUCKET(100,20,80, 4) AS COL4 -- MAX 값 초과
      FROM DUAL;
사용예) 회원테이블에서 1000~6000 마일리지를 6개의 구간으로 나누었을때 각 회원들의
        마일리지에 따른 등급을 구하여 출력하시오.
        Alias는 회원번호,회원명,마일리지,등급
        단, 등급은 마일리지가 6000초과한 회원 1등급에서 마지막등급으로 
        분류하시오.
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_MILEAGE AS 마일리지,
              8- WIDTH_BUCKET(MEM_MILEAGE,1000,6000,6) AS 등급1, -- 6가지 등급 + 1000이하 등급 + 6000초과 등급 = 총 8등급.
               WIDTH_BUCKET(MEM_MILEAGE,6000,999,6) +1 AS 등급2
          FROM MEMBER;
         --  8- 없이 그냥 실행하면 등급이 반대로 떠서, 8-를 넣고 실행하면 목표값이 나오게 된다.....
         -- 구한 숫자 앞에 8-를 써준 것,
         
3. 날짜형 함수
    1) SYSDATE
        - 시스템에서 제공하는 날짜와 시간정보 반환
        - -와+의 연산이 가능함
        
사용예) SELECT SYSDATE+3650 FROM DUAL; --윤년,평년 등 자동으로 계산해줌.
         
    2) ADD_MONTHS(d,n)
        - 주어진 날짜 d에 n 개월을 더한 날짜 반환
사용예) SELECT ADD_MONTHS(SYSDATE, 120) FROM DUAL;
        --ROUND를 쓰면 오늘도 하루 지난 날로 취급된다.?


    3) NEXT_DAY(d, c)
        - 주어진 날짜 다음에 처음 만나는 c요일의 날짜를 반환
        - c 는 '월요일', '월' ~ '일요일','일' 중 하나의 요일 선택
사용예) -- 환경설정에서 날짜를 한글로 선택해서 영어말고 한글로 써야한다.
        SELECT NEXT_DAY(SYSDATE, '월요일'), 
               NEXT_DAY(SYSDATE, '일요일'),
               NEXT_DAY(SYSDATE, '토요일')
          FROM DUAL;
    4) LAST_DAY(d) -- d는 날짜 타입. 년/월/일이 나온다.
        - 주어진 날짜자료 d에 포함된 월의 마지막 날짜를 반환
        - 주로 2월의 마지막일자(윤년/평년)를 사용할때 사용됨.
          
사용예) 사원테이블에서 2월달에 입사한 사원정보를 조회하시오.
        Alias는 사원번호,사원명,부서명,직책,입사일이다.
        SELECT A.EMPLOYEE_ID AS 사원번호,
               A.EMP_NAME AS 사원명,
               B.DEPARTMENT_NAME AS 부서명,
               C.JOB_TITLE AS 직무,
               A.HIRE_DATE AS 입사일
          FROM HR.EMPLOYEES A, HR.departments b, HR.JOBS C -- JOIN 조건은 사용테이블이 n개 일때 n-1개가 있어야한다.
            -- A,B,C 테이블 별칭.  중복되는 컬럼명 뒤에 테이블명을 적어야 하는데 테이블명이 길어서 별칭사용.
         WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
           AND C.JOB_ID = A.JOB_ID   
           AND EXTRACT(MONTH FROM A.HIRE_DATE) =2;  --
사용예) 매입테이블(BUYPROD)에서 2020년 2월 일자별 매입집계를 구하시오.
        Alias는 날짜,매수량합계,매입금액합계이며 날짜순으로 출력하시오.
        SELECT BUY_DATE AS 날짜,
               SUM(BUY_QTY) AS 매수량합계,
               SUM(BUY_QTY*BUY_COST) AS 매입금액합계
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND --BUY_DATE에서 가져온 TO_DATE와 LAST_DAY(TO_DATE)의 사이를 추출한다.
               LAST_DAY(TO_DATE('20200201')) -- 2월의 마지막 날
        -- WHERE EXTRACT(MONTH FROM BUY_DATE) =2  -- EXTRACT=날짜 추출 / MONTH=달 / expr(FROM 컬럼, TO_DATE, SYSDATE) 다 가능
        -- 월 추출하는 방법에는 2가지 방법이 있음
         GROUP BY BUY_DATE -- 종합
         ORDER BY 1;    -- 1번을 순서대로 정렬해라.
          
    (5) EXTRACT(fmt FROM d)
        - 주어진 날짜자료 d에서 fmt(Format String:형식문자열)로 제시된 값을 반환
        - fmt는 YEAR, MONTH, DAY, HOUR, MINUTE, SECOND  중 하나
        - 결과는 숫자자료이다.
        
사용예) 회원테이블에서 이번달에 생일이 있는 회원을 조회하시오
        Alias는 회원번호, 회원명, 생년월일, 마일리지
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_BIR AS 생년월일,
               MEM_MILEAGE AS 마일리지
        FROM MEMBER
       WHERE EXTRACT(MONTH FROM MEM_BIR) =05
        ORDER BY 3;
사용예) 오늘이 2020년 4월 18일이라고 가정할때 
        사원테이블에서 근속년수가 15년 이상인 사원을 조회하시오.
        Alias는 사원번호, 사원명, 입사일, 근속년수, 급여
        SELECT EMPLOYEE_ID AS 사원번호,
               EMP_NAME AS 사원명, 
               HIRE_DATE AS 입사일,
               EXTRACT(YEAR FROM TO_DATE('20200418')) - EXTRACT(YEAR FROM HIRE_DATE) AS 근속년수,
               SALARY AS 급여
          FROM HR.employees
         WHERE EXTRACT(YEAR FROM TO_DATE('20200418')) - EXTRACT(YEAR FROM HIRE_DATE) >=15
         ORDER BY 4 DESC;  
         --ORDER BY 4 DESC;  2001년부터 오름차순
         --ORDER BY 4;       2005년부터 내림차순
        
        
        
      