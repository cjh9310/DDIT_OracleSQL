2022-0504-01) 
2. �ݺ���
    - LOOP, WHILE, FOR���� ������
    - �ַ� Ŀ���� ����ϱ� ���Ͽ� �ݺ����� �ʿ�
    1) LOOP
    . �⺻���� �ݺ������� ���ѷ��� ����
    (�������)
    LOOP
        �ݺ�ó����;
        [EXIT WHEN ����;]
    END LOOP;
    - '����'�� ���϶� �ݺ����� ���(END LOOP ���� ��� ����)
    ��뿹) �������� 6���� ����Ͻÿ�.
    DECLARE
        V_CNT NUMBER:=1;
    BEGIN
        LOOP
            DBMS_OUTPUT.PUT_LINE('6* '||V_CNT||'='||6*V_CNT);
            EXIT WHEN V_CNT>=9; --9���� ũ�ų� ������ END   ;�� �̵��ؼ� ����.
            V_CNT:=V_CNT+1; -- 9���� ������ ����������.(�ݺ�)
        END LOOP;-- ó������ ���ư��� �ݺ���.
    END;
    
��뿹) ������̺��� �����ڵ尡 'SA_REP'�� ��� ������ �͸����� ����Ͽ� ����Ͻÿ�
       ����� ������ �����ȣ,�����,�Ի����̴�.
    
    DECLARE
        V_EID HR.employees.EMPLOYEE_ID%TYPE;
        V_ENAME HR.employees.EMP_NAME%TYPE;
        V_HDATE DATE;
        CURSOR CUR_EMP01 IS
            SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
              FROM HR.employees
             WHERE JOB_ID='SA_REP';
    BEGIN
        OPEN CUR_EMP01;
        LOOP
            FETCH CUR_EMP01 INTO V_EID, V_ENAME,V_HDATE;
            EXIT WHEN CUR_EMP01 % NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
            DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
            DBMS_OUTPUT.PUT_LINE('------------------');
        END LOOP;
        CLOSE CUR_EMP01;
    END;

2) WHILE��
    . ������ �Ǵ��Ͽ� �ݺ��� �������� ���θ� �Ǵ��ϴ� �ݺ���
    (�������)
    WHILE ���� LOOP
      �ݺ�ó����(��);
    END LOOP;
    - '����'�� ���̸� �ݺ��� �����ϰ� '����'�� �����̸� �ݺ����� ���
    
��뿹) �������� 6���� ����Ͻÿ�(WHILE�� ���)
    
    DECLARE
        V_CNT NUMBER :=1;
    BEGIN
        WHILE V_CNT <=9 LOOP
            DBMS_OUTPUT.PUT_LINE('6* '||V_CNT||' = '||6*V_CNT);
            V_CNT :=V_CNT+1;
        END LOOP; 
    END;
    
��뿹) ������̺��� �����ڵ尡 'SA_MAN'�� ��� ������ �͸����� ����Ͽ� ����Ͻÿ�
       ����� ������ �����ȣ,�����,�Ի����̴�.    
    DECLARE
    V_EID HR.employees.EMPLOYEE_ID%TYPE;
    V_ENAME HR.employees.EMP_NAME%TYPE;
    V_HDATE DATE;
    CURSOR CUR_EMP02 IS
    SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
      FROM HR.employees
     WHERE JOB_ID ='SA_MAN';
    BEGIN
        OPEN CUR_EMP02;
        FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE;
        WHILE CUR_EMP02%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('�����ȣ : '||V_EID);
            DBMS_OUTPUT.PUT_LINE('����� : '||V_ENAME);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : '||V_HDATE);
            DBMS_OUTPUT.PUT_LINE('------------------');
            FETCH CUR_EMP02 INTO V_EID,V_ENAME,V_HDATE;
            END LOOP;
            CLOSE CUR_EMP02;
            END;

3) FOR��
    . ����Ƚ���� �߿��ϰų� �˰� �ִ� ��� ���
    (�Ϲ��� FOR�� �������)
    FOR �ε��� IN [REVERSE] �ʱⰪ..������ LOOP -- ..�� �ݵ�� ����� �� , REVERSE ��
        �ݺ�ó����ɹ�(��);
    END LOOP;

��뿹) ������ 6�� ���
    DECLARE
    BEGIN
        FOR I IN 1..9 LOOP
         DBMS_OUTPUT.PUT_LINE('6 * '||I||' = '||I*6);
        END LOOP;
    END;
    
    DECLARE    
    BEGIN
        FOR I IN REVERSE 1..9 LOOP
         DBMS_OUTPUT.PUT_LINE('6 * '||I||' = '||I*6);
        END LOOP;
    END;
    
    
    
    (Ŀ���� FOR�� �������)
    FOR ���ڵ�� [IN] Ŀ����|Ŀ����SELECT�� LOOP 
        Ŀ��ó����
    END LOOP;
        . 'Ŀ����|Ŀ����SELECT��' : Ŀ���� ����ο��� ������ ��� Ŀ������ ���,
          in-line �������� Ŀ���� SELECT ���� ���� ��� ����
        . OPEN, FETCH, CLOSE���� ������� ����
        . Ŀ������ �÷��� ������ '���ڵ��.Ŀ���÷���' �������� ������



��뿹) ������̺��� �����ڵ尡 'SA_MAN'�� ��� ������ �͸����� ����Ͽ� ����Ͻÿ�
       ����� ������ �����ȣ,�����,�Ի����̴�.    
       
    DECLARE
    CURSOR CUR_EMP03 IS
    SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
      FROM HR.employees
     WHERE JOB_ID ='SA_MAN';
    BEGIN
        FOR REC IN CUR_EMP03 LOOP
            DBMS_OUTPUT.PUT_LINE('�����ȣ : '||REC.EMPLOYEE_ID);
            DBMS_OUTPUT.PUT_LINE('����� : '||REC.EMP_NAME);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : '||REC.HIRE_DATE);
            DBMS_OUTPUT.PUT_LINE('------------------');
            END LOOP;
            END;


    DECLARE
    CURSOR CUR_EMP03 IS
    SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE
      FROM HR.employees
     WHERE JOB_ID ='SA_MAN';
    BEGIN
        FOR REC IN REVERSE CUR_EMP03 LOOP
            DBMS_OUTPUT.PUT_LINE('�����ȣ : '||REC.EMPLOYEE_ID);
            DBMS_OUTPUT.PUT_LINE('����� : '||REC.EMP_NAME);
            DBMS_OUTPUT.PUT_LINE('�Ի��� : '||REC.HIRE_DATE);
            DBMS_OUTPUT.PUT_LINE('------------------');
            END LOOP;
            END;


    