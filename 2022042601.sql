2022-0426-01) ���տ�����
    - SQL������ ����� ������ ����(set)�̶�� ��
    - �̷� ���յ� ������ ������ �����ϱ� ���� �����ڸ� ���տ����ڶ�� ��
    - UNION, UNION ALL, INTERSECT, MINUS �� ����
    - ���տ����ڷ� ����Ǵ� �� SELECT���� SELECT���� �÷��� ����,����,Ÿ���� ��ġ�ؾ���
    - ORDER BY ���� �� ������ SELECT������ ��� ����
    - ����� ù ��° SELECT���� SELECT���� �����̵�
    -- UNION ALL �� ���̻�(�ߺ��� ������ŭ) �˻���� (��ü + �ߺ��� �κ�)
    -- INTERSECT ���� �κ��� �˻������ �˷���
    -- -MINUS ������( ������� �ʴ� �κ��� �˷���)
(�������)
    SELECT �÷�LIST
      FROM ���̺��
    [WHERE ����]
    UNION|UNION ALL|INTERSECT|MINUS  --UNION|UNION ALL ������
    SELECT �÷�LIST
      FROM ���̺��
    [WHERE ����]
          :
  UNION|UNION ALL|INTERSECT|MINUS
    SELECT �÷�LIST
      FROM ���̺��
    [WHERE ����]
    [ORDER BY �÷���|�÷�idex [ASC|DESC,...];
      
      
1.UNION 
    - �ߺ��� ������� ���� �������� ����� ��ȯ
    - �� SELECT���� ����� ��� ����
    
��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ���� ȸ����ȣ,ȸ����,����,
        ���ϸ����� ��ȸ�Ͻÿ�. -- �� ���� �泲�� �������̸鼭 ������ ȸ�� �� ���� '�۰���'�ε� ù��° ���� 11�� �ι�° ���� 3��
        -- �� �� '�۰���'�� �� �� ���ԵǼ� ������ ��ü ������� �� ���� ���,
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)) 
                BETWEEN 20 AND 29
           AND SUBSTR(MEM_REGNO2,1,1) IN(2,4)
         UNION
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE MEM_ADD1 LIKE '�泲%'    --SUBSTR�� ����
         ORDER BY 1;
        
2. INTERSECT
    - ������(����κ�)�� ��� ��ȯ
        
��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ�� �� ���ϸ�����2000�̻��� ȸ����ȣ,ȸ����,����,
        ���ϸ����� ��ȸ�Ͻÿ�.        
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)) 
                BETWEEN 20 AND 29
           AND SUBSTR(MEM_REGNO2,1,1) IN(2,4)
UNION
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE MEM_ADD1 LIKE '�泲%'    --SUBSTR�� ����
                
INTERSECT
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_JOB AS ����,
               MEM_MILEAGE AS ���ϸ���
          FROM MEMBER
         WHERE MEM_MILEAGE>2000   
         ORDER BY 1; 
        
3. UNION ALL
    - �ߺ��� ����Ͽ� �������� ����� ��ȯ
    - �� SELECT���� ����� ��� ����(�ߺ� ����)
��뿹) 1�� DEPTS ���̺��� PARENT_ID�� NULL�� �ڷ��� �μ��ڵ�,�μ���,�����μ��ڵ�(PARENT_ID),
        ����(��� ���ʿ� ������ ����)�� ��ȸ�Ͻÿ�.
        ��, �����μ��ڵ�� 0�̰� ������ 1�̴�.
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           0 AS PARENT_ID,
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL;   -- �߿�! = ���δ� NULL�� ã�� �� ���� IS���
        
2�� DEPTS ���̺��� �����μ��ڵ尡 NULL�� �μ��ڵ带 ����μ��ڵ�� ���� 
        �μ��� �μ��ڵ�,�μ���,�����μ��ڵ�,������ ��ȸ�Ͻÿ�.
        ��, ������ 2�̰� �μ����� ���ʿ��� 4ĭ�� ������ ���� �� �μ��� ���
    �ؼ� = �ѹ���ȹ���� DEPARTMENT_ID�� ���� �ڵ��� �μ��� ã�ƶ�.
    
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,  --RPAD ������ ����
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS
      FROM HR.DEPTS A, HR.DEPTS B  --���� ���̺��� �� ���� ��� ��.
     WHERE A.PARENT_ID IS NULL     -- �ѹ���ȹ�� => ������ �Ǵ� ���̺�.
       AND B.PARENT_ID=A.DEPARTMENT_ID;
      -- �� ���̺� ��Ī �ΰ��� �ο��ؼ� ���� �ٸ� ���̺�� ����
      -- B���̺��� A(����)�� ���ϴ� ���̺�
      -- �ѹ���ȹ���� �μ���ȣ(A.DEPARTMENT_ID)  ������ �μ��� �μ���ȣ(B.PARENT_ID)�� ������ 
         -- �ѹ���ȹ�ο� �ҼӵǾ��ִ� �μ��� ã�� ��
