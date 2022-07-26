2022-05-11)
<�н���ǥ>
1. Procedure(���ν���) + SCHEDULER(�����ٷ�)
2. Exception
3. Trigger

/*
����Ŭ �����ٷ� ����ϱ�!
�����ٷ�?
    - Ư���� �ð��� �Ǹ� �ڵ������� ����(query) ����� ����ǵ��� �ϴ� ���
*/
/
SELECT MEM_ID, MEM_MILEAGE
  FROM MEMBER
 WHERE MEM_ID = 'a001';
/
EXEC USP_UP_MEMBER_MIL;
/
CREATE OR REPLACE PROCEDURE USP_UP_MEMBER_MIL
IS
BEGIN

UPDATE MEMBER
   SET MEM_MILEAGE = MEM_MILEAGE +10
 WHERE MEM_ID = 'a001';
 
 COMMIT;
END;
/
-- ������ ����
DECLARE
    -- ������ JOB ���� ���̵�. ������ ����
    V_JOB NUMBER(5);
BEGIN
    DBMS_JOB.SUBMIT(
        V_JOB,               -- JOB ���̵�
        'USP_UP_MEMBER_MIL;', -- ������ ���ν��� �۾�
        SYSDATE,              -- ���� �۾��� ������ �ð�
        'SYSDATE + (1/1440)', -- 1�и���
        FALSE                -- �Ľ�(�����м�, �ǹ̺м�)����
    );
    DBMS_OUTPUT.PUT_LINE('JOB IS ' || TO_CHAR(V_JOB));
    COMMIT;
END;
/
-- �����ٷ��� ��ϵ� �۾��� ��ȸ
SELECT * FROM USER_JOBS;
/
-- �����ٷ����� ��ϵ� �۾� ����
BEGIN
    DBMS_JOB.REMOVE();  -- ��ȣ�ȿ� ��ȸ��� �� ����� ���� JOB��ȣ�� �����ش�.
END;
/
SELECT SYSDATE,
       TO_CHAR(SYSDATE + (1/1440),'YYYY-MM-DD HH24:MI:SS'), -- 1�е�
       TO_CHAR(SYSDATE + (1/24),'YYYY-MM-DD HH24:MI:SS'),   -- 1�ð���
       TO_CHAR(SYSDATE + 1,'YYYY-MM-DD HH24:MI:SS')         -- 1�ϵ�
  FROM DUAL;
/
/*
EXCEPTION
    - PL/SQL���� ERROR�� �߻��ϸ� EXCEPTION�� �߻��ǰ�
      �ش����� �����ϸ� ����ó���κ����� �̵���
    (���� ����)
    - ���ǵ� ����
        PL/SQL���� ���� �߻��ϴ� ERROR�� �̸� ������
        ������ �ʿ䰡 ���� �������� �Ͻ������� �߻���
        1) NO_DATE_FOUND : �������
        2) TOO_MANY_ROWS : ������ ����
        3) DUP_VAR_ON_INDEX : ������ �ߺ� ����(P.K / U.K)
        4) VALUE_ERROR : �� �Ҵ� �� ��ȯ �� ����
        5) INVALID_NUMBER : ���ڷ� ��ȯ�� �ȵ� EX) TO_NUMBER('������')
        6) HOT_LOGGED_ON : DB�� ������ �ȵǾ��µ� ����
        7) LOGIN_DENIED : �߸��� ����� / �߸��� ��й�ȣ
        8) ZERO_DIVIDE : 0���� ����
        9) INVALID_CURSOR : ������ ���� Ŀ���� ����
        
    - ���ǵ��� ���� ����
        ��Ÿ ǥ�� ERROR
        ������ �ؾ� �ϸ� �������� �Ͻ������� �߻�
        
    - ����� ���� ����
        ���α׷��Ӱ� ���� ���ǿ� �������� ���� ��� �߻�
        ������ �ؾ� �ϰ�, ��������� RAISE���� ����Ͽ� �߻�
*/
/
SET SERVEROUT ON;
/
-- ���ǵ� ����
-- 1. 
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME �� '����ĳ�־�' �� �Ҵ��
    SELECT LPROD_NM INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P201'; 
     DBMS_OUTPUT.PUT_LINE('�з��� : ' || V_NAME);
     -- �ذ��
     EXCEPTION
          WHEN NO_DATA_FOUND THEN --. ORA-01403 (���� ���� �ذ�)
               DBMS_OUTPUT.PUT_LINE('�ش� ������ �����ϴ�.');
          
END;
/
-- 2. LPROD_GU = 'P20%';
/
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME �� '����ĳ�־�' �� �Ҵ��
    SELECT LPROD_NM INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P20%'; 
     DBMS_OUTPUT.PUT_LINE('�з��� : ' || V_NAME);
     -- �ذ��
     EXCEPTION
          WHEN TOO_MANY_ROWS THEN  --ORA-01422
               DBMS_OUTPUT.PUT_LINE('�Ѱ� �̻��� ���� ���Խ��ϴ�.');
END;
/
-- 3. LPROD_NM+10
DECLARE
    V_NAME VARCHAR2(20);
