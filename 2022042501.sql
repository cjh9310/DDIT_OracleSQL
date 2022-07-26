2022-0425-02)�ܺ�����(OUTER JOIN)
 - �ڷ��� ������ ���� ���̺��� �������� �����ϴ� ����
 - �ڷᰡ ������ ���̺� NULL ���� �߰��Ͽ� ���� ����
 - �ܺ����� ������'(+)'�� �ڷᰡ �����ʿ� �߰�
 - �������� �� �ܺ������� �ʿ��� ��� ���ǿ� '(+)'�� ����ؾ���
 - ���ÿ� �� ���̺��� �ٸ� �� ���� ���̺�� �ܺ����� �� �� ����. �� A,B,C ���̺��� �ܺ����ο�
   �����ϰ� A�� �������� B�� Ȯ��Ǿ� ���εǰ� ���ÿ� C�� �������� B�� Ȯ��Ǵ� �ܺ�������
   ������ �ʴ´�. (A = B(+) AND C = B(+))
 - �Ϲ����ǰ� �ܺ����������� ���ÿ� �����ϴ� �ܺ������� �������ΰ���� ��ȯ�� => ANSI�ܺ������̳�
   ���������� �ذ� --���������� �ܺ������� ���� ���°� ���� �����ϴ�.
    (�Ϲݿܺ����� �������)
    SELECT �÷�list
      FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,...]
     WHERE ��������(+);
             :

    (ANSI�ܺ����� �������)  --LEFT RIGHT FULL �߿� �ϳ��� ���
    SELECT �÷�list
      FROM ���̺��1 [��Ī1]      
      LEFT|RIGHT|FULL OUTER JOIN ���̺��2[��Ī2] ON(��������  [AND �Ϲ�����])
             :        -- WHERE���� �Ϲ������� ����ϸ� �ȵǰ� AND�� �� �Ŀ� �Ϲ������� �������ش�.
     [WHERE �Ϲ�����]; -- FROM���� ���� ���̺��� ������ ���� �� ������ LEFT 
                      -- OUTER JOIN �����ʿ� �ִ� ���̺��� ������ ���� �� ������ RIGHT   �𸣸� �ϳ� ���  �ٲ㼭 �غ���
     . LEFT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���
     . RIGHT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���
     . FULL : FROM���� ����� ���̺�� JOIN���� ���̺��� �ڷᰡ ���� ������ ���
     
��뿹) ��ǰ���̺��� ��� �з��� ��ǰ�� ���� ��ȸ�Ͻÿ�.    -- ��� -> OUTER JOIN�� ���
        SELECT LPROD_GU AS �з��ڵ�,
               COUNT(PROD_ID) AS "��ǰ�� ��"    -- COUNT(*)�� ������ ��ǰ�� ���� 0�̾ƴ϶� 1�� ��� ��...
          FROM LPROD A, PROD B
         WHERE A.LPROD_GU = B.PROD_LGU(+)
         GROUP BY LPROD_GU
         ORDER BY 1;
     
     
��뿹) ������̺��� ��� �μ��� ������� ��ձ޿��� ��ȸ�Ͻÿ�.
        ��! ��ձ޿��� ������ ����ϼ���
        SELECT B.DEPARTMENT_NAME AS �μ���,
               COUNT(*) AS "�μ��� ��� ��",
               NVL(ROUND(AVG(A.SALARY)),0) AS �޿�  -- NVL�� NULL�� 0���� 
          FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
         WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID(+)
         GROUP BY B.DEPARTMENT_NAME
         ORDER BY 3 DESC;
               
        
        SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
               B.DEPARTMENT_NAME AS �μ���,
               COUNT(A.EMPLOYEE_ID) AS �����,
               ROUND(AVG(A.SALARY)) AS ��ձ޿�
          FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
         WHERE A.DEPARTMENT_ID(+) = B.DEPARTMENT_ID
   --        AND A.DEPARTMENT_ID = B.DEPARTMENT_ID(+)   �� �� (+)�� �ؾ� �ϴµ� OUTER JOIN�� (+) �ϳ��� ����.
         GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME  -- �μ��ڵ�, �μ��� �ִ밪? �Ѱ�ġ��  NULL�� ���;���
         ORDER BY 1;                                 -- �̷���� ANSI�� �ذ��� �� �ִ�.
     
