2022-0428-01) SUBQUERY와 DML명령
1. INSERT 문에서 서브쿼리 사용   
    - INSERT INTO 문에 서브쿼리를 사용하면 VALUES절이 생략됨
    - 사용되는 서브쿼리는 '( )'를 생략하고 기술함.
DELETE FROM REMAIN;
COMMIT;

(사용형식)
    INSERT INTO 테이블명[(컬럼명[,컬럼명,...])]
        서브쿼리;
    - '테이블명( )'에 기술된 컬럼의 갯수,순서,타입과 서브쿼리 SELECT문의
       SELECT절의 컬럼의 갯수,순서,타입은 반드시 일치해야함
사용예) 재고수불테이블의 년도애는 '2020'울 상품코드애서 상품테이블의 모든 상품코드를 입력하시오.
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
     SELECT '2020',PROD_ID
       FROM PROD;
    SELECT * FROM REMAIN;
    
2. UPDATE 문에서 서브쿼리 사용
    (사용형식)
    UPDATE 테이블명 [별칭]
       SET (컬럼명[,컬럼명,...]) = (서브쿼리)
    [WHERE 조건]; -- 테이블에서 변경할 조건
    
사용예) 재고수불테이블(REMAIN)에 기초재고를 설정하시오.
       기초재고는 상품테이블의 적정재고량으로 하며 날짜는 2020년1월1일로 설정
       
    UPDATE REMAIN A
       SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE) =  
           (SELECT A.REMAIN_J_00+B.PROD_PROPERSTOCK,--차례대로 값을 넣어주는 것.
                   A.REMAIN_J_99+B.PROD_PROPERSTOCK,--차례대로 값을 넣어주는 것.
                   TO_DATE('20200101')              --차례대로 값을 넣어주는 것.
              FROM PROD B
             WHERE A.PROD_ID = B.PROD_ID) -- 서브쿼리는 변경시킬 값을 설정하는 조건
     WHERE A.REMAIN_YEAR ='2020';    
     
