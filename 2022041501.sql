2022-0415-01) 숫자함수
    1. 수학적함수
     - ABS, SIGN, POWER, SQRT등이 제공됨
     1) ABS(n), SIGN(n), SQRT(n), POWER(e,n)
        ABS(n) : 주어진 수 n의 절대값
        SIGN(n) : 주어진 수 n이 양수이면 1, 음수이면 -1, 0아면 0을 반환
        SQRT(n) : 주어진 수 n의 평방근 반환
        POWER(e,n) : e의 n승 (e를 n번 거듭 곱한 값)
        
(사용예)
    SELECT ABS(-2000), ABS(0.0009),ABS(0),
            SIGN(-2000), SIGN(0.0001), SIGN(0),
            SQRT(16), SQRT(87.99),
            POWER(2,10)
      FROM DUAL;
     2) GREATEST(n1,...nn), LEAST(((n1,...nn)
        .GREATEST(n1,...nn) : 주어진 수 n1 ~ nn 중 가장 큰 수 반환
        . LEAST(n1,...nn) :  주어진 수 n1 ~ nn 중 가장 작은 수 반환
(사용예)
        SELECT GREATEST('홍길동','이순신','홍길순'),  -- 이름이 뒤로 갈수록 큰 값
               GREATEST('APPLE','AMOLD',100),      -- 아스키코드로 변환후 
               LEAST('APPLE','AMOLD',100)
          FROM DUAL;
(사용예) 회원테이블에서 마일리지를 조회하여 1000보다 작은 값이면 1000을 부여하고
        1000보다 크면 원래의 값을 출력하시오.
        Alias는 회원번호,회원명,원본마일리지,변경마일리지
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               MEM_MILEAGE AS 원본마일리지,
               GREATEST(MEM_MILEAGE,1000) AS 변경마일리지 
               --1000이하의 마일리지는 1000으로 출력된다.
          FROM MEMBER;
         
     3)ROUND(n, 1), TRUNC(n, 1)
        . ROUND는 반올림, TRUNC는 자리버림을 수행
        . 1이 양수이면
        - ROUND(n, 1) : 주어진 수 n에서 소숫점 이하 1+1자리에서 반올림하여 1자리까지 반환
                        1이 생략되거나 0이면 소수 첫번째 자리에서 반올림하여 정수 반환
        - TRUNC(n, 1) : 주어진 수 n에서 소숫점 이하 1+1자리에서 자리버림
        . 1이 음수이면
        - ROUND(n, 1) : 주어진 수 n에서 정수부문 1자리에서 반올림하여 결과 반환
        - TRUNC(n, 1) : 주어진 수 n에서 정수부문 1자리에서 자리버림
       SELECT ROUND(321.153,1),
              ROUND(321.153,-3),  -- 음수면 정수자리에서 반올림이 발생된다
              ROUND(326.553,-1)
         FROM DUAL;
        
(사용예) 회원테이블에서 연령대별 마일리지합계와 회원수를 구하시오
        Alias는 연령대,회원수,마일리지합계
      /*  SELECT SUBSTR(MEM_REGNO1,1,2) AS 연령대,
               COUNT(*) AS 회원수,
               SUM(MEM_MILEAGE) AS 마일리지 합계
          FROM MEMBER
         GROUP BY SUBSTR(MEM_REGNO1,1,2); */
        (1) 나이계산
        SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('1','2') THEN 
        -- 주민번호 2번째 첫 번째에서 한글자  1과 2라면 => 1900년대 사람
                            EXTRACT(YEAR FROM SYSDATE) - 
                            -- 오늘날짜에서 년도를 뽑음(숫자로 취급되어진다)  에서 빼기
                            (1900 + TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))
                            -- 
                      ELSE  EXTRACT(YEAR FROM SYSDATE) -
                            
                            (2000 + TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))  
                            
                    END AS 나이
          FROM MEMBER;
        
        SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)
        --EXTRACT(YEAR FROM SYSDATE) 날짜타입에서 년도 뽑는다.    생년월일도 뽑음.
            FROM MEMBER;
        (2) 연령대로 변환
         SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) AS 나이,
                TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대
                -- 나이에서 1의 자리를 빼줌.
         FROM MEMBER;
         SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)  ||'대' AS 연령대,
                COUNT(*) AS 회원수,
                SUM(MEM_MILEAGE) AS 마일리지합계
           FROM MEMBER
          GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
          ORDER BY 1;
         
     4) FLOOR(n), CEIL(n) --
      - FLOOR(n) : n과 같거나(n이 정수인 경우) 작은 수 중 가장 큰 정수
      - CEIL(n) : n과 같거나(n이 정수인 경우) 큰 수 중 가장 작은 정수
 (사용예)        
        SELECT FLOOR(102.6777),FLOOR(102), FLOOR(-102.6777), -- -일때 -102.1 이라도 -103으로 표시..
               CEIL(102.6777), CEIL(102), CEIL(-102.6777)
          FROM DUAL;
          
     5) REMAINDER(n, m), MOD(n, m)  -- 주로 나머지를 구할 때 MOD를 사용
        - 주어진 수 n을 m으로 나눈 나머지를 반환
        - 내부적으로 구현 방법이 다름
        - MOD(n, m) : 일반적인 나머지를 반환
        - REMAINDER(n, m) : 나머지가 m의 절반값(0.5)를 초과하면 반환 값은 다음 몫이되기 
            위해 필요한 값의 음수이며, 그외는 MOD와 동일
        - 구현방법
            MOD       = n - m* FLOOR(n/m)
            REMAINDER = n - m* ROUND(n/m)
         ex) MOD(14, 5), REMAINDER(14,5)   
             MOD(14, 5)            = 14 - 5 * FLOOR(14/5)
                                   = 14 - 5 * FLOOR(2.8)
                                   = 14 - 5 * 2
                                   = 2
                                   
             REMAINDER(14,5)       = 14 - 5 * ROUND(14/5)
                                   = 14 - 5 * ROUND(2.8)
                                   = 14 - 5 * 3
                                   = -1
             MOD(14, 5), REMAINDER(14,5) 
            