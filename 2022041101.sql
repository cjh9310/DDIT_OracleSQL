2022-0411-01)
 ** ������ �ڷ��� ǥ������ : 1.0E103 ~ 9.999..99 E-125
                        -- 1.0*10^103           9*10^-125
 ** ���е� < �������� ���
    . ����� ���
    . ���е� : 0�̾ƴ� ��ȿ������ ����
    . ������ -(���̳ʽ�) ���е� : �Ҽ��� ���Ŀ� �����ؾ��� '0'�� ����
��뿹)  
    -----------------------------------------------
    �Է°�          ����             ���Ǵ� ��
    -----------------------------------------------
    0.2345         NUMBER(4,5)      ����
    1.2345         NUMBER(3,5)      ����
    0.0345         NUMBER(3,4)      0.0345
    0.0026789      NUMBER(3,5)      0.00238
    ----------------------------------------------
    
4. ��¥ Ÿ��
    - ��¥ �� �ð��� ���� �ڷ� ����(��,��,��,��,��,��)
    - ������ ������ ����� �� �� ����
    -DATE, TIMESTAMPŸ���� ������.
  (1) DATE Ÿ��
    . ǥ�� ��¥Ÿ��
    (�������)
    �÷��� DATE 
    
    (��� ��)
    CREATE TABLE TEMP05(
     CUL1 DATE,
     CUL2 DATE,
     CUL3 DATE);
    **SYSDATE �Լ� : �ý����� �����ϴ� ��¥�ڷ� ����
    INSERT INTO TEMP05 VALUES(SYSDATE, SYSDATE-30, TO_DATE('20190411')+365);
    SELECT * FROM TEMP05
    
    SELECT TO_CHAR(CUL1, 'YYYYMMDD HH24: MI :SS') AS �÷�1, 
           TO_CHAR(CUL2, 'YYYYMMDD HH24: MI :SS') AS �÷�2,
           TO_CHAR(CUL3, 'YYYYMMDD HH24: MI :SS') AS �÷�3
           FROM TEMP05;
           
    ** ��¥�ڷ� - ��¥�ڷ� => ����� �ϼ� ���
    SELECT MOD((TRUNC(SYSDATE) - TO_DATE('00010101')-1),7)
    -- TRUNC ��,��,�� �ڸ���.(�ݿø����� �ϼ��� +1�Ǵ� ���� �����ϱ� ����)
    -- ����� �ϼ� -1����� ���� ��¥ , 7�� ������?
    FROM DUAL; -- (DUAL)������ ���̺� 
    
    (2) TIMESTAMP Ÿ��
    . �ð��뿪(TIME ZONE ����)���� ����
    . ���� ������ �ð�����(1������� 1��)����
    (�������)
    �÷��� TIMESTAMP --�ð��뿪 ���� ����
    �÷��� TIMESTAMP WITH TIME ZONE -- �ð��뿪 ���� ����
    �÷��� TIMESTAMP WITH LOCAL TIME ZONE -- ���ü����� ��ġ�� �ð��뿪������ 
                                         -- TIMESTAMP�� ���� �ð��뿪 ���� ����
    (��뿹)
    CREATE TABLE TEMP06 (
        COL1 TIMESTAMP,
        COL2 TIMESTAMP WITH TIME ZONE, 
        COL3 TIMESTAMP WITH LOCAL TIME ZONE);
    
    INSERT INTO TEMP06 VALUES(SYSDATE, SYSDATE, SYSDATE);
    SELECT * FROM TEMP06;
    
5. �����ڷ� Ÿ��
    - BLOB, BFILE, RAW ���� ������
    
    (1)RAW -- ũ�Ⱑ �۾Ƽ� �� ������ ����.
        . ���� ���� �Ը��� �����ڷ� ����
        . �ε��� ó�� ���� -- ũ�Ⱑ �۾Ƽ�
        . �ڿ���Ŭ���� ������ �ؼ��̳� ��ȯ�� �������� ����-- ����Ǿ��� �ڷ� �״�� ����ڿ��� �����ش�.
        . �ִ� 2000BYTE���� ���� ����  
        . 16������ 2���� ���� ����
    (�������)
     �÷��� RAW(ũ��)
     
     (��뿹)
     CREATE TABLE TEMP07 (
        COL1 RAW(1000),
        COL2 RAW(1000));
        
    INSERT INTO TEMP07 
    VALUES (HEXTORAW('A5FC'), '1010010111111100'); --HEX=16����,  TORAW=RAWŸ������ �����ض�.
    SELECT * FROM TEMP07;
    
    (2) BFILE
        . �����ڷ� ����
        . ���������� �����ͺ��̽� �ۿ� �����ϰ� �����ͺ��̽����� ���(path)�� ����
        . ��� ��ü(DIRECTORY) �ʿ�
        . 4GB���� ���� ����
    (�������)
        �÷��� BFILE        - ���丮 ��ü�� ��Ī(Alias)�� 30BYTE, ���ϸ��� 256BYTE���� ����
     ** �׸����� �������
    0) ���̺� ����
    CREATE TABLE TEMP08 (
        COL1 BFILE);
    1) �׸����� ����
    2) ���丮��ü ����
    CREATE DIRECTORY ���丮��Ī AS '������';
    CREATE DIRECTORY TEST_DIR AS 'D:\work\oracle';
    3) ������ ����
    INSERT INTO TEMP08
    VALUES(BFILENAME('TEST_DIR', 'minion.jpg'));
    SELECT * FROM TEMP08;
    
    
    (3)BLOB
        . �����ڷ� ����
        . ���� �����ڷḦ ���������̺� �ȿ� ����
        . 4GB���� ���� ����
    (�������)
     �÷��� BLOB
  ** �׸����� �������
     0) ���̺� ����
     CREATE TABLE TEMP09(
     COL1 BLOB);
     
     1) �͸���(PL/SQL)�ۼ�
      DECLARE
      L_DIR VARCHAR2(20):='TEST_DIR';
      L_FILE VARCHAR2(30):='minion.jpg';
      L_BFILE BFILE; -- ������ ������Ÿ��
      L_BLOB BLOB;
      BEGIN
      INSERT INTO TEMP09(COL1) VALUES(EMPTY_BLOB())
        RETURN COL1 INTO L_BLOB;
        L_BFILE:=BFILENAME(L_DIR, L_FILE);
        DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
        DBMS_LOB.LOADFROMFILE(L_BLOB, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
        DBMS_LOB.FILECLOSE(L_BFILE);
        
        COMMIT;
      END;
    
DROP TABLE TEMP01;
DROP TABLE TEMP02;
DROP TABLE TEMP03;
DROP TABLE TEMP04;
DROP TABLE TEMP05;
DROP TABLE TEMP06;
DROP TABLE TEMP07;
DROP TABLE TEMP08;
DROP TABLE TEMP09;

DROP TABLE GOOD_ORDERS;
DROP TABLE ORDERS;
DROP TABLE GOODS;
DROP TABLE CUSTS;

COMMIT;

    
    
    