2022-0413-01) 함수
    - 모든 사용자들이 공통의 목적으로 사용하도록 미리 프로그래밍되어
     컴파일한 후 실행 가능한 형태로 저장된 모듈
    -문자열, 숫자, 날짜, 형변환, 집계(그룹)함수가 제공
1. 문자열함수
    1)CONCAT(c1,c2)  --(매개변수,매개변수)  c = 문자열 / n=숫자 /d= date타입 / col =컬럼
     - 주어진 두 문자열 c1과 c2를 결합하여 새로운 문자열을 반환
     - 문자열 결합 연산자 '||'와 같은 기능
     
사용예) 회원테이블에서 2000년 이후 출생한 회원정보를 조회하시오
        Alias는 회원번호,회원명,주민번호,주소이다.
         주민번호는 XXXXXX-XXXXXXX형식으로 주소는 기본주소와 상세주소가 공백(' ') 하나를
         추가하여 연결할 것
        SELECT MEM_ID AS 회원번호,
               MEM_NAME AS 회원명,
               CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO2) AS 주민번호,
               MEM_ADD1||' '||MEM_ADD2 AS 주소
            FROM MEMBER
           WHERE SUBSTR(MEM_REGNO2,1,1) IN('3','4')
     -- CONCAT(c1,c2)은 잘 안쓰고 주로 '||'를 사용한다. (더 간편함)
        
    2) LOWER(c1), UPPER(c1), INITCAP(c1)   -- ' '로 묶이면 대소문자로 구분하게 된다. (아스키코드 값으로 사용할 수 있음)
        . LOWER(c1) : 주어진 문자열 c1의 문자를 모두 소문자로 변환
        . UPPER(c1) : 주어진 문자열 c1의 문자를 모두 대문자로 변환
        . INITCAP(c1) : c1 내의 문자 중 단어의 첫 문자만 대문자로 변환
        -- 한글에서는 전혀 쓸모 없는 함수이다.(대 소문자 구분이 없음)
사용예) 회원테이블에서 회원번호 'F001' 회원정보를 조회하시오
        Alias는 회원번호,회원명,주소,마일리지이다.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '||MEM_ADD2 AS 주소,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE UPPER(MEM_ID) = 'F001';  -- 소문자 f001은 존재함.
    -- WHERE MEM_ID = 'F001'; 못찾음
     
     SELECT EMPLOYEE_ID, 
            LOWER(FIRST_NAME)||' '||UPPER(LAST_NAME),
            LOWER(FIRST_NAME)||' '||(LAST_NAME),
            INITCAP(LOWER(FIRST_NAME||' '||LAST_NAME)),
            EMP_NAME
       FROM HR.employees;
     
    3) LPAD(c1,n[,c2]), RPAD(c1,n[,c2]) -- n = 바이트같은 것
        .LPAD(c1,n[,c2]) : n자리에 주어진 문자열 c1을 채우고 남는 왼쪽공간에
            c2 문자열을 채움, c2가 생략되면 공백이 채워짐
        .RPAD(c1,n[,c2]) : n자리에 주어진 문자열 c1을 채우고 남는 오른쪽공간에
            c2 문자열을 채움, c2가 생략되면 공백이 채워짐

사용예) 
        SELECT '1,000,000',
                LPAD('1000000',15,'*'),
                RPAD('1,000,000',15,'-')
         FROM DUAL;
        
        SELECT A.CART_PROD,
               B.PROD_NAME,
               SUM(A.CART_QTY*B.PROD_PRICE)
          FROM CART A, PROD B
         WHERE A.CART_PROD = B.FROD_ID
           AND A.CART_NO LIKE '20207%'
        GROUP BY 
