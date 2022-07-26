PL/SQL (�������� ���ν��� ����ȭ�� ���� ���)
- ����Ÿ�� ����
Package(��Ű��)
User Function(��������� �Լ�)
Stored Procedure(���� ���ν���)
Trigger(Ʈ����)
Anonymous Block(�͸��� ���)

                                CURSOR(Ŀ��)
/
SET SERVEROUTPUT ON;
/
    DECLARE
        -- SCALAR(�Ϲ�)����
        V_BUY_PROD VARCHAR2(10);
        V_QTY NUMBER(10);
        CURSOR CUR IS -- ����� CUR��� �̸��� �ٿ��� 
        SELECT BUY_PROD, SUM(BUY_QTY)
        FROM    BUYPROD
       WHERE    BUY_DATE LIKE '2020%'
       GROUP BY BUY_PROD -- ���� PROD���� ������ 
       ORDER BY BUY_PROD ASC; --���� ASC ��������  ,DESC ��������
       -- LIKE + % (��������) , LIKE + _ (�ѱ���)
    BEGIN
       OPEN CUR; -- �޸� �Ҵ�(�ö�) = ���ε�
       
       --����� 
       --��(FETCH)
       FETCH CUR INTO V_BUY_PROD, V_QTY; -- V_PROD�� V_QTY�� ������� �־��� (V_������ ����)
       -- FETCH ���� ������ �Ѿ(������� �ִ� ��1,��2,��3~~��), ���� �����ϴ��� üŷ
        (FOUND : ����������? / NOTFOUND : �����Ͱ� ������? /ORWCOUNT : ���� ��)
       WHILE(CUR%FOUND) LOOP --�ݺ���
       DBMS_OUTPUT.PUT_LINE(V_BUY_PROD ||','|| V_QTY);-- �� (���)
       FETCH CUR INTO V_BUY_PROD, V_QTY;--��(������)
        END LOOP;
       CLOSE CUR;  -- ������� �޸𸮸� ��ȯ(�ʼ�)
    END;

-- ȸ�����̺��� ȸ����� ���ϸ����� ����غ���
-- ��, ������ '�ֺ�'�� ȸ���� ����ϰ� ȸ������ �������� �����غ���
-- ALIAS : MEM_NAME,MEM_MILEAGE
-- CUR�̸��� CURSOR�� �����ϰ� �͸������� ǥ��
DECLARE 
    
    V_NAME MEMBER.MEM_NAME%TYPE;--VARCHAR2(20);  MEMBER�� MEM_NAME�̶�� �÷��� Ÿ�� --REFERENCE���� 
    V_MILEAGE NUMBER(10);  --SCALAR����
CURSOR CUR IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB LIKE '�ֺ�' --MEM_JOB = '�ֺ�'
     ORDER BY MEM_NAME ASC;
BEGIN
    OPEN CUR;
    LOOP
    FETCH CUR INTO V_NAME, V_MILEAGE;
    EXIT WHEN CUR%NOTFOUND; -- CUR�� ���� �����ִ°� ������ ����
    DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||V_NAME||', '||V_MILEAGE); --ROWCOUNT  �� ��ȣ.
    END LOOP;
    CLOSE CUR;
END;
/

-- ������ �Է¹޾Ƽ� FOR LOOP�� �̿��ϴ� CURSOR
DECLARE 
CURSOR CUR (V_JOB VARCHAR2) IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB = V_JOB 
     ORDER BY MEM_NAME ;
BEGIN
    -- FOR������ �ݺ��ϴ� ���� Ŀ���� �ڵ����� OPEN�ϰ�
    -- ��� ���� ó���Ǹ� �ڵ����� Ŀ���� CLOSE��
    -- REC : �ڵ�����Ǵ� ������ ����
    FOR REC IN CUR('�л�') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||REC.MEM_NAME||', '||REC.MEM_MILEAGE); 
    END LOOP;
END;
/

DECLARE 
CURSOR CUR (V_JOB VARCHAR2) IS
    SELECT MEM_NAME,
           MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_JOB = V_JOB 
     ORDER BY MEM_NAME ;
BEGIN
    FOR REC IN CUR('�л�') LOOP
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||REC.MEM_NAME||', '||REC.MEM_MILEAGE); 
    END LOOP;
END;
/

CURSOR ����
--2020�⵵ ȸ���� �Ǹűݾ���(�ǸŰ�(PROD_SALE)
--                         * ���ż���(CART_QTY))�� �հ踦
-- CURSOR�� FOR���� ���� ����غ���
-- ALIAS : MEM_ID, MEM_NAME, SUM_AMT
-- ��¿��� : a001, ������, 2000
--           b001, �̻���, 1750
    SELECT A.MEM_ID,
           A.MEM_NAME,
           SUM(B.PROD_SALE * C.CART_QTY)
      FROM MEMBER A, PROD B, CART C
     WHERE A.MEM_ID = C.CART_MEMBER
       AND C.CART_PROD = B.PROD_ID
       AND CART_NO LIKE '2020%'
     GROUP BY A.MEM_ID, A.MEM_NAME
     ORDER BY MEM_ID;




ANSI����
DECLARE
    CURSOR CUR IS
    SELECT A.MEM_ID,
           A.MEM_NAME,
           SUM(B.PROD_SALE * C.CART_QTY) OUT_AMT --OUT_AMT �Ǹŵ� ��
      FROM PROD B INNER JOIN CART C   ON(C.CART_PROD = B.PROD_ID)
                  INNER JOIN MEMBER A ON(A.MEM_ID = C.CART_MEMBER)
     WHERE CART_NO LIKE '2020%'
     GROUP BY A.MEM_ID, A.MEM_NAME
     ORDER BY MEM_ID;
BEGIN
    FOR REC IN CUR LOOP
    IF MOD(CUR%ROWCOUNT,2) !=0 THEN    --¦���� �̱�
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT||','||
                             REC.MEM_ID || ','||
                             REC.MEM_NAME||','|| 
                             REC.OUT_AMT);
    END IF;
    END LOOP;

END;



