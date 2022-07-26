2022-0502-01) VIEW -- 
    - ���̺�� ������ ��ü
    - ������ ���̺��̳� �信 ���� SELECT���� ��� ������ �̸��� �ο��� ��ü
    - �ʿ��� ������ ���� ���̺� �л�
    - ���̺��� ��� �ڷḦ �������� �ʰ� Ư�� ����� �����ϴ� ���(����)
    
(�������)
    CREATE [OR REPLACE] VIEW ���̸�[(�÷�list)] 
    AS
        SELECT �� --SELECT���ּ� ���� �÷��� ��Ī�� ���̸��� �ȴ�.
        [WITH READ ONLY]
        [WITH CHECK OPTION]
        
    . 'REPLACE' : �̹� �����ϴ� ���� ��� ��ü
    . 'WITH READ ONLY' : �б����� �� ���� 
    -- 1.�����ϸ� �並 ����� �� ����.  2.�������̺���� ���X   3.�������̺��� �����ϸ� �䵵 ���� �����̵ȴ�.
    -- �䰡 �ٲ� �������̺��� �ٲ��.(�װ��� �����ϱ� ���� WITH READ ONLY�� ���)
    . 'WITH CHECK OPTION' : �並 �����ϴ� SELECT���� ������ �����ϴ� DML�����
        �信�� �����Ҷ� ���� �߻�
        
    . '�÷�list' : �信�� ����� �÷�
    -- �信�� �÷����� �����ϸ� 
    -- 1. ���� SELECT�� ���� ��Ī�� ���� �÷����� �ȴ�.
    -- 2. VIEW���� �÷����� ����Ǿ����� ���̸�
    
��뿹) ȸ�����̺��� ���ϸ����� 3000 �̻��� ȸ���� 
        ȸ����ȣ,ȸ����,����,���ϸ����� ������ �並 �����Ͻÿ�.
1. �÷��� ��Ī�� ���� ��
    CREATE OR REPLACE VIEW V_MEM01 -- V_MEM01 ���̸�  , �÷��� �����ϴ� ����SELECT�� ��Ī�� �����.
    AS
        SELECT MEM_ID,     --��Ī
               MEM_NAME,     --��Ī
               MEM_JOB,        --��Ī
               MEM_MILEAGE --��Ī 
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000
    
2. �÷��� ��Ī�� ���� ��   
    CREATE OR REPLACE VIEW V_MEM01 (MID,MNAME,MJOB,MILE)
    AS
        SELECT MEM_ID, 
               MEM_NAME,   
               MEM_JOB,       
               MEM_MILEAGE 
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000    
    
��뿹) ������ ��(V_MEM01)���� 'C001'ȸ���� ���ϸ����� 2500���� ����
    UPDATE V_MEM01
       SET MILE=2500
     WHERE MID = 'c001';
    -- �並 �����ϴ� ���������͵� ����
    SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
      FROM MEMBER
     WHERE MEM_ID = 'g001';
    
    UPDATE MEMBER
       SET MEM_MILEAGE = 3800
     WHERE MEM_ID = 'g001';
    -- ������ �����ϴ� �䵵 ����
    
    SELECT * FROM V_MEM01;
    
    
��뿹) ȸ�����̺��� ���ϸ����� 3000 �̻��� ȸ���� 
        ȸ����ȣ,ȸ����,����,���ϸ����� ������ �並 �б��������� �����Ͻÿ�.
    CREATE OR REPLACE VIEW V_MEM01
    AS
        SELECT MEM_ID,MEM_NAME,MEM_JOB,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000  
          WITH READ ONLY
    SELECT * FROM V_MEM01;
    
��뿹) ������ ��(V_MEM01)���� 'g001'ȸ��(�۰���)�� ���ϸ����� 800���� ����
    (�信�� ����.) -- �信�� ������ �ȵȴ�.
    UPDATE V_MEM01
       SET MEM_MILEAGE =800
     WHERE MEM_ID = 'g001';
     -- �������̺����� �󸶵��� ���� ����
     (�������̺��� ����)
     UPDATE MEMBER --�������̺��� ������ �ȴ�.
       SET MEM_MILEAGE =800
     WHERE MEM_ID = 'g001';
    
     SELECT * FROM V_MEM01; -- �۰��� 800���� �ٲ� ���ܵ�.
     
     
��뿹) ȸ�����̺��� ���ϸ����� 3000 �̻��� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� 
        ������ �並 WITH CHECK OPTION�� ����Ͽ� �����Ͻÿ�.
    CREATE OR REPLACE VIEW V_MEM01
    AS
        SELECT MEM_ID,MEM_NAME,MEM_JOB,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_MILEAGE>=3000  
          WITH CHECK OPTION;
          
    SELECT * FROM V_MEM01;     

��뿹) ������ �信�� ������ȸ��(e001)�� ���ϸ����� 2500���� �����Ͻÿ�.
    UPDATE V_MEM01
       SET MEM_MILEAGE = 2500
     WHERE MEM_ID = 'e001';
     -- WITH CHECK OPTION�� ����ؼ� �߱� ������  
     -- ������ �����ϸ�(3000���� ���Ƽ� �信�� ���Ű� �� ���)������ �� ����...
     
��뿹) �ſ�ȯ ȸ��('c001')���ϸ����� MEMBER���̺��� 3500���� ����
    UPDATE MEMBER
       SET MEM_MILEAGE = 3500
     WHERE MEM_ID ='c001';

��뿹) ��ö�� ȸ��('k001')���ϸ����� �信�� 4700���� ����
    UPDATE V_MEM01
       SET MEM_MILEAGE = 4700
     WHERE MEM_ID ='k001';     
     -- ������ �������� �ʾƼ� ����ȴ�.

    UPDATE MEMBER
       SET MEM_MILEAGE = 2500
     WHERE MEM_ID ='k001';
     
    SELECT * FROM V_MEM01;        
     