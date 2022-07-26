2022-0407-01) 
1. DML ���
 1). ���̺� �������(CREATE TABLE)
  - ����Ŭ���� ���� ���̺��� ����
  (�������)
  CREATE TABLE ���̺�� ( 
  �÷��� ������ Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��] [,]
                    : 
  �÷��� ������ Ÿ��[(ũ��)] [NOT NULL] [DEFAULT ��] [,]
  
  [CONSTRAINT �⺻Ű�ε����� PRIMARY KEY (�÷���[, �÷Ÿ�, .....]) [,]]
  [CONSTRAINT �ܷ�Ű�ε����� FOREIGN KEY (�÷���[, �÷Ÿ�, .....])
    REFERENCES ���̺�� (�÷���[, �÷Ÿ�, .....]) [,]]
  [CONSTRAINT �ܷ�Ű�ε����� FOREIGN KEY (�÷���[, �÷Ÿ�, .....])
    REFERENCES ���̺�� (�÷���[, �÷Ÿ�, .....])]);   // ������� �ϱ��ϱ�
    '���̺��', �÷���, �ε��� : ��������Ǵܾ ���  (����� �˾Ƽ� ����� ���)
    'NOT NULL'�� ����� �÷��� ������ ���Խ� ���� �Ұ���
    'DEFAULT ��' : ����ڰ� �����͸� �Է����� ���� ��� �ڵ����� ���ԵǴ� ��
   ��'�⺻Ű�ε�����', '�ܷ�Ű�ε�����', '���̺��'�� �ߺ��Ǿ�� �ȵȴ�.
    '���̺�� (�÷���[, �÷Ÿ�, .....])])' : �θ����̺�� �� �θ����̺��� ���� �÷���
    
    
    ��� ��) ���̺��1�� ���̺���� �����Ͻÿ�.
    
    CREATE TABLE GOODS (
    GOOD_ID CHAR(4) NOT NULL,  -- �⺻Ű   (�� ���� �Ƚᵵ �������.)
    GOOD_NAME VARCHAR2(50),    -- �ڹٴ� ; ����Ŭ�� , �� �Ѿ�� ��
    PRICE NUMBER(8),
    CONSTRAINT pk_goods PRIMARY KEY(GOOD_ID));
    
    CREATE TABLE CUSTS (
    CUST_ID CHAR(4),
    CUST_NAME VARCHAR2(50),
    ADDRESS VARCHAR2(100),
    CONSTRAINT pk_custs PRIMARY KEY(CUST_ID));
    
    CREATE TABLE ORDERS(
        ORDER_ID CHAR(11), -- �߰�
        ORDER_DATE DATE DEFAULT SYSDATE, -- �߰� , SYSDATE ���� ��¥�� ����.
        CUST_ID CHAR(4), -- ������
        ORDER_AMT NUMBER(10) DEFAULT 0, -- �߰�
        CONSTRAINT pk_order PRIMARY KEY(ORDER_ID), -- ����Ű
        CONSTRAINT fk_order_cust FOREIGN KEY(CUST_ID)   --�ܷ�Ű  , �޸� X
         REFERENCES CUSTS(CUST_ID)
);
    CREATE TABLE GOOD_ORDERS ( 
        ORDER_ID CHAR(11),  --  ������
        GOOD_ID CHAR(4),    --  ������
        ORDER_QTY NUMBER(3), -- �߰�
        CONSTRAINT pk_gord PRIMARY KEY(ORDER_ID,GOOD_ID),  -- ����Ű
        CONSTRAINT fk_gord_order FOREIGN KEY(ORDER_ID) -- �ܷ�Ű
        REFERENCES ORDERS(ORDER_ID),
        CONSTRAINT fk_gord_goods FOREIGN KEY(GOOD_ID) -- �ܷ�Ű
        REFERENCES GOODS(GOOD_ID));
    -- ���� �߰��ؼ� ����Ű�� ������ �� �ְ�, �����ͼ� �װ��� ����Ű�� ������ �� �ִ�.
    -- ������ ���� �θ� ������ ���̴�.
    
