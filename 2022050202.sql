2022-0502-02) SEQUENCE
    - ���������� ����(�Ǵ� ����) �Ǵ� ���� ��ȯ�ϴ� ��ü
    - Ư�� ���̺� ���ӵ��� ����
    - �⺻Ű�� ������ Ư�� �׸��� ���� ��� �ַ� ���
    
    - 
(�������)
    CREATE SEQUENCE ��������
    [START WITH n] -- n���� ����  ,���۰� �����Ǿ����� �ʱⰪ�� �� (�ʱⰪ�� �����Ǹ� 1�� ����.)
    [INCREMENT BY n] -- ���� ���Ұ�(n)
    [MAXVALUE n|NOMAXVALUE] -- ������ ����, �⺻�� NOMAXVALUE�̸� 10^27
    [MINVALUE n|NOMINVALUE] -- �ּҰ� ����, �⺻�� NOMINVALUE�̸� ���� 1 ��
    [CYCLE|NOCYCLE] : -- ����/�ּ� ������ ������ �� �ٽ� �������� ����(�⺻�� CYCLE)
    [CACHE n|NOCACHE] : -- ������ �������� ĳ���޸𸮿� ������ ������ ����
                        -- �⺻�� CACHE 20 
    [ORDER | NOORDER] : --���ǵȴ�� ������ ���忩�� �⺻�� NOORDER  ,���
    
    
*������ ����� ���ѵǴ� ��
    . SELECT, UPDATE, DELETE ���� SUBQUERY
    . VIEW�� ��������ϴ� QUERY
    . DISTINCT�� ���� SELECT��
    . GROUP BY, ORDER BY���� ���� SELECT��
    . ���տ����ڿ� ���� SELECT��
    . SELECT���� WHERE ��
    
* �������� ���Ǵ� �ǻ��÷�
    ��������.CURRVAL : ��������ü�� ���簪
    ��������.NEXTVAL : ��������ü�� ������
*�������� �����ǰ� ù ��° �����ؾ��� ����� �ݵ�� NEXTVAL �� �Ǿ�� ��.

    -- SEQUENCE�� ������ �ʿ䰡 ������ DROP SEQUENCE ��������
��뿹)�з����̺� ����� �������� �����Ͻÿ�.
      ���۰��� 10�̰� 1�� �����ؾ���
    CREATE SEQUENCE SEQ_LPROD  -- ������
     START WITH 10;
    
    SELECT SEQ_LPROD.NEXTVAL FROM DUAL; -- 10���� ������. (�ǵ��ư� �� ����. �ذ��� : ���� �� ��ŸƮ)
    SELECT SEQ_LPROD.CURRVAL FROM DUAL;

    DROP SEQUENCE SEQ_LPROD  -- ����

��뿹) �����ڷḦ �з����̺� �����Ͻÿ�
    [�ڷ�]
    LPROD_ID       LPROD_GU       LRPOD_NM
    --------------------------------------
    ���������        P501          ��깰
    ���������        P502          ���깰
    ���������        P503          �ӻ깰
    
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P501','��깰');
    
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P502','���깰');
        
    INSERT INTO LPROD 
        VALUES(SEQ_LPROD.NEXTVAL, 'P503','�ӻ깰');
        
        
3. SYNONYM(���Ǿ�)
    - ����Ŭ���� ���Ǵ� ��ü�� �ο��� �� �ٸ� �̸�
    - �� ��ü���̳� ����ϱ� ����� ��ü���� ����ϱ� ���� ����ϱ� ����
      �̸����� ���

(�������)
    CREATE OR REPLACE SYNONYM ��Ī FOR ��ü��;
        .'��ü��'�� '��Ī'���� �� �ٸ� �̸� �ο�

��뿹) HR������ ������̺�� �μ����̺��� EMP, DEPT�� ��Ī(���Ǿ�)�� �ο��Ͻÿ�
    CREATE OR REPLACE SYNONYM EMP FOR HR.employees;
    CREATE OR REPLACE SYNONYM DEMP FOR HR.departments; 
    SELECT * FROM EMP;


 3. INDEX
 - ���̺� ����� �ڷḦ ȿ�������� �˻��ϱ� ���� ���
 - ����Ŭ������ ����ڷκ��� �˻������ �ԷµǸ� ��ü�� ������� �˻�(FULL SCAN)�� �� ��
   �Ǵ� �ε��� ��ĵ(INDEX SCAN)�� �� ���� ������
 - �ε����� �ʿ��� �÷�
   . ���� �˻��ϴ� �÷�
   . WHERE ������ '='�����ڷ� Ư�� �ڷḦ �˻��ϴ� ���
   . �⺻Ű --�ڵ����� INDEX��
   . SORT(ORDER BY)�� JOIN���꿡 ���� ���Ǵ� �÷�
 - �ε����� ����
   . Unique / Non-Unique
   . Single / Composite
   . Normal / Bitmap / Function-Based
   
 (�������)
 CREATE [UNIQUE|BITMAP] INDEX �ε�����
   ON ���̺�(�÷���[,�÷���,...] [ASC|DESC]);
  . 'ASC|DESC' : �������� �Ǵ� ������������ �ε��� ����, �⺻�� ASC
  
 ��뿹)
 CREATE INDEX IDX_MEM_NAME
  ON MEMBER(MEM_NAME);
  
 SELECT *FROM MEMBER
  WHERE MEM_NAME='����ȸ';
  
 DROP INDEX IDX_MEM_NAME;
 
 ��뿹)
 CREATE INDEX IDX_PROD
   ON PROD(SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9));-- 9���ں��� ������.
   
 SELECT * FROM PROD
  WHERE SUBSTR(PROD_ID,1,5)||SUBSTR(PROD_ID,9)='P202013'
  -- ������ P202000013 ������ 1~5, 9~������ �ڸ��� ����θ� �������� ����д�.
 ** �ε��� �籸��
  - �ε����� �ٸ� ���̺����̽��� �̵���Ű�� ���
  - ���������̺��� �̵��� ���
  - ���� ������ �ټ� �߻��� ����
  ALTER �ε����� REBUILD;

 
 