(ANSI)     
        SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
               B.DEPARTMENT_NAME AS �μ���,
               COUNT(A.EMPLOYEE_ID) AS �����,
               ROUND(AVG(A.SALARY)) AS ��ձ޿�
          FROM HR.EMPLOYEES A
          FULL OUTER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
         GROUP BY B.DEPARTMENT_ID,B.DEPARTMENT_NAME
         ORDER BY 1;
     
��뿹) ��ٱ������̺��� 2020�� 6�� ��� ȸ���� �����հ踦 ���Ͻÿ�.
            
        SELECT C.MEM_ID AS ȸ����ȣ,
               C.MEM_NAME AS ȸ����,
               SUM(A.CART_QTY*PROD_PRICE) AS �����հ� --CART �� PROD�� ���� �ڵ尡 ������ ��.
          FROM CART A, PROD B, MEMBER C
         WHERE A.CART_PROD = B.PROD_ID
           AND C.MEM_ID = A.CART_MEMBER(+)
           AND SUBSTR(A.CART_NO,1,8) BETWEEN '20200601' AND '20200630' 
         GROUP BY C.MEM_ID, MEM_NAME;
     
 �ذ� : ANSI    

        SELECT C.MEM_ID AS ȸ����ȣ,
               C.MEM_NAME AS ȸ����,
               NVL(SUM(A.CART_QTY*PROD_PRICE),0) AS �����հ� --CART �� PROD�� ���� �ڵ尡 ������ ��.
          FROM CART A
         RIGHT OUTER JOIN MEMBER C ON(A.CART_MEMBER = C.MEM_ID)
         LEFT OUTER JOIN PROD B ON(B.PROD_ID = A.CART_PROD AND      -- �ܰ� ������.
                                    A.CART_NO LIKE '202006%')-- �Ϲ�����.
         GROUP BY C.MEM_ID,C.MEM_NAME
         ORDER BY 1;
         -- �����հ迡 NULL�� �� ������� ���Ÿ� ���� ���� �����.
     
     
     
        SELECT C.MEM_ID AS ȸ����ȣ,
               C.MEM_NAME AS ȸ����,
               NVL(SUM(A.CART_QTY*PROD_PRICE),0) AS �����հ� --CART �� PROD�� ���� �ڵ尡 ������ ��.
          FROM CART A
         RIGHT OUTER JOIN MEMBER C ON(A.CART_MEMBER = C.MEM_ID)
         LEFT OUTER JOIN PROD B ON(B.PROD_ID = A.CART_PROD)-- �Ϲ�����.
        WHERE A.CART_NO LIKE '202006%'  -- 6���� ����. ���� ������ ���� ������ ����� �߿��� 6��
         GROUP BY C.MEM_ID,C.MEM_NAME
         ORDER BY 1;
         
(��������)
    �������� : 2020�� 6�� ȸ���� �Ǹ����� --��������
    SELECT A.CART_MEMBER AS AID,
           SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
      FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID  --�ܰ�
       AND A.CART_NO LIKE '202006%'
     GROUP BY A.CART_MEMBER;
    �������� : ������������� MEMBER ���̿� �ܺ�����
    SELECT TB.MEM_ID AS ȸ����ȣ,
           TB.MEM_NAME AS ȸ����,
           NVL(TA.ASUM,0) AS �����հ�
      FROM ( SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS ASUM
               FROM CART A, PROD B
              WHERE A.CART_PROD = B.PROD_ID  --�ܰ�
                    AND A.CART_NO LIKE '202006%'
              GROUP BY A.CART_MEMBER) TA,
             MEMBER TB
     WHERE TA.AID(+) = TB.MEM_ID
     ORDER BY 1;
         
         