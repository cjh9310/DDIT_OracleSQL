2022-0407-01) 
1. DML 명령
 1). 테이블 생성명령(CREATE TABLE)
  - 오라클에서 사용될 테이블을 생성
  (사용형식)
  CREATE TABLE 테이블명 ( 
  컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,]
                    : 
  컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,]
  
  [CONSTRAINT 기본키인덱스명 PRIMARY KEY (컬럼명[, 컬렴명, .....]) [,]]
  [CONSTRAINT 외래키인덱스명 FOREIGN KEY (컬럼명[, 컬렴명, .....])
    REFERENCES 테이블명 (컬럼명[, 컬렴명, .....]) [,]]
  [CONSTRAINT 외래키인덱스명 FOREIGN KEY (컬럼명[, 컬렴명, .....])
    REFERENCES 테이블명 (컬럼명[, 컬렴명, .....])]);   // 여기까지 암기하기
    '테이블명', 컬럼명, 인뎃명 : 사용자정의단어를 사용  (영어로 알아서 만들어 써라)
    'NOT NULL'이 기술된 컬럼은 데이터 삽입시 생략 불가능
    'DEFAULT 값' : 사용자가 데이터를 입력하지 않은 경우 자동으로 삽입되는 값
   ★'기본키인덱스명', '외래키인덱스명', '테이블명'은 중복되어서는 안된다.
    '테이블명 (컬럼명[, 컬렴명, .....])])' : 부모테이블명 및 부모테이블에서 사용된 컬럼명
    
    
    사용 예) 테이블명세1의 테이블들을 생성하시오.
    
    CREATE TABLE GOODS (
    GOOD_ID CHAR(4) NOT NULL,  -- 기본키   (낫 널은 안써도 상관없다.)
    GOOD_NAME VARCHAR2(50),    -- 자바는 ; 오라클은 , 로 넘어가는 듯
    PRICE NUMBER(8),
    CONSTRAINT pk_goods PRIMARY KEY(GOOD_ID));
    
    CREATE TABLE CUSTS (
    CUST_ID CHAR(4),
    CUST_NAME VARCHAR2(50),
    ADDRESS VARCHAR2(100),
    CONSTRAINT pk_custs PRIMARY KEY(CUST_ID));
    
    CREATE TABLE ORDERS(
        ORDER_ID CHAR(11), -- 추가
        ORDER_DATE DATE DEFAULT SYSDATE, -- 추가 , SYSDATE 지금 날짜가 들어간다.
        CUST_ID CHAR(4), -- 가져옴
        ORDER_AMT NUMBER(10) DEFAULT 0, -- 추가
        CONSTRAINT pk_order PRIMARY KEY(ORDER_ID), -- 기준키
        CONSTRAINT fk_order_cust FOREIGN KEY(CUST_ID)   --외래키  , 콤마 X
         REFERENCES CUSTS(CUST_ID)
);
    CREATE TABLE GOOD_ORDERS ( 
        ORDER_ID CHAR(11),  --  가져옴
        GOOD_ID CHAR(4),    --  가져옴
        ORDER_QTY NUMBER(3), -- 추가
        CONSTRAINT pk_gord PRIMARY KEY(ORDER_ID,GOOD_ID),  -- 기준키
        CONSTRAINT fk_gord_order FOREIGN KEY(ORDER_ID) -- 외래키
        REFERENCES ORDERS(ORDER_ID),
        CONSTRAINT fk_gord_goods FOREIGN KEY(GOOD_ID) -- 외래키
        REFERENCES GOODS(GOOD_ID));
    -- 직접 추가해서 기준키로 설정할 수 있고, 가져와서 그것을 기준키로 설정할 수 있다.
    -- 가져온 것은 부모를 가져온 것이다.
    
