2022-0408-01)
��뿹) ������̺�(HR���� EMPLOYEES���̺�)���� ��� ����� �޿���
    15% �λ��Ͽ� �����Ͻÿ�.
COMMIT;  -- ����.

    SELECT FIRST_NAME, SALARY
        FROM HR.employees;
        
    UPDATE HR.employees
        SET SALARY = SALARY + ROUND(SALARY*0.15)
        -- ��� ����̶� WHERE�� �ʿ����..
    ROLLBACK;

4. DELETE ��� -- �θ��ڽ� ���谡 �ִ� ���̺��� ���� ��� �θ�� ���� �� ����...
 - ���ʿ��� �ڷḦ ���̺��� ����
    (�������)
    DELETE FROM ���̺��
    [WHERE ����]
    
��뿹) 
    DELETE FROM CART;

    ROLLBACK;
    
    
5. ����Ŭ ������Ÿ��
    - ����Ŭ�� ���� ������ Ÿ���� �������� ����.
    - ���ڿ�, ����, ��¥, 2�� ������Ÿ�� ����
   1) ���ڿ� �ڷ���
    - ����Ŭ�� ���ڿ� �ڷ�� ' '�� ���
    - ���ڿ� �ڷ����� CHAR, VARCHAR, VARCHAR2, NVARCHAR, NVARCHAR2, LONG
      , CLOB, NCLOB���� ���� -- �տ� N�� ������ ����ǥ�� �������� �ϰڴ�....��� ��
    (1) CHAR 
        . �������� ���ڿ� �ڷ� ����
        . �ִ� 200byte ���� ���尡��
        . �������� ������ ������ ������ ������ pedding, �������� ������ error
        . �⺻Ű�� �������ڷ�(�ֹι�ȣ ��) ���忡 �ַ� ���
        (��뿹)
        �÷��� CHAR(ũ��[byte|char])  -- byte or char 
         . 'ũ��[byte|char]' : 'ũ��'�� ������ ���� byte���� char(���ڼ�)
         ������ ����. �����ϸ� byte�� �����Ѵ�.  --default 
         . �ѱ� �ѱ��ڴ� 3byte�� ����Ǹ� CHAR(2000CHAR)�� ����Ǿ��� ������
          ��ü ������ 2000BYTE�� �ʰ��� �� ����  -- ����ȵ�
 
 ��뿹) 
    CREATE TABLE TEMP01(
        COL1 CHAR(20),
        COL2 CHAR(20 BYTE),
        COL3 CHAR(20 CHAR));
    
    INSERT INTO TEMP01 VALUES('������ �߱�', '������ �߱�', '������ �߱�');
    INSERT INTO TEMP01 VALUES('������ �߱� ���� 846', '������ �߱�', '������ �߱�');
    -- ������ �߱� ���� 846 -> ���� 24byte + ��ĭand���� 6byte = 30byte  ���̺� ���� �� 20����Ʈ�� �����صּ� ������ �ȵȴ�.
    SELECT * FROM TEMP01;
    
    SELECT LENGTHB (COL1),   -- �÷� COL1�� ���̸� ����Ʈ�� ��Ÿ������.
           LENGTHB (COL2),   -- �÷� COL2�� ���̸� ����Ʈ�� ��Ÿ������.
           LENGTHB (COL3)    -- �÷� COL3�� ���̸� ����Ʈ�� ��Ÿ������.
        FROM TEMP01;
 
    (2) VARCHAR2
     . �������� ���ڿ� �ڷḦ ����
     . �ִ� 4000byte���� ���� ����
     . VARCHAR�� ���� ���
     . NVARCHAR �� NVARCHAR2�� ���� ǥ���ڵ��� UTF-8, UTF-16������� �����͸�
        ���ڵ��Ͽ� ����
    (�������)
        �÷��� VARCHAR2 (ũ��[BYTE|CHAR}) -- �����ϸ� byte�� ����
        
    (��뿹)
        CREATE TABLE TEMP02 (
            COL1 VARCHAR2(100),
            COL2 VARCHAR2(100 BYTE),
            COL3 VARCHAR2(100 CHAR),
            COL4 CHAR(100));
 
        INSERT INTO TEMP02
            VALUES('IL POSTINO', 'IL POSTINO', 'IL POSTINO', 'IL POSTINO');
        
        SELECT * FROM TEMP02;
        
    (3) LONG
        . �������� ������ ���� -- �뷮�� �� ������ ��ȯ����.
        . 2GB ���� ���� ���� -- 2e31 byte
        . �� ���̺� �ϳ��� LONGŸ�� �÷��� ���
        . CLOB(Character Large OBjects)�� ��� ���׷��̵� ��
        . select ���� select��, update���� set��, insert���� vales������ ��� ����
        . �Ϻ� �Լ������� ���� �� ����
    (�������)
    �÷��� long
    
    (��뿹)
    CREATE TABLE TEMP03 (
        COL1 LONG,
        COL2 VARCHAR2(4000));
    
    INSERT INTO TEMP03 
        VALUES ('BANNA APPLE PERSIMMIN','BANNA APPLE PERSIMMIN');
    
    SELECT * FROM TEMP03;
    
    SELECT SUBSTR (COL1,7,5)-- COL1 ����            -- APPLE �б�(�÷���,���°����, ���ڸ�����)
        FROM TEMP03;
 
    (4) CLOB
        . �������� ������ ����
        . �ִ� 4GB���� ó�� ����
        . �� ���̺� ���� ���� CLOB�ڷ�Ÿ���� �÷� ��� ����
        . �Ϻ� ����� DBMS_LOB API�� ������ �޾ƾ� ��� ����
    (�������)
     �÷��� CLOB;
     
    (��뿹)
     CREATE TABLE TEMP04(
        COL1 LONG,
        COL2 CLOB,
        COL3 CLOB,
        COL4 VARCHAR2(4000));
        
    INSERT INTO TEMP04
     VALUES('','������ �߱� ���� 486','������ �߱� ���� 486','������ �߱� ���� 486');
     
     SELECT * FROM TEMP04;
 
    SELECT DBMS_LOB.GETLENGTH(COL2),  -- LENGTHB X / DBMS_LOB.GETLENGTHB O
           DBMS_LOB.GETLENGTH(COL3),
           LENGTHB(COL4)
        FROM TEMP04;
 
    SELECT  SUBSTR(COL2,5,2),           -- ���� Ȱ��� 
            DBMS_LOB.SUBSTR(COL2,5,2),  -- ���� Ȱ���
            SUBSTR(COL4,5,2)
    FROM TEMP04;

 
 
 