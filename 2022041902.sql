6. NULL ó���Լ�
    - ����Ŭ�� ��� �÷��� ���� ������� ������ �⺻������ NULL�� �ʱ�ȭ�ȴ�.
    - ���꿡�� NULL�ڷᰡ �����ͷ� ���Ǹ� ��� ����� NULL�� �ȴ�.
    - Ư�� �÷��̳� ������ ����� NULL���� ���θ� �Ǵ��ϱ����� �����ڴ� 
      IS [NOT] NULL
    - NVL, NVL2, NULLIF ���� ����
      1) IS [NOT] NULL
        . Ư�� �÷��̳� ������ ����� NULL���� ���θ� �Ǵ�('='�δ� NULL�� üũ���� ����)
��뿹) ������̺��� ���������� NULL�� �ƴϸ� ������(80�� �μ�)�� ������ �ʴ�
       ����� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ,�����,�μ��ڵ�,��������
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ��ڵ�,
           COMMISSION_PCT AS ��������
      FROM HR.employees
     WHERE COMMISSION_PCT IS NOT NULL --(O)
         -- COMMISSSION_PCT !=NULL   (X)
       AND DEPARTMENT_ID IS NULL;
       
    2) NVL(expr,val)  -- expr = �÷���
      . 'expr'�� ���� NULL�̸� 'val'���� ��ȯ�ϰ�, NULL�� �ƴϸ� EXPR �ڽ���
      ���� ��ȯ
      'expr'�� 'val'�� ���� ������ Ÿ���̾�� ��
      
��뿹) ��ǰ���̺��� ��ǰ�� ũ��(PROD_SIZE)�� NULL�̸� 'ũ������ ����'��
        ũ�������� ������ �� ���� ����Ͻÿ�.
        Alias�� ��ǰ�ڵ�,��ǰ��,���Ⱑ��,��ǰũ��
    SELECT PROD_ID AS ��ǰ�ڵ�,
           PROD_NAME AS ��ǰ��,
           PROD_PRICE AS ���Ⱑ��, --COST ���԰��� -- SALE �����ǸŰ���
           NVL(PROD_SIZE,'ũ������ ����' ) AS ��ǰũ�� --'ũ������ ����'�� ���ڿ��̶� �տ��� ���� ������Ÿ�� ���ڿ��� ��������Ѵ�.
      FROM PROD;
      
��뿹) ������̺��� ��������(COMMISSION_PCT)�� ������ '���ʽ� ���޴���� �ƴ�'��
        ����� ����ϰ�, ��������(COMMISSION_PCT)�� ������ ���ʽ��� ����Ͽ�
        ����Ͻÿ�.
        Alias�� �����ȣ,�����,��������,���
        ���ʽ��� ��������*�޿��� 30%
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           NVL(TO_CHAR(COMMISSION_PCT,0.99) ,'���ʽ� ���޴���� �ƴ�' ) AS ��������,
           NVL(ROUND(COMMISSION_PCT*SALARY*0.3),0) AS ���ʽ�
      FROM HR.employees
      
��뿹) 2020�� 6�� ���(outer join) ��ǰ�� �Ǹ����踦 ��ȸ�Ͻÿ�.
        Alias�� ��ǰ�ڵ�,��ǰ��,�Ǹż����հ�,�Ǹűݾ��հ�
    SELECT B.PROD_ID AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           NVL(SUM(A.CART_QTY),0) AS �Ǹż����հ�,
           NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS �Ǹűݾ��հ�
      FROM CART A         
      RIGHT OUTER JOIN PROD B ON( A.CART_PROD=B.PROD_ID AND
             A.CART_NO LIKE '202006%')
      GROUP BY B.PROD_ID,B.PROD_NAME
      ORDER BY 1;
      
    3) NVL2(expr, val1, val2) --NVL2�� expr��     val1 || val2�� ������Ÿ���� ���� �ʾƵ� �ȴ�.
        . 'expr'�� NULL�� �ƴϸ� 'val1'�� ��ȯ�ϰ�, NULL�̸� 'val2'�� ��ȯ��
        . 'val1'�� 'val2'�� �ݵ�� ���� Ÿ���̾�� ��
      
��뿹) ��ǰ���̺��� ��ǰ�� ũ��(PROD_SIZE)�� NULL�̸� 'ũ������ ����'��
        ũ�������� ������ �� ���� ����Ͻÿ�.  NVL2�� ���
        Alias�� ��ǰ�ڵ�,��ǰ��,���Ⱑ��,��ǰũ��      
      SELECT PROD_ID AS ��ǰ�ڵ�,
             PROD_NAME AS ��ǰ��,
             PROD_PRICE AS ���Ⱑ��,
             NVL2(PROD_SIZE,PROD_SIZE,'ũ������ ����') AS ��ǰũ��
        FROM PROD;
      
��뿹) ������̺��� �����ȣ 119,120,131�� ����� MANAGER_ID���� NULL�� �����Ͻÿ�.
    UPDATE HR.employees
        SET MANAGER_ID = NULL 
     WHERE EMPLOYEE_ID IN(119,120,131);
      
    SELECT * FROM HR.employees;  
       
��뿹) ������̺� �� ������� ���������ȣ�� ��ȸ�Ͻÿ�.
        ��������� ������ '�������� ���'�� ���������ȣ ���� ����ϼ��� NVL2��
        �̿��Ͽ� QUERY�� �ۼ�
        Alias �����ȣ,�����,�μ���ȣ,�������
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ���ȣ,
           NVL2(MANAGER_ID,TO_CHAR(MANAGER_ID),'�������� ����')�������
      FROM HR.employees;
        
** ��ǰ���̺��� �з��ڵ尡 P301 ��ǰ�� ���Ⱑ���� ���԰������� �����Ͻÿ�.
    UPDATE PROD
       SET PROD_PRICE = PROD_COST --�ִ°� ROUND �޴°� TRUNC
     WHERE PROD_LGU ='P301';
        
    (3)NULLIF(col1, col2)
        . 'col1'�� 'col2'�� ������ ���̸� NULL�� ��ȯ�ϰ� ���� ���� �ƴϸ� 
        . 'col1' ���� ��ȯ ��
    
��뿹) ��ǰ���̺��� ���԰��� ���Ⱑ�� �����ϸ� ����� '���� ���� ��ǰ'��
        ���� �ٸ� ���̸� '���� �Ǹ� ��ǰ'�� ����Ͻÿ�.
        Alias�� ��ǰ�ڵ�,��ǰ��,���԰�,���Ⱑ,���
        SELECT PROD_ID AS ��ǰ�ڵ�,
               PROD_NAME AS ��ǰ��,
               PROD_COST AS ���԰�,
               PROD_PRICE AS ���Ⱑ,
               NVL2(NULLIF(PROD_COST,PROD_PRICE),'���� �Ǹ� ��ǰ','���� ���� ��ǰ') AS ���
         FROM PROD;
    
    
    
    
    
    
        