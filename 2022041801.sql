2022-0418-01)
    06) WIDTH_BUCKET(n,min,max,b)
        - min���� max���� ������ b���� �������� ������ �־��� �� n�� ���� ������ 
        �ε��� ���� ��ȯ
        - max ���� ������ ���Ե��� ������, min���� ���� n���� 0(��)����
        max���� ū ���� b+1�����ε����� ��ȯ��(n�� ������ �ȵȴ�.)
��뿹)
    SELECT WIDTH_BUCKET(60,20,80, 4) AS COL1,
           WIDTH_BUCKET(80,20,80, 4) AS COL2, -- MAX �� �ʰ�
           WIDTH_BUCKET(20,20,80, 4) AS COL3,
           WIDTH_BUCKET(100,20,80, 4) AS COL4 -- MAX �� �ʰ�
      FROM DUAL;
��뿹) ȸ�����̺��� 1000~6000 ���ϸ����� 6���� �������� ���������� �� ȸ������
        ���ϸ����� ���� ����� ���Ͽ� ����Ͻÿ�.
        Alias�� ȸ����ȣ,ȸ����,���ϸ���,���
        ��, ����� ���ϸ����� 6000�ʰ��� ȸ�� 1��޿��� ������������� 
        �з��Ͻÿ�.
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_MILEAGE AS ���ϸ���,
              8- WIDTH_BUCKET(MEM_MILEAGE,1000,6000,6) AS ���1, -- 6���� ��� + 1000���� ��� + 6000�ʰ� ��� = �� 8���.
               WIDTH_BUCKET(MEM_MILEAGE,6000,999,6) +1 AS ���2
          FROM MEMBER;
         --  8- ���� �׳� �����ϸ� ����� �ݴ�� ����, 8-�� �ְ� �����ϸ� ��ǥ���� ������ �ȴ�.....
         -- ���� ���� �տ� 8-�� ���� ��,
         
3. ��¥�� �Լ�
    1) SYSDATE
        - �ý��ۿ��� �����ϴ� ��¥�� �ð����� ��ȯ
        - -��+�� ������ ������
        
��뿹) SELECT SYSDATE+3650 FROM DUAL; --����,��� �� �ڵ����� �������.
         
    2) ADD_MONTHS(d,n)
        - �־��� ��¥ d�� n ������ ���� ��¥ ��ȯ
��뿹) SELECT ADD_MONTHS(SYSDATE, 120) FROM DUAL;
        --ROUND�� ���� ���õ� �Ϸ� ���� ���� ��޵ȴ�.?


    3) NEXT_DAY(d, c)
        - �־��� ��¥ ������ ó�� ������ c������ ��¥�� ��ȯ
        - c �� '������', '��' ~ '�Ͽ���','��' �� �ϳ��� ���� ����
��뿹) -- ȯ�漳������ ��¥�� �ѱ۷� �����ؼ� ����� �ѱ۷� ����Ѵ�.
        SELECT NEXT_DAY(SYSDATE, '������'), 
               NEXT_DAY(SYSDATE, '�Ͽ���'),
               NEXT_DAY(SYSDATE, '�����')
          FROM DUAL;
    4) LAST_DAY(d) -- d�� ��¥ Ÿ��. ��/��/���� ���´�.
        - �־��� ��¥�ڷ� d�� ���Ե� ���� ������ ��¥�� ��ȯ
        - �ַ� 2���� ����������(����/���)�� ����Ҷ� ����.
          
��뿹) ������̺��� 2���޿� �Ի��� ��������� ��ȸ�Ͻÿ�.
        Alias�� �����ȣ,�����,�μ���,��å,�Ի����̴�.
        SELECT A.EMPLOYEE_ID AS �����ȣ,
               A.EMP_NAME AS �����,
               B.DEPARTMENT_NAME AS �μ���,
               C.JOB_TITLE AS ����,
               A.HIRE_DATE AS �Ի���
          FROM HR.EMPLOYEES A, HR.departments b, HR.JOBS C -- JOIN ������ ������̺��� n�� �϶� n-1���� �־���Ѵ�.
            -- A,B,C ���̺� ��Ī.  �ߺ��Ǵ� �÷��� �ڿ� ���̺���� ����� �ϴµ� ���̺���� �� ��Ī���.
         WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
           AND C.JOB_ID = A.JOB_ID   
           AND EXTRACT(MONTH FROM A.HIRE_DATE) =2;  --
��뿹) �������̺�(BUYPROD)���� 2020�� 2�� ���ں� �������踦 ���Ͻÿ�.
        Alias�� ��¥,�ż����հ�,���Աݾ��հ��̸� ��¥������ ����Ͻÿ�.
        SELECT BUY_DATE AS ��¥,
               SUM(BUY_QTY) AS �ż����հ�,
               SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND --BUY_DATE���� ������ TO_DATE�� LAST_DAY(TO_DATE)�� ���̸� �����Ѵ�.
               LAST_DAY(TO_DATE('20200201')) -- 2���� ������ ��
        -- WHERE EXTRACT(MONTH FROM BUY_DATE) =2  -- EXTRACT=��¥ ���� / MONTH=�� / expr(FROM �÷�, TO_DATE, SYSDATE) �� ����
        -- �� �����ϴ� ������� 2���� ����� ����
         GROUP BY BUY_DATE -- ����
         ORDER BY 1;    -- 1���� ������� �����ض�.
          
    (5) EXTRACT(fmt FROM d)
        - �־��� ��¥�ڷ� d���� fmt(Format String:���Ĺ��ڿ�)�� ���õ� ���� ��ȯ
        - fmt�� YEAR, MONTH, DAY, HOUR, MINUTE, SECOND  �� �ϳ�
        - ����� �����ڷ��̴�.
        
��뿹) ȸ�����̺��� �̹��޿� ������ �ִ� ȸ���� ��ȸ�Ͻÿ�
        Alias�� ȸ����ȣ, ȸ����, �������, ���ϸ���
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_BIR AS �������,
               MEM_MILEAGE AS ���ϸ���
        FROM MEMBER
       WHERE EXTRACT(MONTH FROM MEM_BIR) =05
        ORDER BY 3;
��뿹) ������ 2020�� 4�� 18���̶�� �����Ҷ� 
        ������̺��� �ټӳ���� 15�� �̻��� ����� ��ȸ�Ͻÿ�.
        Alias�� �����ȣ, �����, �Ի���, �ټӳ��, �޿�
        SELECT EMPLOYEE_ID AS �����ȣ,
               EMP_NAME AS �����, 
               HIRE_DATE AS �Ի���,
               EXTRACT(YEAR FROM TO_DATE('20200418')) - EXTRACT(YEAR FROM HIRE_DATE) AS �ټӳ��,
               SALARY AS �޿�
          FROM HR.employees
         WHERE EXTRACT(YEAR FROM TO_DATE('20200418')) - EXTRACT(YEAR FROM HIRE_DATE) >=15
         ORDER BY 4 DESC;  
         --ORDER BY 4 DESC;  2001����� ��������
         --ORDER BY 4;       2005����� ��������
        
        
        
      