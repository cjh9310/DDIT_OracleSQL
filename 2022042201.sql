2022-0422-01 TABLE JOIN
    - ������ DB�� ���� �ٽ� ���
    - �������� ���̺� ���̿� �����ϴ� ���踦 �̿��� ����
    - ����ȭ�� �����ϸ� ���̺��� ��Ȱ�ǰ� �ʿ��� �ڷᰡ �������� ���̺� 
        �л� ����� ��� ����ϴ� ����
    - JOIN�� ����
     . �Ϲ����� vs ANSI JOIN
     . INNER JOIN VS OUTER JOIN
     . Equi-Join vs Non Equi-Join
     . ��Ÿ(Cartesian Product,Self Join ,... etc)
    - �������(ANSI ����)
    SELECT �÷�list
      FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,���̺��3 [��Ī3],...]
     WHERE ��������
      [AND �Ϲ�����]
    . ���̺� ��Ī�� �������� ���̺� ������ �÷����� �����ϰ� �ش� �÷��� �����ϴ� 
      ��� �ݵ�� ���Ǿ�� ��
    . ���Ǵ� ���̺��� n�� �϶� ���������� ��� n-1�� �̻��̾�� �Ѵ�.
    . ���������� �� ���̺� ���� ������ �÷��� ����Ѵ�.
     
     
     
     
1. Cartesian Product
    - ���������� ���ų�
 �������ǿ� �߸��� ��� �߻�
 - �־��� ���(���������� ���� ���) A���̺�(a�� b��)�� B���̺�(c�� d��)��
    Cartesian Product�� �����ϸ� ����� a*c��, b+d���� ��ȯ
 - ANSI������ CROSS JOIN�̶�� �ϸ� �ݵ�� �ʿ��� ��찡 �ƴϸ� ��������
    ���ƾ��ϴ� JOIN�̴�.
    
    (�������-�Ϲ�����)
    SELECT �÷�list
        FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,���̺��3 [��Ī3],...]
 
    (�������-ANSI����)
    SELECT �÷�list
        FROM ���̺��1 [��Ī1]        
     CROSS JOUN ���̺��2;  -- 
    
��뿹)
    SELECT COUNT(*)  -- ���� ��
        FROM PROD;
    
    SELECT COUNT(*)
        FROM CART;
     
    SELECT COUNT(*)
      FROM BUYPROD;
      
     SELECT COUNT(*)
        FROM PROD A,CART B, BUYPROD;
    
    SELECT COUNT(*)
        FROM PROD A
     CROSS JOIN CART B
     CROSS JOIN BUYPROD C;
    
2. Equi Join
    - ���� ���ǿ� '='�����ڰ� ���� �������� ��κ��� ������ �̿� ���Եȴ�.
    - �������� ���̺� �����ϴ� ������ �÷����� ��� �򰡿� ���� ����
    (�Ϲ����� �������)
    SELECT �÷�list
      FROM ���̺�1 ��Ī1, ���̺�2 ��Ī2[,���̺�3 ��Ī3,...] 
     WHERE ��������
    
    (ANSI���� �������) --���̺� 1 �� ���̺�2�� ���� ������ �Ǿ �ݵ�� ������ �÷��� �־���ϰ� 
    -- ���̺�3�� ���̺�1�� ������ �÷��� ��� ���̺�2�� ������ �÷��� ������ ������ ������ ����.
    
    SELECT �÷�list
      FROM ���̺�1 ��Ī1
     INNER JOIN ���̺�2 ��Ī2 ON(�������� [AND �Ϲ�����])
     [INNER JOIN ���̺�3 ��Ī3 ON(�������� [AND �Ϲ�����])
              :
     [WHERE �Ϲ�����]
      . 'AND �Ϲ�����' : ON���� ����� �Ϲ������� �ش� INNER JOIN �������� 
        ���ο� �����ϴ� ���̺� ���ѵ� ����
      . 'WHERE �Ϲ�����' : ��� ���̺� ����Ǿ�� �ϴ� ���Ǳ��
    
��뿹) 2020�� 1�� ��ǰ�� �������踦 ��ȣ�Ͻÿ�.
    Alias�� ��ǰ�ڵ�,��ǰ��,���Աݾ��հ��̸� ��ǰ�ڵ������ ����Ͻÿ�
    SELECT A.BUY_PROD AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           SUM(A.BUY_QTY*B.PROD_COST) AS ���Աݾ��հ�
      FROM BUYPROD A,PROD B
     WHERE A.BUY_PROD = B.PROD_ID  -- ���� ����
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND
                              TO_DATE('20200131')
     GROUP BY A.BUY_PROD, B.PROD_NAME
     ORDER BY 1; 
  
    (ANSI JOIN)    
     SELECT A.BUY_PROD AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           SUM(A.BUY_QTY*B.PROD_COST) AS ���Աݾ��հ�
      FROM BUYPROD A
     INNER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID  -- ���� ����
       AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))
     GROUP BY A.BUY_PROD, B.PROD_NAME
     ORDER BY 1;    
    