2. INSERT 명령 -- 없는 것은 INSERT INTO 할 수 있음
              -- 있는 것은 업데이트 제거할 때 나올 수 있다.
 - 생성된 테이블에 새로운 자료를 입력
  (사용형식)
  INSERT INTO 테이블명[(컬럼명[,컬럼명,...])]
    VALUES(값1[,값2,...]); --위에 컬럼명의 순서에 맞춰 값1, 값2 가 순서대로 입력되어야함
    
    '테이블명[(컬럼명[,컬럼명,...])]': '컬럼명'이 생략되고 테이블명만 기술되면 테이블의
    모든 컬럼에 입력될 데이터를 순서에 맞추어 기술해야함 (갯수 및 순서 일치)
    '(컬럼명[,컬럼명,...])' : 입력할 데이터에 해당하는 컬럼만 기술, 단 , NOT NULL(NO) 컬럼은 
    생략 할 수 없음. -- 테이블명이 생략되고 컬럼명만 기록된 경우
    -- NOT NULL은 널을 사용하지 않는다인데 입력하지 않으면 NULL이 자동으로 들어가므로
    -- NOT NULL을 써야함....  (맞냐?)
    
    
    EX) 다음 자료를 GOODS 테이블에 저장하시오 --GOODS 테이블에 NULLABLE 하나가 NO로 되어있음
    
        상품코드    상품명     가격
        --------------------------
        P101      볼펜        500
        P102      마우스      15000
        P103      연필        300
        P104      지우개      1000
        P201      A4용지      7000
        

    INSERT INTO GOODS VALUES('P101','볼펜',500);
    INSERT INTO GOODS(good_id, GOOD_NAME)
        VALUES('P102','마우스');  --15000을 안넣으니 NULL이 나옴
   INSERT INTO GOODS(good_id, GOOD_NAME, PRICE)
        VALUES ('P103','연필',300);
        
    SELECT * FROM GOODS; 
    -- 결과확인 CTRL +ENTER
    EX) 고객테이블(CUSTS)에 다음자료를 입력하시오
    
        고객번호    고객명     주소
        -------------------------------
        a001      홍길동     대전시 중구 계롱로846
        a002      이인수     서울시 성북구 장위1동 66
        
        INSERT INTO CUSTS VALUES('a001','홍길동','대전시 중구 계롱로 846');
        INSERT INTO CUSTS (CUST_ID, ADDRESS) VALUES('a002','서울시 성북구 장위1동 66');
        
        SELECT * FROM CUSTS;
    
    EX) 오늘 홍길동 고객이 로그인 했을 경우 주문테이블에 해당 사항을 입력하시오.
        -- 테이블에 ORDERS 보면서 참고할 것 
        INSERT INTO ORDERS(ORDER_ID,CUST_ID)-- 두 가지만 활용 로그인, 주문 테이블
        -- 나머지는 디폴트 값이여도 문제없음.
        
    VALUES('20220407001','a001');
    -- 두 개만 입력했는데 4개가 입력되었다.
    -- ORDER_DATE는 오늘 날짜    ,ORDER_AMT는??
    SELECT * FROM ORDERS;
    
    
  --  SELECT CASE WHEN ORDER_ID IS NULL THEN
   --                         TO_CHAR(SYSDATE,'YYYYMMDD')||'001'
    --          ELSE
    --                        MAX(TO_NUMBER (ORDER_ID))+1 
   --          END
  --      FROM ORDERS
    
    EX) 오늘 홍길동 고객이 다음과 같이 구매했을 떄 구매상품테이블(GOOD_ORDERS)
    에 자료를 저장하시오.
    
        구매번호      상품번호     수량
    -----------------------------------
       20220407001   P101         5
       20220407001   P102         10
       20220407001   P103         2
    
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P101',5);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P102',10);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P103',2);
    
    UPDATE GOODS   -- GOODS 테이블에 마우스가 NULL로 되어있는걸 수정해야함.
        SET PRICE = 15000
        WHERE GOOD_ID = 'P102';
        -- 구매함.
        UPDATE ORDERS -- 가격계산(업데이트)
          set  ORDER_AMT =ORDER_AMT+(SELECT ORDER_QTY*PRICE -- 먼저 있던 값 + 가격 * 수량 볼펜500원짜리 5개
                            FROM GOOD_ORDERS A, GOODS B
                            WHERE A.GOOD_ID=B.GOOD_ID --GOOD_ORDERS 안에 굿 아이디
                            AND ORDER_ID = '20220407001'
                            AND A.GOOD_ID='P103')
        WHERE ORDER_ID='20220407001';
        SELECT * FROM ORDERS;
        SELECT * FROM GOOD_ORDERS; -- WHERE이 없으므로 GOOD_ORDERS에 있는 모든 행을 출력하라는 뜻이다.
        UPDATE ORDERS
            SET ORDER_AMT =0;
        
3. UPDATE 명령

    - 이미 테이블에 존재하는 자료를 수정할 때 사용된다.
    (사용형식)
    UPDATE 테이블명
        SET 컬럼명 = 값[,]
                :
            컬럼명 = 값
    [WHERE 조건]; -- WHERE 절이 없으면 모든 행을 다 변경하므로 필수로 따라와야 한다.
    
    SELECT PROD_NAME AS 상품명,
           PROD_COST AS 매입단가
        FROM PROD;    --PROD에 들어있는 것 중에 상품명, 매입단가라고 표시되어 있는 것을 모두 출력하시오.
        
        
--    UPDATE PROD 
--        SET PROD_COST = 500000;   
--        -- 가격 수정하기.  WHERE조건을 추가 안하면 전부 다 50만으로 바꿔진다.
--    UPDATE PROD 
--        SET PROD_COST = PROD_COST + ROUND(PROD_COST * 0.1); 
--        --가격이 10퍼센트 오르고 소수점을 없애줄려면 ROUND가 있어야함
--    ROLLBACK;   -- (UPDATE)명령 취소.
사용예시) 상품테이블에서 분류코드가 'P101'에 속한 상품의 매입가격을 10% 인상하시오.
        UPDATE PROD 
            SET PROD_COST = PROD_COST + ROUND(PROD_COST * 0.1)
        WHERE PROD_LGU = 'P101';  -- 조건 설정    LGU=분류코드.
        
    
     
        
        
        