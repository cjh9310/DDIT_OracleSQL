2022-0502-01) VIEW -- 
    - 테이블과 유사한 객체
    - 기존의 테이블이나 뷰에 대한 SELECT문의 결과 집합의 이름을 부여한 객체
    - 필요한 정보가 여러 테이블에 분산
    - 테이블의 모든 자료를 제공하지 않고 특정 결과만 제공하는 경우(보안)
    
(사용형식)
    CREATE [OR REPLACE] VIEW 뷰이름[(컬럼list)] 
    AS
        SELECT 문 --SELECT문애서 사용된 컬럼의 별칭이 뷰이름이 된다.
        [WITH READ ONLY]
        [WITH CHECK OPTION]
        
    . 'REPLACE' : 이미 존재하는 뷰인 경우 대체
    . 'WITH READ ONLY' : 읽기전용 뷰 생성 
    -- 1.실행하면 뷰를 사용할 수 없음.  2.원본테이블과는 상관X   3.원본테이블을 수정하면 뷰도 같이 수정이된다.
    -- 뷰가 바뀌어도 원본테이블이 바뀐다.(그것을 방지하기 위해 WITH READ ONLY를 사용)
    . 'WITH CHECK OPTION' : 뷰를 생성하는 SELECT문의 조건을 위배하는 DML명령을
        뷰에서 실행할때 오류 발생
        
    . '컬럼list' : 뷰에서 사용할 컬럼
    -- 뷰에서 컬럼명을 생략하면 
    -- 1. 원본 SELECT의 문의 별칭이 뷰의 컬럼명이 된다.
    -- 2. VIEW에서 컬럼명이 적용되었으면 뷰이름
    
사용예) 회원테이블에서 마일리지가 3000 이상인 회원의 
        회원번호,회원명,직업,마일리지로 구성된 뷰를 생성하시오.
1. 컬럼명에 별칭이 없을 때
    CREATE OR REPLACE VIEW V_MEM01 -- V_MEM01 뷰이름  , 컬럼명 생략하니 원본SELECT의 별칭이 적용됨.
    AS
        SELECT MEM_ID,     --별칭
               MEM_NAME,     --별칭
               MEM_JOB,        --별칭
               MEM_MILEAGE --별칭 
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000
    
2. 컬럼명에 별칭이 있을 때   
    CREATE OR REPLACE VIEW V_MEM01 (MID,MNAME,MJOB,MILE)
    AS
        SELECT MEM_ID, 
               MEM_NAME,   
               MEM_JOB,       
               MEM_MILEAGE 
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000    
    
사용예) 생성된 뷰(V_MEM01)에서 'C001'회원의 마일리지를 2500으로 변경
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MID = 'c001';
    -- 뷰를 수정하니 원본데이터도 변경
    SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_ID = 'g001';
    
    UPDATE MEMBER
       SET MEM_MILEAGE = 3800
     WHERE MEM_ID = 'g001';
    -- 원본을 수정하니 뷰도 변경
    
    SELECT * FROM V_MEM01;
    
    
사용예) 회원테이블에서 마일리지가 3000 이상인 회원의 
        회원번호,회원명,직업,마일리지로 구성된 뷰를 읽기전용으로 생성하시오.
    CREATE OR REPLACE VIEW V_MEM01
    AS
        SELECT MEM_ID,MEM_NAME,MEM_JOB,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000  
          WITH READ ONLY
    SELECT * FROM V_MEM01;
    
사용예) 생성된 뷰(V_MEM01)에서 'g001'회원(송경희)의 마일리지를 800으로 변경
    (뷰에서 변경.) -- 뷰에서 변경이 안된다.
    UPDATE V_MEM01
       SET MEM_MILEAGE =800
     WHERE MEM_ID = 'g001';
     -- 원본테이블에서는 얼마든지 변경 가능
     (원본테이블에서 변경)
     UPDATE MEMBER --원본테이블에서 변경이 된다.
       SET MEM_MILEAGE =800
     WHERE MEM_ID = 'g001';
    
     SELECT * FROM V_MEM01; -- 송경희가 800으로 바뀌어서 제외됨.
     
     
사용예) 회원테이블에서 마일리지가 3000 이상인 회원의 회원번호,회원명,직업,마일리지로 
        구성된 뷰를 WITH CHECK OPTION을 사용하여 생성하시오.
    CREATE OR REPLACE VIEW V_MEM01
    AS
        SELECT MEM_ID,MEM_NAME,MEM_JOB,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000  
          WITH CHECK OPTION;
          
    SELECT * FROM V_MEM01;     

사용예) 생성된 뷰에서 이혜나회원(e001)의 마일리지를 2500으로 변경하시오.
    UPDATE V_MEM01
       SET MEM_MILEAGE = 2500
     WHERE MEM_ID = 'e001';
     -- WITH CHECK OPTION을 사용해서 했기 때문에  
     -- 조건을 위배하면(3000보다 낮아서 뷰에서 제거가 될 경우)변경할 수 없다...
     
사용예) 신용환 회원('c001')마일리지를 MEMBER테이블에서 3500으로 변경
    UPDATE MEMBER
       SET MEM_MILEAGE = 3500
     WHERE MEM_ID ='c001';

사용예) 오철희 회원('k001')마일리지를 뷰에서 4700으로 변경
    UPDATE V_MEM01
       SET MEM_MILEAGE = 4700
     WHERE MEM_ID ='k001';     
     -- 조건을 위배하지 않아서 실행된다.

    UPDATE MEMBER
       SET MEM_MILEAGE = 2500
     WHERE MEM_ID ='k001';
     
    SELECT * FROM V_MEM01;        
     