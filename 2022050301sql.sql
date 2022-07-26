2022-0503-01) PL/SQL (Procedual Language SQL)
    - ǥ�� SQL�� Ȯ��
    - ������ ����� Ư¡�� ����(��,�ݺ�,����,��� ��)
    - �̸� ������ ����� �������Ͽ� ������ �����ϰ� �ʿ�� ȣ�����
    - ���ȭ/ĸ��ȭ
    - Anonymous Block, Stored Procedure(��ȯ���� ����), User Defined Function(�Լ�), Trigger,
      Package ���� ������ --��ȯ���� ������ SELECT���� �����ų �� ���� (���������ؾ���)
    -- ������ �޸� �ʿ�

1. Anonymous Block
    - ���� �⺻���� pl/sql ���� ����
    - ���𿵿��� ���࿵������ ����
    - ������� ���� --������ �ڵ尡 ������� �ʴ� �� (�ٽ� �� �� ����)
(�������)
    DECLARE
     �����(����,���,Ŀ��(VIEW) ����)
    BEGIN
     �����(�����Ͻ� ���� ó���� ���� SQL��)
     [EXCEPTION
       ����ó����
     ]
    END;

��뿹) �泲�� �����ϴ� ȸ������ 2020�� 5�� ���Ž����� ��ȸ�Ͻÿ�.
    DECLARE
        V_MID MEMBER.MEM_ID%TYPE;   -- ȸ����ȣ
        V_MNAME MEMBER.MEM_NAME%TYPE; -- ȸ���̸�
        V_AMT NUMBER :=0; -- ���űݾ��հ�
        CURSOR CUR_MEM IS
            SELECT MEM_ID,MEM_NAME
              FROM MEMBER
             WHERE MEM_ADD1 LIKE '�泲%';
    BEGIN
     OPEN CUR_MEM;
     LOOP
        FETCH CUR_MEM INTO V_MID, V_MNAME;
         EXIT WHEN CUR_MEM%NOTFOUND;
        SELECT SUM(B.PROD_PRICE*A.CART_QTY) INTO V_AMT
          FROM CART A, PROD B
         WHERE A.CART_PROD = B.PROD_ID
           AND A.CART_NO LIKE '202005%'
           AND A.CART_MEMBER = V_MID;
        DBMS_OUTPUT.PUT_LINE('ȸ����ȣ : '|| V_MID);
        DBMS_OUTPUT.PUT_LINE('ȸ���� : '|| V_MNAME);
        DBMS_OUTPUT.PUT_LINE('�����հ� : '|| V_AMT);
        DBMS_OUTPUT.PUT_LINE('---------------------');
        END LOOP;
        CLOSE CUR_MEM;
    END;

    1) ������ ���
        - BEGIN ~ END ��Ͽ��� ����� ���� �� ��� ����
        (��������)
        --������ NUMBERŸ���� ��� �ʱ�ȭ��Ų��. , ����� ��� �ݵ�� �ʱ�ȭ��Ų��.
        ������ [CONSTANT] ������Ÿ��|����Ÿ�� [:=�ʱⰪ];
        . ������ ���� 
         - SCLAR ���� : �ϳ��� ���� �����ϴ� �Ϲ��� ����
         - ������ ���� : �ش� ���̺��� ��(ROW)�� �÷�(COLUMN)�� Ÿ�԰� ũ�⸦ �����ϴ� ����
         - BIND���� : �Ķ���ͷ� �Ѱ����� ���� �����ϱ����� ����
        . ��� ������ CONSTANT ���� ����ϸ� �̶� �ݵ�� �ʱⰪ�� �����ؾ� ��
        . ������Ÿ��
         - SQL���� ����ϴ� �ڷ�Ÿ��
         - PLS_INTEGER, BINARY_INTEGER -> 4 byte ����
         - BOOLEAN ��� ���� -- true, false, NULL
        . ������ ������ ����� �ݵ�� �ʱ�ȭ�� �ؾߵ�.
        . ������
         - ������ : ���̺��.�÷���%TYPE
         - ������ : ���̺��%ROWTYPE

