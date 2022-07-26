2022-0418-02) �� ��ȯ �Լ�
 - �Լ��� ���� ��ġ���� �Ͻ������� ������Ÿ���� ���� ��ȯ ��Ŵ
 - T0_CHAR(���ڿ��ڷ�� �ٲ���), 
 - TO_DATE(��¥���ڷ�� �ٲ���), 
 - TO_NUMBER(���ڿ��ڷ�� �ٲ���), 
 - CAST(����ڰ� ���� �����ؼ� �ٲ���)�� ���� (���� ���� ����)
 
    1) CAST(expr AS type��)    
        - 'expr'�� ����� ���� ������Ÿ���� 'type'���� ��ȯ
        
��뿹) SELECT 'ȫ�浿',
              CAST('ȫ�浿' AS CHAR(20)),  -- ����
              CAST('20200418' AS DATE) -- ���ڿ��� ��¥�������� �ٲ���.
         FROM DUAL;
     SELECT MAX(CAST(CART_NO AS NUMBER)) +1  --���ڿ��� �ٲٰ� ���� ū ���� ���� �� +1
       FROM CART
      WHERE CART_NO LIKE '20200507%' --����� ������ ���ķ� �Ǿ� �����Ƿ� ���ڿ��� ǥ�õǾ� �ִ� ��.6

    (2) TO_CHAR(c), TO_CHAR(d | n [,fmt])
        - �־��� ���ڿ��� ���ڿ��� ��ȯ(��, cŸ���� CHAR or CLOB�ΰ�� 
         VARCHAR2�� ��ȯ�ϴ� ��츸 ���
        - �־��� ��¥(d) �Ǵ� ���� (n)�� ���ǵ� ����(fmt)���� ��ȯ
        -- ����Ŭ���� CHAR�� ������ ��� ���ڿ��� ���������̴�.
        -- �������� : ����ڰ� ������ �����͸�ŭ�� ���� �������� �ݳ�.
        - ��¥���� ���Ĺ���
------------------------------------------------------------------------
    FORMAT����       �ǹ�             ��뿹
------------------------------------------------------------------------    
    AD, BC           ����             SELECT TO_CHAR(SYSDATE, 'AD') FROM DUAL;
    CC, YEAR         ����,�⵵         SELECT TO_CHAR(SYSDATE, 'CC  YEAR') FROM DUAL; --CC 21����.
    YYYY, YYY,YY,Y   �⵵             SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL; -- �տ������� ©����.
    Q                �б�             SELECT TO_CHAR(SYSDATE, 'Q ') FROM DUAL; 
    MM,RM            ��               SELECT TO_CHAR(SYSDATE, 'YY : MM : RM') FROM DUAL; --RM �θ��� ǥ�� ��
    MONTH, MON       ��               SELECT TO_CHAR(SYSDATE, 'YY : MONTH MON') FROM DUAL; 
    W, WW, IW        ����             SELECT TO_CHAR(SYSDATE, 'W WW IW') FROM DUAL; -- WW IW �̹��⵵ ����
    DD, DDD, J       ����             SELECT TO_CHAR(SYSDATE, 'DD DDD  J') FROM DUAL;-- DDD�� 365�� ����� �� ��?
    DAY, DY, D       ����             SELECT TO_CHAR(SYSDATE, 'DAY DY D') FROM DUAL; -- D ������ �ε�����.(������ �Ͽ���)
    AM,PM,           ����/����        SELECT TO_CHAR(SYSDATE, 'AM A.M.') FROM DUAL;
    A.M., P.M.
    HH,HH12,HH24     �ð�            SELECT TO_CHAR(SYSDATE, 'HH HH12 HH24') FROM DUAL;
    MI               ��              SELECT TO_CHAR(SYSDATE, 'HH24:MI') FROM DUAL;
    SS, SSSSS        ��              SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS SSSSS') FROM DUAL;
     "���ڿ�"          ���������      SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��"') FROM DUAL;
                      ���Ĺ��ڿ�
    
        - ���ڰ��� ���Ĺ���    
-----------------------------------------------------------------------------
    FORMAT����       �ǹ�          
-----------------------------------------------------------------------------      
       9            ��������� �ڸ�, ��ȿ������ ��� ���ڸ� ����ϰ� ��ȿ�� 0�� ���
                    ����ó��
       0            ��������� �ڸ�, ��ȿ������ ��� ���ڸ� ����ϰ� ��ȿ�� 0�� ���
                    0�� ���
       $, L         ȭ���ȣ ���
       PR           �����ڷᰡ ������ ��� "-"��ȣ ��� "<>"�ȿ� ���� ���
       ,(Comma)     3�ڸ������� �ڸ��� ǥ�� ���
       .(Dot)       �Ҽ��� ���
-----------------------------------------------------------------------------
��뿹)
    SELECT TO_CHAR(12345, '999999'),    -- 9�� �ǹ̴� ���������Ϳ��� ��ġ��
           TO_CHAR(12345, '999,999.99'),
           TO_CHAR(12345.786, '000,000.0'),
           TO_CHAR(12345, '000,000'),
           TO_CHAR(-12345, '99,999PR'),
           TO_CHAR(12345, 'L99,999'),     -- L �ڱ��� ȭ���ȣ( �޶� ������)�� �ڵ����� ������.
           TO_CHAR(12345, '$99999')
      FROM DUAL;
    
    (3) TO_NUMBER(c [,fmt])
        - �־��� ���ڿ� �ڷ� c�� fmt ������ ���ڷ� ��ȯ
        
��뿹)
    SELECT TO_NUMBER('12345'),  --'12,345'�� ȥ�� �� �� ����
           TO_NUMBER('12,345','99,999'),
           TO_NUMBER('<1234>','9999PR'),
           TO_NUMBER('$12,234.00','$99,999.99')*1100
      FROM DUAL;
    
    (4)TO_DATE(c [,fmt])
        - �־��� ���ڿ� �ڷ� c�� fmt ������ ��¥�ڷ�� ��ȯ

��뿹)
    SELECT TO_DATE('20200405'),
           TO_DATE('220405','YYMMDD')
      FROM DUAL;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    