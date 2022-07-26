2022-0428-01) SUBQUERY�� DML���
1. INSERT ������ �������� ���   
    - INSERT INTO ���� ���������� ����ϸ� VALUES���� ������
    - ���Ǵ� ���������� '( )'�� �����ϰ� �����.
DELETE FROM REMAIN;
COMMIT;

(�������)
    INSERT INTO ���̺��[(�÷���[,�÷���,...])]
        ��������;
    - '���̺��( )'�� ����� �÷��� ����,����,Ÿ�԰� �������� SELECT����
       SELECT���� �÷��� ����,����,Ÿ���� �ݵ�� ��ġ�ؾ���
��뿹) ���������̺��� �⵵�ִ� '2020'�� ��ǰ�ڵ�ּ� ��ǰ���̺��� ��� ��ǰ�ڵ带 �Է��Ͻÿ�.
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
     SELECT '2020',PROD_ID
       FROM PROD;
    SELECT * FROM REMAIN;
    
2. UPDATE ������ �������� ���
    (�������)
    UPDATE ���̺�� [��Ī]
       SET (�÷���[,�÷���,...]) = (��������)
    [WHERE ����]; -- ���̺��� ������ ����
    
��뿹) ���������̺�(REMAIN)�� ������� �����Ͻÿ�.
       �������� ��ǰ���̺��� ����������� �ϸ� ��¥�� 2020��1��1�Ϸ� ����
       
    UPDATE REMAIN A
       SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE) =  
           (SELECT A.REMAIN_J_00+B.PROD_PROPERSTOCK,--���ʴ�� ���� �־��ִ� ��.
                   A.REMAIN_J_99+B.PROD_PROPERSTOCK,--���ʴ�� ���� �־��ִ� ��.
                   TO_DATE('20200101')              --���ʴ�� ���� �־��ִ� ��.
              FROM PROD B
             WHERE A.PROD_ID = B.PROD_ID) -- ���������� �����ų ���� �����ϴ� ����
     WHERE A.REMAIN_YEAR ='2020';    
     
��뿹) 2020�� 1�� ��ǰ�� ���Լ����� ��ȸ�Ͽ� ���������̺��� �����Ͻÿ�.
       REMAIN_I(�԰�) REMAIN_O(���) REMAIN_J_00(�������) REMAIN_J_99(�⸻���)  REMAIN_DATE (��¥)
       -- ��������� ó���� �� �� ���� ��������  �� �Ĵ� ���� �⸻����� ����
    UPDATE REMAIN A 
       SET (A.REMAIN_I,A.REMAIN_J_99,A.REMAIN_DATE) = -- SET: UPDATE ���̺��� ����� �ڷḦ ������.
           (SELECT A.REMAIN_I + BSUM,A.REMAIN_J_99+B.BSUM,TO_DATE('20200430')
           -- REMAIN�� ���� �ڵ忡 +������ �����ִ� ��.
           -- �⸻��� ���Ӱ� �԰�� ������ �߰���
           -- 2��1�ϱ��� 
            FROM (SELECT BUY_PROD AS BID,
                         SUM(BUY_QTY) AS BSUM
                         FROM BUYPROD
                         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430')
                         GROUP BY BUY_PROD) B 
            WHERE A.PROD_ID = B.BID)   --������ ���� ����
     WHERE A.REMAIN_YEAR ='2020'    -- ������ �ڷḦ ����
       AND A.PROD_ID IN (SELECT DISTINCT BUY_PROD
                           FROM BUYPROD
                          WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND TO_DATE('20200430'));
     SELECT*FROM REMAIN;
     COMMIT;
(��������1: 2020�� 1�� ��ǰ�� ���Լ���)
    SELECT BUY_PROD,
            SUM(BUY_QTY)
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
      GROUP BY BUY_PROD;
      