2. INSERT ��� -- ���� ���� INSERT INTO �� �� ����
              -- �ִ� ���� ������Ʈ ������ �� ���� �� �ִ�.
 - ������ ���̺� ���ο� �ڷḦ �Է�
  (�������)
  INSERT INTO ���̺��[(�÷���[,�÷���,...])]
    VALUES(��1[,��2,...]); --���� �÷����� ������ ���� ��1, ��2 �� ������� �ԷµǾ����
    
    '���̺��[(�÷���[,�÷���,...])]': '�÷���'�� �����ǰ� ���̺�� ����Ǹ� ���̺���
    ��� �÷��� �Էµ� �����͸� ������ ���߾� ����ؾ��� (���� �� ���� ��ġ)
    '(�÷���[,�÷���,...])' : �Է��� �����Ϳ� �ش��ϴ� �÷��� ���, �� , NOT NULL(NO) �÷��� 
    ���� �� �� ����. -- ���̺���� �����ǰ� �÷��� ��ϵ� ���
    -- NOT NULL�� ���� ������� �ʴ´��ε� �Է����� ������ NULL�� �ڵ����� ���Ƿ�
    -- NOT NULL�� �����....  (�³�?)
    
    
    EX) ���� �ڷḦ GOODS ���̺� �����Ͻÿ� --GOODS ���̺� NULLABLE �ϳ��� NO�� �Ǿ�����
    
        ��ǰ�ڵ�    ��ǰ��     ����
        --------------------------
        P101      ����        500
        P102      ���콺      15000
        P103      ����        300
        P104      ���찳      1000
        P201      A4����      7000
        

    INSERT INTO GOODS VALUES('P101','����',500);
    INSERT INTO GOODS(good_id, GOOD_NAME)
        VALUES('P102','���콺');  --15000�� �ȳ����� NULL�� ����
   INSERT INTO GOODS(good_id, GOOD_NAME, PRICE)
        VALUES ('P103','����',300);
        
    SELECT * FROM GOODS; 
    -- ���Ȯ�� CTRL +ENTER
    EX) �����̺�(CUSTS)�� �����ڷḦ �Է��Ͻÿ�
    
        ����ȣ    ����     �ּ�
        -------------------------------
        a001      ȫ�浿     ������ �߱� ��շ�846
        a002      ���μ�     ����� ���ϱ� ����1�� 66
        
        INSERT INTO CUSTS VALUES('a001','ȫ�浿','������ �߱� ��շ� 846');
        INSERT INTO CUSTS (CUST_ID, ADDRESS) VALUES('a002','����� ���ϱ� ����1�� 66');
        
        SELECT * FROM CUSTS;
    
    EX) ���� ȫ�浿 ���� �α��� ���� ��� �ֹ����̺� �ش� ������ �Է��Ͻÿ�.
        -- ���̺� ORDERS ���鼭 ������ �� 
        INSERT INTO ORDERS(ORDER_ID,CUST_ID)-- �� ������ Ȱ�� �α���, �ֹ� ���̺�
        -- �������� ����Ʈ ���̿��� ��������.
        
    VALUES('20220407001','a001');
    -- �� ���� �Է��ߴµ� 4���� �ԷµǾ���.
    -- ORDER_DATE�� ���� ��¥    ,ORDER_AMT��??
    SELECT * FROM ORDERS;
    
    
  --  SELECT CASE WHEN ORDER_ID IS NULL THEN
   --                         TO_CHAR(SYSDATE,'YYYYMMDD')||'001'
    --          ELSE
    --                        MAX(TO_NUMBER (ORDER_ID))+1 
   --          END
  --      FROM ORDERS
    
    EX) ���� ȫ�浿 ���� ������ ���� �������� �� ���Ż�ǰ���̺�(GOOD_ORDERS)
    �� �ڷḦ �����Ͻÿ�.
    
        ���Ź�ȣ      ��ǰ��ȣ     ����
    -----------------------------------
       20220407001   P101         5
       20220407001   P102         10
       20220407001   P103         2
    
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P101',5);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P102',10);
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P103',2);
    
    UPDATE GOODS   -- GOODS ���̺� ���콺�� NULL�� �Ǿ��ִ°� �����ؾ���.
        SET PRICE = 15000
        WHERE GOOD_ID = 'P102';
        -- ������.
        UPDATE ORDERS -- ���ݰ��(������Ʈ)
          set  ORDER_AMT =ORDER_AMT+(SELECT ORDER_QTY*PRICE -- ���� �ִ� �� + ���� * ���� ����500��¥�� 5��
                            FROM GOOD_ORDERS A, GOODS B
                            WHERE A.GOOD_ID=B.GOOD_ID --GOOD_ORDERS �ȿ� �� ���̵�
                            AND ORDER_ID = '20220407001'
                            AND A.GOOD_ID='P103')
        WHERE ORDER_ID='20220407001';
        SELECT * FROM ORDERS;
        SELECT * FROM GOOD_ORDERS; -- WHERE�� �����Ƿ� GOOD_ORDERS�� �ִ� ��� ���� ����϶�� ���̴�.
        UPDATE ORDERS
            SET ORDER_AMT =0;
        
3. UPDATE ���

    - �̹� ���̺� �����ϴ� �ڷḦ ������ �� ���ȴ�.
    (�������)
    UPDATE ���̺��
        SET �÷��� = ��[,]
                :
            �÷��� = ��
    [WHERE ����]; -- WHERE ���� ������ ��� ���� �� �����ϹǷ� �ʼ��� ����;� �Ѵ�.
    
    SELECT PROD_NAME AS ��ǰ��,
           PROD_COST AS ���Դܰ�
        FROM PROD;    --PROD�� ����ִ� �� �߿� ��ǰ��, ���Դܰ���� ǥ�õǾ� �ִ� ���� ��� ����Ͻÿ�.
        
        
--    UPDATE PROD 
--        SET PROD_COST = 500000;   
--        -- ���� �����ϱ�.  WHERE������ �߰� ���ϸ� ���� �� 50������ �ٲ�����.
--    UPDATE PROD 
--        SET PROD_COST = PROD_COST + ROUND(PROD_COST * 0.1); 
--        --������ 10�ۼ�Ʈ ������ �Ҽ����� �����ٷ��� ROUND�� �־����
--    ROLLBACK;   -- (UPDATE)��� ���.
��뿹��) ��ǰ���̺��� �з��ڵ尡 'P101'�� ���� ��ǰ�� ���԰����� 10% �λ��Ͻÿ�.
        UPDATE PROD 
            SET PROD_COST = PROD_COST + ROUND(PROD_COST * 0.1)
        WHERE PROD_LGU = 'P101';  -- ���� ����    LGU=�з��ڵ�.
        
    
     
        
        
        