사용예) 2020년 1월 제품별 매입수량을 조회하여 재고수불테이블을 변경하시오.
       REMAIN_I(입고량) REMAIN_O(출고량) REMAIN_J_00(기초재고량) REMAIN_J_99(기말재고량)  REMAIN_DATE (날짜)
       -- 기초재고량은 처음에 한 번 쓰고 변동없음  그 후는 전부 기말재고량에 저장
    UPDATE REMAIN A 
       SET (A.REMAIN_I,A.REMAIN_J_99,A.REMAIN_DATE) = -- SET: UPDATE 테이블에서 변경될 자료를 추출함.
           (SELECT A.REMAIN_I + BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200430')
           -- REMAIN과 같은 코드에 +수량을 더해주는 것.
           -- 기말재고에 새롭게 입고된 수량을 추가함
           -- 2월1일까지 
            FROM (SELECT BUY_PROD AS BID,
                         SUM(BUY_QTY) AS BSUM
                         FROM BUYPROD
                         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430')
                         GROUP BY BUY_PROD) B 
            WHERE A.PROD_ID = B.BID)   --변경할 값을 적용
     WHERE A.REMAIN_YEAR ='2020'    -- 변경할 자료를 추출
       AND A.PROD_ID IN (SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430'));
     SELECT*FROM REMAIN;
     COMMIT;
(서브쿼리1: 2020년 1월 제품별 매입수량)
    SELECT BUY_PROD,
            SUM(BUY_QTY)
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
      GROUP BY BUY_PROD;
      
(서브쿼리2: 2020년 1월 매입상품 조회)
    SELECT DISTINCT BUY_PROD
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
     
     
사용예) 2020년 4월 장바구니테이블에서 판매수량을 조회하여 재고수불테이블을 갱신하시오.
    SELECT CART_NO
      FROM CART
     WHERE SUBSTR(CART_NO,1,8) BETWEEN'20200401' AND '20200430'
     ORDER BY 1;
   UPDATE REMAIN A 
       SET (A.REMAIN_O,A.REMAIN_J_99,A.REMAIN_DATE) = 
           (SELECT A.REMAIN_O + CSUM,A.REMAIN_J_99-B.CSUM,TO_DATE('20200430') -- 매출이라 마이너스(-) 4월달 매출 빼기
            FROM (SELECT CART_PROD AS CID,
                         SUM(CART_QTY) AS CSUM
                         FROM CART
                         WHERE SUBSTR(CART_NO,1,8) BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
                         GROUP BY CART_PROD) B 
            WHERE A.PROD_ID = B.CID) 
     WHERE A.REMAIN_YEAR ='2020' 
       AND A.PROD_ID IN (SELECT DISTINCT CART_PROD
                           FROM CART
                          WHERE SUBSTR(CART_NO,1,8) BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'));    
     
     SELECT * FROM REMAIN;
     ROLLBACK;
     
**재고갱신을 위한 트리거
    - 입고발생시 자동으로 재고조정


CREATE OR REPLACE TRIGGER TG_INPUT
    AFTER INSERT ON BUYPROD
    FOR EACH ROW
DECLARE
    V_QTY NUMBER:=0;
    V_PROD PROD.PROD_ID%TYPE; --V_PROD(참조형 변수)  PROD.PROD_ID와 같은 타입으로 변수선언
    V_DATE DATE:=(:NEW.BUY_DATE);  -- 초기화(초기값 지정)
BEGIN
    V_QTY:=(:NEW.BUY_QTY);  -- :NEW.컬럼명  새롭게 들어온 자료
    V_PROD:=(:NEW.BUY_PROD); -- 
    
    UPDATE REMAIN A
       SET A.REMAIN_I=A.REMAIN_I+V_QTY,
           A.REMAIN_J_99=A.REMAIN_J_99+V_QTY,
           A.REMAIN_DATE= V_DATE
     WHERE A.PROD_ID= V_PROD;
     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('예외발생 : ' || SQLERRM);
END;
     
** 상품코드 'P101000001' 상품 50개를 오늘날짜에 매입하세요.
            (매입단가는 210000원)
    재고상황            기초 매입 매출 현재
    2020	P101000001	33	38	5	66	2020/04/30

    INSERT INTO BUYPROD
        VALUES(SYSDATE,'P101000001',50,210000);
        
    SELECT *FROM REMAIN;
    
    
**서브쿼리를 이용한 테이블생성
    - CREATE TABLE 명령과 서브쿼리를 사용하여 테이블을 생성하고 
      해당되는 값을 복사할 수 있음.
    - 제약사항은 복사(생성)되지 않는다.
    (사용형식)
    CREATE TABLE 테이블명[(컬럼명[,컬럼명,...])]
     AS (서브쿼리);
사용예) 재고수불테이블의 모든 데이터를 포함하여 새로운테이블을 
       생성하시오. 테이블명은 TEMP_REMAIN이다.
       
    CREATE TABLE TEMP_REMAIN AS 
        (SELECT * FROM REMAIN);
        
    SELECT*FROM TEMP_REMAIN;
    
3. DELETE 문에서 서브쿼리 사용 -- 행단위로 지운다.  / 복구 불가능  
    ** DELETE문의 사용형식
       DELETE FROM 테이블명
        [WHERE 조건]; 
        
사용예) TEMP_REMAIN테이블에서 2020년 7월 판매된 상품과 같은 코드의
       자료를 삭제하시오.
(서브쿼리) 2020년 7월에 판매된 상품
       SELECT DELETE CART_PROD
         FROM CART
        WHERE CART_NO LIKE '202007%'
        
결과)
    
    DELETE FROM TEMP_REMAIN A
     WHERE REMAIN_YEAR='2020'
       AND A.PROD_ID IN(SELECT DISTINCT CART_PROD
                          FROM CART
                         WHERE CART_NO LIKE '202007%');