��뿹) ��ǰ���̺��� �ǸŰ��� 50�����̻��� ��ǰ�� ��ȸ�Ͻÿ�.
        Alias�� ��ǰ�ڵ�,��ǰ��,�з���,�ŷ�ó��,�ǸŰ����̰� �ǸŰ����� ū ��ǰ������
        ����Ͻÿ�...
        SELECT A.PROD_ID AS ��ǰ�ڵ�,
               A.PROD_NAME AS ��ǰ��,
               B.LPROD_NM AS �з���,
               C.BUYER_NAME AS �ŷ�ó��,
               A.PROD_PRICE AS �ǸŰ���
          FROM PROD A,LPROD B,BUYER C
         WHERE A.PROD_LGU =B.LPROD_GU  -- �з����� ������.     ��������
         --    A.PROD_LGU = C.BUYER_LGU  -- �ŷ�ó���� ������. ��������
            AND A.PROD_BUYER=C.BUYER_ID  -- �ŷ�ó���� ������. ��������
            AND A.PROD_PRICE >=500000  --�Ϲ�����
         ORDER BY 5;
    -- WHERE ������ ���̺��� ����ȭ ��ų �� �Ѱ��� �÷����� 3���̻��� �� ���� �÷��� ���� �Ǹ� ����� �ߺ��� �߻��ϹǷ�
    -- 3���� �̻� ���̺��� ����ȭ �Ҷ� �÷��� �ٸ� ������ ���༭  ����ȭ ���Ѿ��Ѵ�. 
    --EX) A.PROD_LGU =B.LPROD_GU (LGU�ڵ�) �׸���  A.PROD_BUYER=C.BUYER_ID(BUYER���̵� �ڵ�)
    
    
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
                   A.PROD_NAME AS ��ǰ��,
                   B.LPROD_NM AS �з���,
                   C.BUYER_NAME AS �ŷ�ó��,
                   A.PROD_PRICE AS �ǸŰ���
              FROM PROD A  
             INNER JOIN LPROD B ON(A.PROD_LGU =B.LPROD_GU)
             INNER JOIN BUYER C ON(A.PROD_BUYER=C.BUYER_ID)  
             WHERE A.PROD_PRICE >=500000 
             ORDER BY 5 DESC;    
    
        
    SELECT A.PROD_ID AS ��ǰ�ڵ�,
                   A.PROD_NAME AS ��ǰ��,
                   B.LPROD_NM AS �з���,
                   C.BUYER_NAME AS �ŷ�ó��,
                   A.PROD_PRICE AS �ǸŰ���
              FROM PROD A  
             INNER JOIN LPROD B ON(A.PROD_LGU =B.LPROD_GU)
             INNER JOIN BUYER C ON(A.PROD_BUYER=C.BUYER_ID AND
                              A.PROD_PRICE >=500000 )  
             ORDER BY 5 DESC;
    