BEGIN
        -- V_NAME �� '����ĳ�־�' �� �Ҵ��
    SELECT LPROD_NM+10 INTO V_NAME
      FROM LPROD
     WHERE LPROD_GU = 'P201'; 
     DBMS_OUTPUT.PUT_LINE('�з��� : ' || V_NAME);
     -- �ذ��
     EXCEPTION
          WHEN NO_DATA_FOUND THEN --. ORA-01403 (���� ���� �ذ�)
               DBMS_OUTPUT.PUT_LINE('�ش� ������ �����ϴ�.');
          WHEN TOO_MANY_ROWS THEN  --ORA-01422
               DBMS_OUTPUT.PUT_LINE('�Ѱ� �̻��� ���� ���Խ��ϴ�.');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('��Ÿ ���� : ' || SQLERRM);
END;
/

-- ���ǵ��� ���� ����
/
DECLARE
    -- excetion Ÿ���� exp_reference ���� ����
    exp_reference EXCEPTION; --1
    -- EXCEPTION_INIT�� ���� �����̸��� ������ȣ�� �����Ϸ����� �����
    PRAGMA EXCEPTION_INIT(exp_reference, -2292); --1
BEGIN
    -- ORA-02292 ���� �߻� -- �ذ���(1)
    DELETE FROM LPROD WHERE LPROD_GU = 'P101';
    DBMS_OUTPUT.PUT_LINE('�з� ����');
    EXCEPTION --1
        WHEN exp_reference THEN--1
             DBMS_OUTPUT.PUT_LINE('���� �Ұ�');--1
END;
/
SELECT *
  FROM USER_CONSTRAINTS
 WHERE CONSTRAINT_NAME ='FR_BUYER_LGU';
 /
 
    -- ����� ���� ����
ACCEPT p_lgu PROMPT '����Ϸ��� �з��ڵ� �Է�: '
DECLARE
    -- exception Ÿ���� ���� ����
    exp_lprod_gu EXCEPTION;
    v_lgu VARCHAR2(10) := UPPER('&p_lgu'); --p_lgu���� UPPER �빮�ڷ� ��ȯ�ǰ� v_lgu�� ����
BEGIN
    IF v_lgu IN('P101','P102','P201','P202') THEN
    -- ����ο��� RAISE�������� ��������� EXCEPTION�� �߻���
        RAISE exp_lprod_gu;
    END IF;
    DBMS_OUTPUT.PUT_LINE(V_LGU || '�� ��ϰ���');
    
    EXCEPTION
        WHEN exp_lprod_gu THEN
            DBMS_OUTPUT.PUT_LINE(v_lgu || '�� �̹� ��ϵ� �ڵ��Դϴ�.');
END;
/

SELECT LPROD_GU FROM LPROD;

/

-- DEPARTMENT ���̺� �а��ڵ带 '�İ�',
-- �а����� '��ǻ�Ͱ��а�', ��ȭ��ȣ�� '765-4100'
-- ���� INSERT
/
DECLARE
BEGIN
    INSERT INTO DEPARTMENT(DEPT_ID,DEPT_NAME,DEPT_TEL)
    VALUES('�İ�','��ǻ�Ͱ��а�','765-4100');
    COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             DBMS_OUTPUT.PUT_LINE('�ߺ��� �ε��� ���� �߻�!');
        WHEN OTHERS THEN
            NULL;
END;
/

SELECT *FROM USER_CONSTRAINTS
 WHERE CONSTRAINT_NAME ='DEPARTMENT_PK';
 /
/*
COURSE ���̺��� �����ڵ尡 'L1031'�� ���Ͽ�
�߰� ������(COURSE_FEES)�� '�︸��;���� �����غ���
[������ ������Ÿ���� ������ ���� �߻�]
*/
/
DECLARE
BEGIN
UPDATE COURSE
   SET COURSE_FEES ='�︸��'
 WHERE COURSE_ID ='L1031';
    COMMIT;
    EXCEPTION
        WHEN INVALID_NUMBER THEN
            DBMS_OUTPUT.PUT_LINE('�߸��� ���� ���� �߻�!');
        WHEN OTHERS THEN
        NULL;
END;
/
/*
SG_SCORES ���̺� ����� SCORE �÷��� ������
100���� �ʰ��Ǵ� ���� �ִ��� �����ϴ� ����� �ۼ��غ���
��, 100�� �ʰ� �� OVER_SCORE ���ܸ� �����غ���
[��������� ���ܷ� ó���غ���]
*/
INSERT INTO SG_SCORES(STUDENT_ID,COURSE_ID,SCORE,SCORE_ASSIGNED)
VALUES('A1701','L0013',107,'2010/12/29');
COMMIT;
/
DECLARE
    OVER_SCORE EXCEPTION;
    V_SCORE SG_SCORES.SCORE%TYPE;
BEGIN
    -- �ݺ����� ����Ͽ� SCORE�� 100�� �ʰ��ϸ�
    -- �� SCORE���� V_SCORE ������ �ְ�
    -- RAISE OVER SCORE;�� ������
    -- [���ܸ޼��� : 107������ 100���� �ʰ��մϴ�]
    IF SCORE >100 THEN
    V_SCORE NUMBER  := SCORE;
     RAISE VALUE_ERROR SCORE;
    END IF;
        EXCEPTION
        WHEN  VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE(V_SCORE || '�� 107������ 100���� �ʰ��մϴ�.');
    
END;
/