사용예) 기간(년과 월)을 입력 받아 매출액 기준 상위 5개 재품의 매출집계를 구하는 
        프로시져를 작성하시오
        CREATE OF REPLACE PROCEDURE PROC_CALCULATE(
        P_PERIOD VARCHAR2)
    IS
        CURSOR CUR_TOP5 IS    --CURSOR 매출액 중 상위5개를 뽑기위해.
        SELECT TA.CID AS  TID, TA.CSUM AS TSUM
          FROM SELECT CART_PROD AS CID,
                SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM
                FROM CART A, PROD B
               WHERE A.CART_PROD=B.PROD_ID
                 AND A.CART_NO LIKE P_PERIOD ||'%'
                 GROUP BY A.CART_PROD
                 ORDER BY 2 DESC) TA
        WHERE ROWNUM<=5;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_RES VARCHAR2(100);
   BEGIN -- 제품 이름을 꺼내서
        FOR REC IN CUR_TOP5 LOOP 
            SELECT PROD_NAME INTO V_PNAME --  V_PNAME이라는 기억장소에 저장
              FROM PROD
             WHERE PROD_ID=REC.TID;
            V_RES:=REC.TID||' '||RPAD(V_PNAME,35)||TO_CHAR(REC.TSUM,'99,999,999'); 
            -- 칸을 맞춰 보기좋게 출력할려고.(정렬)
            DBMS_OUTPUT.PUT_LINE(V_RES);
        END LOOP;    
    END;
    EXECUTE PROC_CALCULATE('202007');
    
    4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2]) -- 특정 문자나 문자열을 찾아서 지우기 위해 
        - LTRIM(c1 [,c2]) : c1 문자열에서 왼쪽 시작위치에서 c2문자열을 찾아
        같은 문자열이 있으면 삭제, c2가 생략되면 왼쪽 공백을 제거 
        - RTRIM(c1 [,c2]) : c1 문자열에서 오른쪽 시작위치에서 c2문자열을 찾아
        같은 문자열이 있으면 삭제, c2가 생략되면 오른쪽 공백을 제거 
        -- 컴파일할 때 공간 바이트를 초과해도 공백을 빼고 저장이 되어서????????? 
    
(사용예)
        SELECT LTRIM('PERSIMMON BANNA APPLE','ER'), -- 왼쪽에서 부터 지우기 시작.
               LTRIM('PERSIMMON BANNA APPLE','PE'),
               LTRIM('   PERSIMMON BANNA APPLE')
          FROM DUAL;
          
    SELECT RTRIM('...ORACLE...','.'), -- 오른쪽에서 부터 지우기 시작.
           RTRIM('...OR...OR...','OR...'), -- OR...OR... 두번 지우고 
           RTRIM('...      ') AS 'C' --오른쪽 공백이 다 지워짐.(제목때문에 그렇게 보이는 것)
           -- ...은 OR...에서 같은 것이 있으니 ...까지 다 지울 수 있다.  결국 다 지워서 null이 뜸
      FROM DUAL;
    
    5) TRIM(c1) --무효(문자 시작전 혹은 후에 있는 공백)의 공백을 제거
                --유효(문자 내부에 있는 공백) REPLACE로 제거 가능
     - c1문자열 왼쪽과 오른쪽에 있는 모든 공백을 제거
     - 다만 문자열 내부의 공백은 제거하지 못함(REPLACE로 제거)
(사용예)
        SELECT TRIM('     QWER     '),
               TRIM('  무궁화 꽃이 피었습니다!!    ')
          FROM DUAL;

(사용예) 오늘이 2020년 4월 1일이라고 할때 장바구니테이블의 -- 복습할려면 컴퓨터 날짜를 2020년 4월 1일로 바꾸고 해야함.
        장바구니번호(CART_NO)를 생성하시오.
    1-1.SELECT SUBSTR(CART_NO,9)   --(CART_NO,9번째글자부터,나머지 다[생략])
          FROM CART
         WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD') ||'%';
         --CART_NO는 SYSDATE(오늘날짜)와 같다.
    1-2.      
          SELECT MAX(TO_NUMBER(SUBSTR(CART_NO,9))) +1
          -- TO_NUMBER로 숫자로 바꿔줬음. / MAX로 가장 큰 숫자 찾음.
          FROM CART
         WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD') ||'%';
     1-3.    
         SELECT TO_CHAR(SYSDATE,'YYYYMMDD') ||
         TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO,9))) +1, '00000'))
        --  년도포함.    /  가장 큰 숫자 +1 +'00000'  / TRIM으로 20200401 과 000004 사이 공백 제거.
          FROM CART
         WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD') ||'%';
         
         2번 방법. 
         SELECT MAX(CART_NO)+1  -- TO_CHAR(문자)가 숫자로 바뀌어서 자동으로 계산이 된다)
          FROM CART
         WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD') ||'%';
        
    (6) SUBSTR(c,m[,n])  -- 문자열 함수가 많이 쓰는편은 아닌데 그중 가장 많이쓰임...
        - 주어진 문자열 c에서 m번째에서 n개의 문자열을 추출하여 반환
        - n이 생략되면 m번째 이후의 모든 문자열을 추출하여 반환
        - m은 1부터 시작함(0이 기술되면 1로 간주)
        - m이 음수이면 오른쪽부터 처리됨. 
        - n보다 남은 문자의 수가 작은 경우 n이 생략된 경우와 동일
