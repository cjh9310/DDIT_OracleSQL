2022-0427-01)��������
    - SQL�� �ȿ� �����ϴ� �� �ٸ� SQL��
    - SQL���� �ȿ� ������ ���Ǵ� �߰� ����� ��ȯ�ϴ� SQL��
    - �˷����� ���� ���ǿ� �ٰ��� ������ �˻��ϴ� SELECT���� ���
    - ���������� �˻���(SELECT)�Ӹ��ƴ϶� DML(INSERT,UPDATE,DELETE)�������� ����
    - �ڼ��������� '( )'�ȿ� ����Ǿ�� �� (��,(����) INSERT���� ����ϴ� SUBQUERY�� ����)
    - ���������� �ݵ�� ������ �����ʿ� ����ؾ���(���������� ���)
    - ���� ��� ��ȯ ��������(������ ������:>,<,>=,<=,=,!=)
      vs ���� ��� ��ȯ ��������(������ ������: IN ALL, ANY, SOME, EXISTS)
    - ������ �ִ� �������� vs ������ ���� ��������
    - �Ϲݼ�������(SELECT���� ������) vs in-line ��������(FROM���� ������ ��! �ݵ�� ��������Ǿ���Ѵ�.)
      vs ��ø��������(WHERE���� ������)   -- ��ġ�� ����
    
1. ������ ���� ��������
    - ���������� ���̺�� ���������� ���̺��� �������� ������� ���� ���
    
��뿹) ������̺��� ������� ��ձ޿����� ���� �޿��� �޴� ����� ��ȸ�Ͻÿ�.
        Alias�� �����ȣ,�����,�μ���,�޿�
    (�������� : ������� �����ȣ,�����,�μ���,�޿��� ��ȸ )
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           A.SALARY AS �޿�
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_NAME -- ������ ����ϴ� ����: �μ��� ������.  
       AND A.SALARY>(��ձ޿�);
    
    (�������� : ��ձ޿� ) --��ձ޿� ���.
    SELECT AVG(SALARY)
      FROM HR.employees
      
    (����)      
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           A.SALARY AS �޿�
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID -- ������ ����ϴ� ����: �μ��� ������.  
       AND A.SALARY>=(SELECT AVG(SALARY)
                             FROM HR.employees);    
                             -- ��� ���Ҷ����� AVG�����.
                             -- ���������� ���Ƚ���� ��� ����ŭ
    -- �̰� ������ ���� ��������  (���������� ���������� ���ε��� �ʾ���.)
    
    (��ձ޿� ���)    
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           A.SALARY AS �޿�,
           (SELECT ROUND(AVG(SALARY))
                FROM HR.employees) AS ��ձ޿�
      FROM HR.employees A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID   
       AND A.SALARY>(SELECT AVG(SALARY)
                             FROM HR.employees);      
    
    (in-line view ��������)    
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_NAME AS �μ���,
           ROUND(C.ASAL) AS ��ձ޿�
      FROM HR.employees A, HR.DEPARTMENTS B,
            (SELECT AVG(SALARY) AS ASAL               
        --���������� �÷��� AS�� ��¿��� �ƴ϶� �������̴� �׷��Ƿ� ���⿡�� �ѱ��� �ƴ϶� ��� �������.
        -- ���������� ����Ƚ���� 1��!
                             FROM HR.employees) C  --(in-line view ��������)  �׸��� ���̺��� 3��
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID   --Equi-Join
       AND A.SALARY>C.ASAL;        -- Non Equi-Join
     -- 3�� �� �����ؼ� �̵��� ������ ����� ��.  + ������ �ִ� ��������
    
2. ������ �ִ� ��������
    - ���������� ���������� �������� ����� ���
    - ��κ��� ��������
    
��뿹) �����������̺�(JOB_HISTORY)�� �μ����̺��� �μ���ȣ�� ���� 
       �ڷḦ ��ȸ�Ͻÿ�.
       Alias�� �μ���ȣ,�μ����̴�.
       
(IN ������ �̿�)
       SELECT A.DEPARTMENT_ID AS �μ���ȣ,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.departments A
        WHERE A.DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                                FROM HR.JOB_HISTORY B
                               WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID);
    -- �ٱ��� FROM,WHERE���� ���� ����Ǿ IN�ڿ� �ִ� ���������� ������ ���� ����� ������ �� �� ����.
    
EXISTS �������� ���������� ���;���  ���� EXISTS�� �������� ����� �� ���̶� ������ TRUE ������ FALSE

(EXISTS ������ �̿�)
       SELECT A.DEPARTMENT_ID AS �μ���ȣ,
              A.DEPARTMENT_NAME AS �μ���
         FROM HR.departments A   --EXISTS�ڸ����� �ƹ��͵� ���� �ʴ´�.
        WHERE EXISTS (SELECT 1  --or 1(�μ����̵�)�� *�� �ᵵ ������ ��
                        FROM HR.JOB_HISTORY B
                       WHERE B.DEPARTMENT_ID = A.DEPARTMENT_ID); -- ���� �μ��ڵ尡 ������ 1(�ǹ� ���� 1�̴�.)
             -- 1���ᵵ EXISTS Ư���� ������ ��µǸ� ���̶� ����� �˾Ƽ� ����.
    
    -- �ٱ��� FROM,WHERE���� ����ǰ� ������ FROM,WHERE���� ����Ǵµ�
    -- EXISTS�� ���� ������(WHERE)�� ����� �� ���̶� ������ ����� �� ����.
    -- 1�� �ǹ̾���. DEPARTMENT_ID(�μ���ȣ)�̴�. �ƹ��ų� ���� ��� ���µ�?? 
    