��뿹) 2020�� ��ݱ� �ŷ�ó�� �Ǹž����踦 ���Ͻÿ�.
    Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,�Ǹž��հ�
    SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
           A.BUYER_NAME AS �ŷ�ó��,
           SUM(B.CART_QTY*C.PROD_PRICE) AS �Ǹž��հ�
      FROM BUYER A, CART B, PROD C
     WHERE SUBSTR(B.CART_NO,1,6) BETWEEN '202001' AND '202006'
       AND B.CART_PROD=C.PROD_ID --��������(�ܰ��� �����ϱ� ���ؼ�)
       AND A.BUYER_ID = C.PROD_BUYER -- ��������(�ŷ�ó ����)
     GROUP BY A.BUYER_ID,A.BUYER_NAME
     ORDER BY 1;
    
    
��뿹) HR�������� �̱� �̿��� ������ ��ġ�� �μ��� �ٹ��ϴ� ���������
       ��ȸ�Ͻÿ�.
       Alias�� �����ȣ,�����,�μ���,�����ڵ�,�ٹ����ּ�
       �̱��� �����ڵ�� 'US'�̴�.
        SELECT A.EMPLOYEE_ID AS �����ȣ,
               A.EMP_NAME AS �����,
               B.DEPARTMENT_NAME AS �μ���,
               A.JOB_ID AS �����ڵ�,
               C.STREET_ADDRESS||' '||CITY||', '||STATE_PROVINCE AS �ٹ����ּ�
          FROM HR.EMPLOYEES A,HR.DEPARTMENTS B,HR.LOCATIONS C
         WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID --��������(�μ�����)
           AND B.LOCATION_ID = C.LOCATION_ID --��������(�ش� �μ��� ��ġ�ڵ�� �ּ� ����)
           AND C.COUNTRY_ID NOT IN('US')   -- �ƴϸ� C.COUNTRY_ID != 'US' �� ����
         ORDER BY 1;
    
��뿹) 2020�� 4�� �ŷ�ó�� ���Աݾ��� ��ȸ�Ͻÿ�.
        Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,���Աݾ��հ�
        
        SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
               A.BUYER_NAME AS �ŷ�ó��,
               SUM(B.BUY_QTY*C.PROD_COST) AS ���Աݾ��հ� --C.PROD_COST ��� B.BUY_COST�� �ᵵ ������ �� ���� �� ����.
          FROM BUYER A, BUYPROD B, PROD C
         WHERE B.BUY_PROD = C.PROD_ID
           AND C.PROD_BUYER = A.BUYER_ID
           AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND  LAST_DAY(TO_DATE('20200401'))
         GROUP BY A.BUYER_ID,A.BUYER_NAME
(ANIS)         
         SELECT C.BUYER_ID AS �ŷ�ó�ڵ�,
               C.BUYER_NAME AS �ŷ�ó��,
               SUM(A.BUY_QTY*B.PROD_COST) AS ���Աݾ��հ� 
          FROM BUYPROD A        --ù��° ������ �ݵ�� JOIN�� �Ǿ���ؼ� 
         INNER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID AND
               A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
         INNER JOIN BUYER C ON(B.PROD_BUYER = C.BUYER_ID)
         GROUP BY C.BUYER_ID,C.BUYER_NAME
         ORDER BY 1;
        