(����)    
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID,
           --0 AS PARENT_ID,  �� ����
           1 AS LEVELS
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL 
     UNION ALL  --SELECT
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, 
             -- ���߿� 2 ��� LEVEL�� ��� 
             -- 2-1�� ���� : ���������� ������� �� ����� �ƴ϶� LEVEL�� �´�.
             -- ����2 �ڸ��� LEVEL�� ���µ� ���� SELECT�� ��ĭ�� �������� �ʾƼ� 1-1�� �������ְ�
             -- �Ʒ��� SELECT�� ��ĭ�� �����ϹǷ� 2-1�� ����Ѵ�.
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS     
      FROM HR.DEPTS A, HR.DEPTS B  
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID;
       
       -- A���̺��� �������ִ� �μ��ڵ� 10
       
       
    SELECT DEPARTMENT_ID,
           DEPARTMENT_NAME,
           NVL(PARENT_ID,0) AS PARENT_ID,
           1 AS LEVELS,
           PARENT_ID || DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS
     WHERE PARENT_ID IS NULL 
     
     UNION ALL  
     
    SELECT B.DEPARTMENT_ID,
           LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           B.PARENT_ID AS PARENT_ID,
           2 AS LEVELS,
           B.PARENT_ID||B.DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS A, HR.DEPTS B  
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID;
     UNION ALL  
    SELECT C.DEPARTMENT_ID,
           LPAD(' ',4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,
           C.PARENT_ID AS PARENT_ID,
           3 AS LEVELS,
           B.PARENT_ID||C.PARENT_ID||C.DEPARTMENT_ID AS TEMP
      FROM HR.DEPTS A, HR.DEPTS B ,HR.DEPTS C
     WHERE A.PARENT_ID IS NULL     
       AND B.PARENT_ID=A.DEPARTMENT_ID
       AND C.PARENT_ID=B.DEPARTMENT_ID
       ORDER BY 5;
       -- A �ѹ���ȹ�� ���                              1LEVEL
       -- B �ѹ���ȹ���� ���� �Ҽ� �Ǿ��ִ� 6���� �μ�       2LEVEL
       -- C 6���� ���� �μ��� ���                        3LEVEL
       -- ����... ���� �ñ�

**����������
    - ������ ������ ���� ���̺��� ������ ����Ҷ� ���
    - Ʈ�������� �̿��� ���
    (�������)
    SELECT �÷�list
      FROM ���̺��
     START WITH ���� -- ���� => ��Ʈ(root)��� ����
   CONNECT BY NOCYCLE|PRIOR �������� ���� --���������� ������� ���� �Ǿ�����
   -- NOCYCLE : ���ѷ��� ���� / PRIOR : ��κ�
** CONNECT BY PRIOR �ڽ��÷� = �θ��÷� :�θ𿡼� �ڽ����� Ʈ������(TOP DOWN)
** CONNECT BY PRIOR �θ��÷� = �ڽ��÷� :�ڽĿ��� �θ�� Ʈ������(BOTTOM UP)

** PRIOR �����ġ�� ���� ����
    CONNECT BY PRIOR �÷�1 = �÷�2
                     <--------------
    CONNECT BY �÷�1 = PRIOR �÷�2
                     --------------->
** ������ ���� Ȯ��
    CONNECT_BY_ROOT �÷��� : ��Ʈ��� ã��
    CONNECT_BY_ISCYCLE : �ߺ������� ã��
    CONNECT_BY_ISLEAF : �ܸ���� ã��
       
        SELECT DEPARTMENT_ID AS �μ��ڵ�,
               LPAD(' ',4*(LEVEL-1))||DEPARTMENT_NAME AS �μ���,
               LEVEL AS ����
          FROM HR.DEPTS
         START WITH PARENT_ID IS NULL
       CONNECT BY PRIOR DEPARTMENT_ID = PARENT_ID
--     CONNECT BY PRIOR PARENT_ID = DEPARTMENT_ID; 
         ORDER SIBLINGS BY DEPARTMENT_NAME; --����
        
        
        
        
        
��뿹) ��ٱ������̺��� 4���� 6���� �Ǹŵ� ��� ��ǰ������ �ߺ����� �ʰ� ��ȸ�Ͻÿ�. --CART
       Alias�� ��ǰ��ȣ,��ǰ��,�Ǹż��� �̸� ��ǰ��ȣ ������ ����Ͻÿ�.
       SELECT B.PROD_ID AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.CART_QTY) AS �Ǹż��� --4���� �Ǹŵ� �ߺ��� ��ǰOR��ȣ�� ��ģ ��.
         FROM CART A,PROD B              --������ �����.
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='04'
        GROUP BY B.PROD_ID,B.PROD_NAME
   UNION
       SELECT B.PROD_ID AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��,
              SUM(A.CART_QTY) AS �Ǹż���
         FROM CART A,PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        GROUP BY B.PROD_ID,B.PROD_NAME
        ORDER BY 1;
��뿹) ��ٱ������̺��� 4������ �Ǹŵǰ� 6������ �Ǹŵ� ��� ��ǰ������ ��ȸ�Ͻÿ�.
       Alias�� ��ǰ��ȣ,��ǰ���̸� ��ǰ��ȣ ������ ����Ͻÿ�.       
       SELECT B.PROD_ID AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��
         FROM CART A,PROD B              
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='04'
   UNION ALL
       SELECT B.PROD_ID AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��
         FROM CART A,PROD B
        WHERE A. CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        ORDER BY 1;      
       
       
��뿹) ��ٱ������̺��� 4���� 6���� �Ǹŵ� ��ǰ �� 6������ �Ǹŵ� ��ǰ������ ��ȸ�Ͻÿ�.
       Alias�� ��ǰ��ȣ,��ǰ��,�Ǹż��� �̸� ��ǰ��ȣ ������ ����Ͻÿ�.             
       
       SELECT B.PROD_ID AS ��ǰ��ȣ,
              B.PROD_NAME AS ��ǰ��,
              A.CART_QTY AS �Ǹż���
         FROM CART A,PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND SUBSTR(A.CART_NO,5,2) ='06'
        ORDER BY 1;
       
       
       
       