��뿹)2020�� 5�� �Ǹŵ� ��ǰ�� �Ǹ����� �� ���� 3�� ��ǰ�� �Ǹ����������� ��ȸ�Ͻÿ�.    
        Alias ��ǰ�ڵ�,��ǰ��,�ŷ�ó��(BUYER),�Ǹűݾ��հ�(PROD + CART)
(�������� : �ݾױ��� ���� 3�� ��ǰ�� ���� ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ�)

    SELECT ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ�
      FROM PROD A, BUYER C   --CART ���̺��� ������������ �ʿ��� �� �� �Ἥ ���� �ʿ����..
     WHERE A.PROD_ID =(���� 3�� ��ǰ�� ��ǰ�ڵ�)
       AND A.PROD_BUYER =C.BUYER_ID;
(�������� : �Ǹű������� �Ǹ����� ����)
    SELECT A.CART_PROD AS CID,    --CID : ��ǰ�ڵ�
           B.PROD_NAME AS CNAME,
           SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM  --CSUM : CID +SUM   ���������� ���� ��ȣ.
      FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID  
       AND A.CART_NO LIKE '202005%'   --LIKE�����ڴ� ���������Ҷ� ����� �� �� ����.
     GROUP BY A.CART_PROD, B.PROD_NAME
     ORDER BY 3 DESC;
     
(����)
    SELECT C.CID AS ��ǰ�ڵ�,
           C.CNAME AS ��ǰ��,
           B.BUYER_NAME AS �ŷ�ó��,
           C.CSUM AS �Ǹűݾ��հ�
      FROM PROD A, BUYER B ,
            (SELECT A.CART_PROD AS CID,    --CID : ��ǰ�ڵ�
                    B.PROD_NAME AS CNAME,
                    SUM(A.CART_QTY*B.PROD_PRICE) AS CSUM  --CSUM : CID +SUM   ���������� ���� ��ȣ.
               FROM CART A, PROD B
              WHERE A.CART_PROD = B.PROD_ID  
                AND A.CART_NO LIKE '202005%'   --LIKE�����ڴ� ���������Ҷ� ����� �� �� ����.
              GROUP BY A.CART_PROD, B.PROD_NAME
              ORDER BY 3 DESC) C
              WHERE A.PROD_ID =C.CID
                AND A.PROD_BUYER =B.BUYER_ID
                AND ROWNUM<=3;
     
��뿹)2020�� ��ݱ⿡ ���žױ��� 1000���� �̻��� ������ ȸ�������� ��ȸ�Ͻÿ�.
        Alias�� ȸ����ȣ,ȸ����,����,���ž�,���ϸ���
(��������:ȸ������(ȸ����ȣ,ȸ����,����,���ž�,���ϸ���)�� ��ȸ)

        SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
               B.    AS ���ž�,
               A.MEM_MIELAGE AS ���ϸ���
          FROM MEMBER A, 
                    (1000���� �̻��� ������ ȸ��)B
         WHERE A.MEM_ID = B.ȸ����ȣ;
(��������: 2020�� ��ݱ⿡ ���žױ��� 1000���� �̻�)
-- ���������� ���� A���̺�� B���̺��� �����÷��� �־���ϰ� ������ �������� ���� �����ϱ�.
        SELECT A.CART_MEMBER AS  BID,
               SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
          FROM CART A, PROD B 
         WHERE A.CART_PROD = B.PROD_ID --CART�� ���� �ܰ��� �������� ���ؼ� ����.
           AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
         GROUP BY A.CART_MEMBER
        HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000
        

(����- INLINE VIEW ���) -- FROM����

        SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
               B.BSUM AS ���ž�,
               A.MEM_MILEAGE AS ���ϸ���
          FROM MEMBER A, 
                    (SELECT A.CART_MEMBER AS  BID,
                            SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
                       FROM CART A, PROD B 
                      WHERE A.CART_PROD = B.PROD_ID --CART�� ���� �ܰ��� �������� ���ؼ� ����.
                        AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                      GROUP BY A.CART_MEMBER
                     HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B
                      WHERE A.MEM_ID = B.BID;

(����- ��ø��������) -- WHERE����
    SELECT A.MEM_ID AS ȸ����ȣ,
               A.MEM_NAME AS ȸ����,
               A.MEM_JOB AS ����,
           --    B.BSUM AS ���ž�,
               A.MEM_MILEAGE AS ���ϸ���
      FROM MEMBER A 
     WHERE A.MEM_ID IN(SELECT B.BID    -- B���̺� �ִ� BID
                         FROM (SELECT A.CART_MEMBER AS  BID,
                                      SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM
                                 FROM CART A, PROD B 
                                WHERE A.CART_PROD = B.PROD_ID --CART�� ���� �ܰ��� �������� ���ؼ� ����.
                                  AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                                GROUP BY A.CART_MEMBER
                               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >=10000000)B);
    
    -- REMAIN(��� �������̺�)
 --REMAIN_I (�԰�) REMAIN_O (���) REMAIN_J_99(�⸻���) 
 -- REMAIN_DATE