��뿹) 2020�� 4�� �ŷ�ó�� ����ݾ��� ��ȸ�Ͻÿ�.
        Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,����ݾ��հ� 
        
        SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
               A.BUYER_NAME AS �ŷ�ó��,
               SUM(B.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
          FROM BUYER A, CART B, PROD C
         WHERE C.PROD_BUYER = A.BUYER_ID
           AND B.CART_PROD = C.PROD_ID
           AND SUBSTR(B.CART_NO,1,8) BETWEEN '20200401' AND '20200430'
         GROUP BY A.BUYER_ID,A.BUYER_NAME
(ANIS) 
        SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
               A.BUYER_NAME AS �ŷ�ó��,
               SUM(B.CART_QTY * C.PROD_PRICE) AS ����ݾ��հ�
          FROM BUYER A
         INNER JOIN PROD C ON(A.BUYER_ID = C.PROD_BUYER) 
         INNER JOIN CART B ON(C.PROD_ID = B.CART_PROD AND B.CART_NO LINE '202004%')
         GROUP BY A.BUYER_ID, A.BUYER_NAME
         ORDER BY 1;
          
 ��뿹) 2020�� 4�� �ŷ�ó�� ����/����ݾ��� ��ȸ�Ͻÿ�.
        Alias�� �ŷ�ó�ڵ�,�ŷ�ó��,���Աݾ��հ� ,����ݾ��հ�  
        SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
               A.BUYER_NAME AS �ŷ�ó��,
               SUM(D.BUY_QTY*C.PROD_COST) AS ���Աݾ��հ�,
               SUM(B.CART_QTY * C.PROD_COST) AS ����ݾ��հ�
          FROM BUYER A, CART B, PROD C, BUYPROD D
         WHERE C.PROD_BUYER = A.BUYER_ID
           AND D.BUY_PROD = C.PROD_ID
           AND B.CART_PROD = C.PROD_ID
           AND SUBSTR(B.CART_NO,1,8) BETWEEN '20200401' AND '20200430'
           AND B.CART_NO LIKE '202004%'
         GROUP BY A.BUYER_ID,A.BUYER_NAME 
         ORDER BY 1;
(ANSI)
        SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
               A.BUYER_NAME AS �ŷ�ó��,
               SUM(B.BUY_QTY*D.PROD_COST) AS ���Աݾ��հ�,
               SUM(C.CART_QTY * D.PROD_COST) AS ����ݾ��հ�
          FROM BUYER A
         INNER JOIN PROD D ON(D.PROD-BUYER = A.BUYER_ID)
         INNER JOIN BUYPROD B ON(D.PROD_ID = B.BUY_PROD AND
               B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
         INNER JOIN CART C ON(D.PROD_ID = C.CART_PROD AND
               C.CART_NO LIKE '202004%')
         GROUP BY A.BUYER_ID,A.BUYER_NAME 
         ORDER BY 1;
         
   (�ذ� : ��������+�ܺ�����)
     SELECT TB.CID AS �ŷ�ó�ڵ�,
            TB.CNAME AS �ŷ�ó��,
            NVL(TA.BUYSUM,0) AS ���Աݾ��հ�,
            NVL(TB.SELLSUM,0) AS ����ݾ��հ�
       FROM (SELECT A.BUYER_ID AS BID,
                    A.BUYER_NAME AS BNAME,
                    SUM(C.BUY_QTY*C.BUY_COST) AS BUYSUM
               FROM BUYER A
              INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
              INNER JOIN BUYPROD C ON (C.BUY_PROD = B.PROD_ID)
              WHERE C.BUY_DATE BETWEEN ('20200401') AND LAST_DAY('20200401')
              GROUP BY A.BUYER_ID, A.BUYER_NAME) TA,
                    (SELECT A.BUYER_ID AS CID, -- ��������
                            A.BUYER_NAME AS CNAME,
                            SUM(C.CART_QTY*B.PROD_PRICE) AS SELLSUM
               FROM BUYER A
              INNER JOIN PROD B ON (A.BUYER_ID = B.PROD_BUYER)
              INNER JOIN CART C ON (C.CART_PROD = B.PROD_ID)
              WHERE C.CART_NO LIKE ('202004%')
              GROUP BY BUYER_ID, BUYER_NAME) TB
       WHERE TA.BID(+)=TB.CID -- �ܺ���������: �����Ͱ� ���� �ʿ�(+)�� �ٿ����Ѵ�! 
       ORDER BY 1;
              
 ��뿹)������̺��� ��ü����� ��ձ޿����� �� ���� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ,�����,�μ��ڵ�,�޿�
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           A.DEPARTMENT_ID AS �μ��ڵ�,
           A.SALARY AS �޿�
      FROM HR.employees A, 
           (SELECT AVG(SALARY) AS BSAL
              FROM HR.employees) B
     WHERE A.SALARY>B.BSAL
     ORDER BY 3;     
        
        
        
        
        
        
        
        
        
        
        