(��������2: 2020�� 1�� ���Ի�ǰ ��ȸ)
    SELECT DISTINCT BUY_PROD
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
     
     
��뿹) 2020�� 4�� ��ٱ������̺��� �Ǹż����� ��ȸ�Ͽ� ���������̺��� �����Ͻÿ�.
    SELECT CART_NO
      FROM CART
     WHERE SUBSTR(CART_NO,1,8) BETWEEN'20200401' AND '20200430'
     ORDER BY 1;
   UPDATE REMAIN A 
       SET (A.REMAIN_O,A.REMAIN_J_99,A.REMAIN_DATE) = 
           (SELECT A.REMAIN_O + CSUM,A.REMAIN_J_99-B.CSUM,TO_DATE('20200430') -- �����̶� ���̳ʽ�(-) 4���� ���� ����
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
     
**������� ���� Ʈ����
    - �԰�߻��� �ڵ����� �������


CREATE OR REPLACE TRIGGER TG_INPUT
    AFTER INSERT ON BUYPROD
    FOR EACH ROW
DECLARE
    V_QTY NUMBER:=0;
    V_PROD PROD.PROD_ID%TYPE; --V_PROD(������ ����)  PROD.PROD_ID�� ���� Ÿ������ ��������
    V_DATE DATE:=(:NEW.BUY_DATE);  -- �ʱ�ȭ(�ʱⰪ ����)
BEGIN
    V_QTY:=(:NEW.BUY_QTY);  -- :NEW.�÷���  ���Ӱ� ���� �ڷ�
    V_PROD:=(:NEW.BUY_PROD); -- 
    
    UPDATE REMAIN A
       SET A.REMAIN_I=A.REMAIN_I+V_QTY,
           A.REMAIN_J_99=A.REMAIN_J_99+V_QTY,
           A.REMAIN_DATE= V_DATE
     WHERE A.PROD_ID= V_PROD;
     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('���ܹ߻� : ' || SQLERRM);
END;
     
** ��ǰ�ڵ� 'P101000001' ��ǰ 50���� ���ó�¥�� �����ϼ���.
            (���Դܰ��� 210000��)
    ����Ȳ            ���� ���� ���� ����
    2020	P101000001	33	38	5	66	2020/04/30

    INSERT INTO BUYPROD
        VALUES(SYSDATE,'P101000001',50,210000);
        
    SELECT *FROM REMAIN;
    
    
**���������� �̿��� ���̺����
    - CREATE TABLE ��ɰ� ���������� ����Ͽ� ���̺��� �����ϰ� 
      �ش�Ǵ� ���� ������ �� ����.
    - ��������� ����(����)���� �ʴ´�.
    (�������)
    CREATE TABLE ���̺��[(�÷���[,�÷���,...])]
     AS (��������);
��뿹) ���������̺��� ��� �����͸� �����Ͽ� ���ο����̺��� 
       �����Ͻÿ�. ���̺���� TEMP_REMAIN�̴�.
       
    CREATE TABLE TEMP_REMAIN AS 
        (SELECT * FROM REMAIN);
        
    SELECT*FROM TEMP_REMAIN;
    
3. DELETE ������ �������� ��� -- ������� �����.  / ���� �Ұ���  
    ** DELETE���� �������
       DELETE FROM ���̺��
        [WHERE ����]; 
        
��뿹) TEMP_REMAIN���̺��� 2020�� 7�� �Ǹŵ� ��ǰ�� ���� �ڵ���
       �ڷḦ �����Ͻÿ�.
(��������) 2020�� 7���� �Ǹŵ� ��ǰ
       SELECT DELETE CART_PROD
         FROM CART
        WHERE CART_NO LIKE '202007%'
        
���)
    
    DELETE FROM TEMP_REMAIN A
     WHERE REMAIN_YEAR='2020'
       AND A.PROD_ID IN(SELECT DISTINCT CART_PROD
                          FROM CART
                         WHERE CART_NO LIKE '202007%');