��뿹) Ű����� �⵵�� ���� �Է� �޾� �ش� �Ⱓ���� ���� ���� ���Աݾ��� �����
       ��ǰ�� ��ȸ�Ͻÿ�.
        ACCEPT P_PERIOD PROMPT '�Ⱓ(�⵵/��) �Է� : '   -- �Է�â
        DECLARE
            S_DATE DATE := TO_DATE(&P_PERIOD|| '01'); --&P_PERIOD|| '01'�� TO_DATE�� �ٲٱ�
            E_DATE DATE := LAST_DAY(S_DATE);
            V_PID PROD.PROD_ID%TYPE;        --PROD_ID�� ���� TYPE
            V_PNAME PROD.PROD_NAME%TYPE;
            V_AMT NUMBER := 0;  --�ʱ�ȭ
        BEGIN
            SELECT TA.BID,TA.BNAME,TA.BSUM  INTO V_PID,V_PNAME,V_AMT
              FROM (SELECT B.BUY_PROD AS BID,
                           A.PROD_NAME AS BNAME,
                           SUM(A.PROD_COST*BUY_QTY) AS BSUM
                      FROM PROD A, BUYPROD B
                     WHERE B.BUY_DATE BETWEEN S_DATE AND E_DATE
                       AND A.PROD_ID = B.BUY_PROD
                     GROUP BY B.BUY_PROD, A.PROD_NAME
                     ORDER BY 3 DESC) TA
             WHERE ROWNUM =1;
             
             DBMS_OUTPUT.PUT_LINE('��ǰ�ڵ� : '|| V_PID);
             DBMS_OUTPUT.PUT_LINE('��ǰ�� : '|| V_PNAME);
             DBMS_OUTPUT.PUT_LINE('���Աݾ��հ� : '|| V_AMT);
             
             
             
            DBMS_OUTPUT.PUT_LINE(S_DATE);
        END;
       
       

��뿹) ������ �μ��ڵ带 �����Ͽ� �ش�μ��� ������� �Ի��� ��������� ��ȸ�Ͻÿ�.
       Alias �����ȣ,�����,�μ���,�����ڵ�,�Ի���
       
    DECLARE
        V_EID HR.employees.EMPLOYEE_ID%TYPE;
        V_ENAME HR.employees.EMP_NAME%TYPE;
        V_DNAME HR.departments.department_NAME%TYPE;
        V_JOBID HR.employees.JOB_ID%TYPE;
        V_HDATE DATE;
        V_DID HR.employees.DEPARTMENT_ID%TYPE := TRUNC(dbms_random.value(10,110),-1); 
        -- �μ��ڵ� �ϳ� ���Ƿ� �����ؼ� DID��
    BEGIN 
        SELECT TA.EID, TA.ENAME,TA.DNAME,TA.JID,TA.HDATE 
        INTO V_EID,V_ENAME,V_DNAME,V_JOBID,V_HDATE
        -- INTO�����Ἥ ������ �س��� V_EID��
        
          FROM (SELECT A.EMPLOYEE_ID AS EID,
                       A.EMP_NAME AS ENAME,
                       B.DEPARTMENT_NAME AS DNAME,
                       A.JOB_ID AS JID,
                       A.HIRE_DATE AS HDATE
                  FROM HR.employees A, HR.departments B
                 WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
                   AND A.DEPARTMENT_ID = V_DID
                 ORDER BY A.HIRE_DATE) TA
        WHERE ROWNUM =1;
        DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
        DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
        DBMS_OUTPUT.PUT_LINE('�μ��� : '||V_DNAME);
        DBMS_OUTPUT.PUT_LINE('�����ڵ� : '||V_JOBID);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
    END;
    

    
       
       
       
       









