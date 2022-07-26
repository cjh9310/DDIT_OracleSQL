2022-0411-02) 데이터 검색문(SELECT 문)
- SQL명령 중 가장 많이 사용되는 명령
- 자료 검색을 위한 명령
(사용형식)
    SELECT *|[DISTINCT]컬럼명 [AS 별칭] [,] 
            컬럼명 [AS 별칭] [,]  -- 별칭에 특수문자를 사용하거나 명령문과 같은 별칭을 쓰려면 쌍따옴표로 묶어줘야한다.
                    :           -- 
            컬럼명 [AS 별칭]
        FROM 테이블명 --테이블OR뷰
        [WHERE 조건]  -- WHERE 행을 제어..   전부 다 출력하고 싶으면 WHERE 빼고.
        [GROUP BY 컬럼명[,컬럼명,...]] 
        [HAVING 조건]
        [ORDER BY 컬럼인덱스|컬럼명 [ASC|DESC][,컬럼인덱스|컬럼명 [ASC|DESC],...]];
    -- ORDER BY : 정렬(순서) ASC(오름차순) , DESC(내림차순) 
    --사용자가 ASC혹은DESC를 설정하지 않으면 자동으로 ASC가 적용된다.
    
사용예) 회원테이블에서 회원번호, 회원명, 주소를 조회하시오.  --주소는 기본주소 상세주소로 2가지...
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '|| MEM_ADD2 AS "주  소" -- || +취급.
        FROM MEMBER;
        
    
사용예) 회원테이블에서 '대전'에 거주하는 회원번호, 회원명, 주소를 조회하시오.
        SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '|| MEM_ADD2 AS "주  소" -- || +취급.
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%'; -- '%'= 뒤에 뭐가 오든 상관없다..
        
 사용예) 회원테이블에서 '대전'에 거주하는 여성회원의
                                        회원번호, 회원명, 주소를 조회하시오.       
        SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '|| MEM_ADD2 AS "주  소" -- || +취급.
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%'
            AND SUBSTR(MEM_REGNO2,1,1) IN('2','4'); --SUBSTR 부분 문자열 추출
        -- (MEM_REGNO2,1,1) 첫번째 글자에서 하나만.. 
        -- IN('2','4') 2 or 4 추출
        
        
        
        
        
        
        
        
        
        