(사용예)
        SELECT SUBSTR('나보기가 역겨워 가실때에는',5,6) AS COL1,
               SUBSTR('나보기가 역겨워 가실때에는',5) AS COL2, -- n생략
               SUBSTR('나보기가 역겨워 가실때에는',0,6) AS COL3,
               SUBSTR('나보기가 역겨워 가실때에는',5,30) AS COL4,
               SUBSTR('나보기가 역겨워 가실때에는',-5,6) AS COL5 -- 
          FROM DUAL;
          
사용예) 회원테이블에서 거주지별 회원수를 조회하시오.
        Alias는 거주지, 회원수이다.
        SELECT  SUBSTR(MEM_ADD1,1,2) AS 거주지,  --주소지 앞 두 글자를 따옴
                COUNT(*) AS 회원수  
          FROM MEMBER
         GROUP BY SUBSTR(MEM_ADD1,1,2); --카운트를 써서 GROUP이 필요
     
    7) REPLACE(c1,c2[,c3])
     - 문자열 c1에서 c2문자열을 찾아 c3문자열로 치환
     - c3문자열이 생략되면 찾은 c2문자열을 삭제함
     - c3가 생략되고 c2를 공백으로 기술하면 단어 내부의 공백을 제거함.
(사용예)
        SELECT MEM_NAME,
               REPLACE(MEM_NAME, '이','리')   -- '이' 를 '리'로 치환한다.
               FROM MEMBER;
        SELECT PROD_NAME,
               REPLACE(PROD_NAME,'삼보','SAMBO'),  -- 치환
               REPLACE(PROD_NAME,'삼보'),          -- 삼보제거
               REPLACE(PROD_NAME,' ')              -- 공백제거
          FROM PROD;
(사용예) 회원테이블에서 '대전'에 거주하는 회원들의 기본주소의 광역시명칭을 
        모두 '대전광역시'로 통일시키시오.
        SELECT  MEM_NAME AS 회원번호,
                MEM_ADD1 AS 원본주소,
               CASE WHEN SUBSTR(MEM_ADD1,1,3)='대전시' THEN
                         REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,3),'대전광역시')
                    WHEN SUBSTR(MEM_ADD1,1,5) != '대전광역시' THEN
                         REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,2),'대전광역시')
                    ELSE
                         MEM_ADD1
                    END AS  기본주소
                    
             --  REPLACE (MEM_ADD1,'대전시|대전','대전광역시') 오류
          FROM MEMBER
          WHERE MEM_ADD1 LIKE '대전%';
          
          /* SELECT REGEXP_REPLACE('대전시,대전광역시,대전','대전시|대전','대전광역시')
            FROM DUAL; */  한 문장만 여러개 바꿀 수 있음.
          
    (8) INSTR(c1,c2[,m[,n]])
     - 주어진 c1문자열에서 c2문자열이 처음 나온 위치를 반환
     - m은 시작위치를 나타내며
     - n은 반복나타낸 횟수
(사용예)
    SELECT INSTR('APPLEBANANAPERSIMMON','L') AS COL1,
           INSTR('APPLEBANANAPERSIMMON','A',3) AS COL1, 
           INSTR('APPLEBANANAPERSIMMON','A',3,2) AS COL1,
           INSTR('APPLEBANANAPERSIMMON','A',-3) AS COL1, 
           INSTR('APPLEBANANAPERSIMMON','A',-3,2) AS COL1
      FROM DUAL;

    (9) LENGTHB(c1), LENGTH(c1)
     - 주어진 문자열의 길이를 BYTE수로(LENGTHB), 글자수로(LENGTH)로 반환
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     