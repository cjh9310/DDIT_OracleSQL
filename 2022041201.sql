2022-0412-01) ������
1. �������� ����
 - ���������, ��������, ���迬����, ��Ÿ������ 
 
    1) ���������
    . ��Ģ������(+,-,/,*)

��뿹) ������̺� (HR������ EMPLOYEES)���� ������� ���޾��� ����Ͽ�
        ����Ͻÿ�.
        ���ʽ� = �޿�(SAYLARY)�� 30%
        ���޾� = �޿� + ���ʽ�
        Alias�� �����ȣ, �����,�޿�,���ʽ�,���޾��̸�
        ���޾��� ���� �������� ����Ͻÿ�.
  
        
SELECT  EMPLOYEE_ID AS �����ȣ,
        FIRST_NAME || ' ' || LAST_NAME AS �����,
        SALARY AS �޿�,
        ROUND(SALARY*0.3) AS  ���ʽ�, -- ROUND() �Ҽ��� ���ﶧ
        SALARY + ROUND(SALARY*0.3) AS ���޾� 
    FROM HR.employees  -- �ٸ� ������ �����ö� ������.�÷��� �Է�
  ORDER BY 5 DESC --SALARY + ROUND(SALARY*0.3)�� SELECT���� 5��° ��ġ�� �־ �����ϰ� Ȱ��
  
��뿹) �������̺�(BUYPROD)���� 2020�� 2�� ���ں� �������踦 ��ȸ�Ͻÿ�.
        Alias�� ����, ���Լ����հ�, ���Աݾ��հ��̸� ���ڼ����� ����Ͻÿ�.
        
        SELECT BUY_DATE AS ����,
               SUM(BUY_QTY) AS ���ϼ����հ�,
               SUM(BUY_QTY*BUY_COST) AS ���ϱݾ��հ�
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND
               LAST_DAY(TO_DATE('20200201'))
               GROUP BY BUY_DATE
               ORDER BY 1;
        
        
        
        
        
        
        
        SELECT BUY_DATE AS ����,
            SUM(BUY_QTY) AS ���Լ����հ�,
            SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND
            LAST_DAY(TO_DATE('20200201')) -- (���� ������ ��...) 20200201�� LAST_DAY -> 2020�� 2�� ������������
        GROUP BY BUY_DATE
        ORDER BY 1;

        SELECT 12323*435234323/1234542
            FROM DUAL;
    
    2) ���迬����
    . ���ǽ��� �����Ҷ� ����
    . �������� ��Ұ��踦 �Ǵ��ϸ� ����� true,false�̴�.
    . >,<,>=,<=,=,!=(<>)  -- ũ�ٿ� �۴ٰ� ���� ���� �� ����?  ex) ><
    -- In�����ڿ��� �� �� ������ or,any,some���� �����ڿ��� �� �� �ִ�.
    . WHERE ���� ���ǽİ� ǥ����(CASE WHEN THEN)�� ���ǽĿ� ���
    
��뿹) ��ǰ���̺�(PROD)���� �ǸŰ�(PROD_PRICE)�� 200000���� �̻��� ��ǰ�� --WHERE�� �ʿ�
        ��ȸ�Ͻÿ�.
        Alias�� ��ǰ�ڵ�, ��ǰ��, ���԰���, �ǸŰ����̸� 
        --cost ���Դܰ�./ price �ǸŰ��� 
        ��ǰ�ڵ������ ����� ��.
        SELECT PROD_ID AS ��ǰ�ڵ�,
             PROD_NAME AS ��ǰ��,
             PROD_COST AS ���԰���,
             PROD_PRICE AS �ǸŰ���
        FROM PROD
        WHERE PROD_PRICE>=200000
        ORDER BY 1;
        
        
        
        
��뿹) ȸ�����̺�(MEMBER)���� ���ϸ����� 5000�̻��� ȸ�������� ��ȸ�Ͻÿ�.
        Alias�� ȸ����ȣ, ȸ����, ���ϸ���, �����̸� '����'������ '����ȸ��'
        �Ǵ� '����ȸ��'�� ����� ��.
       
            
        SELECT MEM_ID AS ȸ����ȣ,
             MEM_NAME AS ȸ����,
             MEM_MILEAGE AS ���ϸ���,
             
            CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR
                      SUBSTR(MEM_REGNO2,1,1)='3' THEN
                      '����ȸ��'
                ELSE  -- ���ǽ��� ����� �� ���� �߿� �ϳ�?
                      '����ȸ��'
            END AS  ����
            FROM MEMBER
        WHERE MEM_MILEAGE>=5000;
    
    3) ��������
        - �� ���̻��� ���ǽ��� ��(AND,OR)�� �Ǵ� Ư�� ���ǽ��� ����(NOT)�� 
            ����� ��ȯ  --not : �ݴ�Ǵ� ������ ( �� ���� �ݴ�?)
        - ����ǥ   -- AND,OR �� ���� ������ �ʿ�/ NOT �ϳ��� �����ڸ� ������ �ȴ�.
