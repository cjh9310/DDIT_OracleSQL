2022-0512-01)
<�н���ǥ>
1. Trigger(Ʈ����)

- Ư�� �̺�Ʈ�� �߻��Ǳ� �� Ȥ�� �߻��� �� �ڵ������� ȣ��Ǿ� ����Ǵ� ������ ���ν���
(�������)
    CREATE OR REPLACE TRIGGER Ʈ���Ÿ�
        BEFORE|AFTER  INSERT|UPDATE|DELETE ON ���̺��
        [FOR EACH ROW]
        [WHEN ����]
    [DECLARE]
        ����,���,Ŀ�� ����
    BEGIN
        Ʈ���� ����(TRIGGER BODY) 
    END;
    . 'BEFORE|AFTER' : Ʈ������ ������ ����Ǵ� ����(�̺�Ʈ �߻��� ��������)
    . 'INSERT|UPDATE|DELETE' : Ʈ������ �߻� ����, ���ջ���� �� ����
    . 'FOR EACH ROW' : ����� Ʈ������ ��� ��� �����Ǹ� ������� Ʈ���� 
        --������� Ʈ���ŵ� ����
    .  'WHEN ����' : Ʈ���Ű� ����Ǹ鼭 ���Ѿ��� ����(���ǿ� �´� �����͸� Ʈ���� ����)

��뿹) ���� ���ǿ� �´� ������̺�(EMPT)�� HR������ ������̺�κ��� ������
        �����͸� ������ �����Ͻÿ�
        �÷�: �����ȣ(EID),�����(ENAME),�޿�(SAL),�μ��ڵ�(DEPTID),��������(COM_PCT)
        ����: �޿��� 6000������ ���
    CREATE TABLE EMPT(EID,ENAME,SAL,DEPTID,COM_PCT) AS  --EMPT����
        SELECT EMPLOYEE_ID, EMP_NAME,SALARY,DEPARTMENT_ID,COMMISSION_PCT
          FROM HR.employees
         WHERE SALARY <=6000;
         
--        SELECT * FROM EMPT;
        
Ʈ���� ��뿹) ���� �����͸� EMPT���̺� �����ϰ� ������ ���� ��
        '���ο� ��������� �߰� �Ǿ����ϴ�.'��� �޼����� ����ϴ� Ʈ���Ÿ� �ۼ��Ͻÿ�
        [�ڷ�]
        �����  �޿�   �μ��ڵ�    ���������ڵ�
----------------------------------------------------
        ȫ�浿  5500     80         0.25

    CREATE OR REPLACE TRIGGER TG_NEW_EMP_INSERT
        AFTER INSERT ON EMPT
    BEGIN
        DBMS_OUTPUT.PUT_LINE('���ο� ��������� �߰� �Ǿ����ϴ�.');
    END;
    
-- DEPT�� �ڷ����
    INSERT INTO EMPT 
    SELECT MAX(EID)+1,'ȫ�浿',5500,80,0.25 FROM EMPT;
    
    INSERT INTO EMPT 
    SELECT MAX(EID)+1,'������',5800,50,NULL FROM EMPT;
    
    
��뿹) ������̺��� 115, 126, 132�� ����� ���� ó���Ͻÿ�
        �����ϴ� ��������� ������̺�(EMPT)���� �����Ͻÿ�.
        �������� �����ϴ� ��������� ���������̺�(EM_RETIRE)�� �����Ͻÿ�
/
    CREATE OR REPLACE TRIGGER tg_remove_empt
        BEFORE DELETE ON EMPT
        FOR EACH ROW   -- ��������� �Ѳ����� ó���� ��
    DECLARE 
        V_EID EMPT.EID%TYPE;   -- ~�� ���� Ÿ��
        V_DID EMPT.DEPTID%TYPE;  
    BEGIN
        V_EID := (:OLD.EID);
        V_DID := (:OLD.DEPTID);
        
        INSERT INTO EM_RETIRE
           VALUES(V_EID,V_DID,SYSDATE);
    END;
/    
-- ������ �ڷ� ����
    DELETE    FROM EMPT
     WHERE EID IN(115, 126, 132)
/
    ���̺� ERD ���輱    
    ���� : �θ� ���̺��� �⺻Ű�� �ڽ��� �⺻Ű�� �ȴ�. �׷� �ڽ����̺��� PK�� FK�� �ȴ�.(�ĺ��� ����)
    ���� : �θ� ���̺��� �⺻Ű�� �ڽ� ���̺��� �Ϲ� �׸��� �ȴ�. �ڽ����̺��� �׳� FK
    
        
        
        