----------------------------------------
        �Է°�          ��°�
    X       Y        AND     OR
----------------------------------------
    0       0         0       0
    0       1         0       1              -- 1�� ����.
    1       0         0       1
    1       1         1       1
    
- ��������� NOT->AND->OR

��뿹) ȸ�����̺��� ȸ���� ����⵵�� �����Ͽ� ����� ����� �����Ͽ� ����Ͻÿ�.
        Alias�� ȸ����ȣ,ȸ���̸�,��������,���
        ** ���� = 4�ǹ���̸� 100�ǹ���� �ƴϰų� 400�� ����� �Ǵ� ��
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ���̸�,
               MEM_REGNO1 AS ��������,                           -- MOD : �������� ���ϴ� �Լ�
               CASE WHEN (MOD(EXTRACT(YEAR FROM MEM_BIR),4)=0 AND -- EXTRACT : ������ �� �ִ� �Լ�.
                         MOD(EXTRACT(YEAR FROM MEM_BIR),100)!=0) OR
                         MOD(EXTRACT(YEAR FROM MEM_BIR),400)=0 THEN
                         '����'
                         ELSE
                         '���'
          END AS ���
          FROM MEMBER
          
    ** ������̺� EMP_NAME varchar2(80)�÷��� �߰��ϰ� FIRST_NAME�� LAST_NAME�� 
       �����Ͽ� EMP_NAME�� �����ϼ���.
       1) �÷��� �߰�
          ALTER TABLE HR.employees
          ADD EMP_NAME varchar2(80);
          UPDATE HR.employees
          -- �̹� ����Ǿ� �ִ°Ŷ� INSERT�� �ƴ϶� ������Ʈ�� �ҷ�����
             SET EMP_NAME=FIRST_NAME||' '||LAST_NAME;
             COMMIT;
             SELECT * FROM HR.employees
��뿹) ������̺��� 10�μ����� 50���μ��� ���� ��������� ��ȸ�Ͻÿ�.
        Alias�� �����ȣ,�����,�μ���ȣ,�Ի���,��å�ڵ��̸�
        �μ���ȣ������ ����Ͻÿ�.

        SELECT EMPLOYEE_ID AS �����ȣ,
               EMP_NAME AS �����,
               DEPARTMENT_ID AS �μ���ȣ,
               HIRE_DATE AS �Ի���,
               JOB_ID AS ��å�ڵ�
          FROM HR.employees
         WHERE 10<=DEPARTMENT_ID AND DEPARTMENT_ID<=50    --���� ������ AND Ȥ�� BETWEEN ���
         -- �ƴϸ� WHERE DEPARTMENT_ID BETWENN 10 AND 50 ���� �ᵵ 
         ORDER BY 3;   -- DEPARTMENT_ID AS �μ���ȣ,  3��°�ٿ� ����

��뿹) ��ٱ������̺��� 2020�� 6�� ��ǰ�� �Ǹż�������� �Ǹűݾ� ���踦 ��ȸ�Ͻÿ�.
       ����� ��ǰ�ڵ�, ��ǰ��, �Ǹż����հ�, �Ǹűݾ��հ��̸� 
       �Ǹűݾ��� ���� ������ ���ʴ�� ����ϼ���.
        --SELECT ��ǰ�ڵ�, ��ǰ��, �Ǹż����հ�, �Ǹűݾ��հ� -- SELECT�� �������� ������.
          --FROM CART A, --���̺� �ٿ��� ��Ī CART�� A��� ����ϰڴ�.
          --  �����ϸ� FROM���� �� ���� �����. ��� FROM�� �ٸ� ���� ������ �� ����.
        SELECT A.CART_PROD AS ��ǰ�ڵ�, 
               B.PROD_NAME AS ��ǰ��, 
               SUM(A.CART_QTY) AS �Ǹż����հ�, 
               SUM(A.CART_QTY*B.PROD_PRICE) AS �Ǹűݾ��հ� 
          FROM CART A,PROD B
         WHERE A.CART_PROD=B.PROD_ID
           AND /*1�� SUBSTR(A.CART_NO,1,8)>='20200601' AND
                 SUBSTR(A.CART_NO,1,8)>='20200630' */
                 --2�� SUBSTR(A.CART_NO,1,6) = '203006'
                 /*3��*/ A.CART_NO LIKE '202006%'
         GROUP BY A.CART_PROD,B.PROD_NAME
         ORDER BY 4 DESC;
-- ���� ����� �� ��. SUM AVG C.OUNT MAX MIN

 