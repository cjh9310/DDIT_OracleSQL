2022-0415-01) �����Լ�
    1. �������Լ�
     - ABS, SIGN, POWER, SQRT���� ������
     1) ABS(n), SIGN(n), SQRT(n), POWER(e,n)
        ABS(n) : �־��� �� n�� ���밪
        SIGN(n) : �־��� �� n�� ����̸� 1, �����̸� -1, 0�Ƹ� 0�� ��ȯ
        SQRT(n) : �־��� �� n�� ���� ��ȯ
        POWER(e,n) : e�� n�� (e�� n�� �ŵ� ���� ��)
        
(��뿹)
    SELECT ABS(-2000), ABS(0.0009),ABS(0),
            SIGN(-2000), SIGN(0.0001), SIGN(0),
            SQRT(16), SQRT(87.99),
            POWER(2,10)
      FROM DUAL;
     2) GREATEST(n1,...nn), LEAST(((n1,...nn)
        .GREATEST(n1,...nn) : �־��� �� n1 ~ nn �� ���� ū �� ��ȯ
        . LEAST(n1,...nn) :  �־��� �� n1 ~ nn �� ���� ���� �� ��ȯ
(��뿹)
        SELECT GREATEST('ȫ�浿','�̼���','ȫ���'),  -- �̸��� �ڷ� ������ ū ��
               GREATEST('APPLE','AMOLD',100),      -- �ƽ�Ű�ڵ�� ��ȯ�� 
               LEAST('APPLE','AMOLD',100)
          FROM DUAL;
(��뿹) ȸ�����̺��� ���ϸ����� ��ȸ�Ͽ� 1000���� ���� ���̸� 1000�� �ο��ϰ�
        1000���� ũ�� ������ ���� ����Ͻÿ�.
        Alias�� ȸ����ȣ,ȸ����,�������ϸ���,���渶�ϸ���
        SELECT MEM_ID AS ȸ����ȣ,
               MEM_NAME AS ȸ����,
               MEM_MILEAGE AS �������ϸ���,
               GREATEST(MEM_MILEAGE,1000) AS ���渶�ϸ��� 
               --1000������ ���ϸ����� 1000���� ��µȴ�.
          FROM MEMBER;
         
     3)ROUND(n, 1), TRUNC(n, 1)
        . ROUND�� �ݿø�, TRUNC�� �ڸ������� ����
        . 1�� ����̸�
        - ROUND(n, 1) : �־��� �� n���� �Ҽ��� ���� 1+1�ڸ����� �ݿø��Ͽ� 1�ڸ����� ��ȯ
                        1�� �����ǰų� 0�̸� �Ҽ� ù��° �ڸ����� �ݿø��Ͽ� ���� ��ȯ
        - TRUNC(n, 1) : �־��� �� n���� �Ҽ��� ���� 1+1�ڸ����� �ڸ�����
        . 1�� �����̸�
        - ROUND(n, 1) : �־��� �� n���� �����ι� 1�ڸ����� �ݿø��Ͽ� ��� ��ȯ
        - TRUNC(n, 1) : �־��� �� n���� �����ι� 1�ڸ����� �ڸ�����
       SELECT ROUND(321.153,1),
              ROUND(321.153,-3),  -- ������ �����ڸ����� �ݿø��� �߻��ȴ�
              ROUND(326.553,-1)
         FROM DUAL;
        
(��뿹) ȸ�����̺��� ���ɴ뺰 ���ϸ����հ�� ȸ������ ���Ͻÿ�
        Alias�� ���ɴ�,ȸ����,���ϸ����հ�
      /*  SELECT SUBSTR(MEM_REGNO1,1,2) AS ���ɴ�,
               COUNT(*) AS ȸ����,
               SUM(MEM_MILEAGE) AS ���ϸ��� �հ�
          FROM MEMBER
         GROUP BY SUBSTR(MEM_REGNO1,1,2); */
        (1) ���̰��
        SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('1','2') THEN 
        -- �ֹι�ȣ 2��° ù ��°���� �ѱ���  1�� 2��� => 1900��� ���
                            EXTRACT(YEAR FROM SYSDATE) - 
                            -- ���ó�¥���� �⵵�� ����(���ڷ� ��޵Ǿ�����)  ���� ����
                            (1900 + TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))
                            -- 
                      ELSE  EXTRACT(YEAR FROM SYSDATE) -
                            
                            (2000 + TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)))  
                            
                    END AS ����
          FROM MEMBER;
        
        SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR)
        --EXTRACT(YEAR FROM SYSDATE) ��¥Ÿ�Կ��� �⵵ �̴´�.    ������ϵ� ����.
            FROM MEMBER;
        (2) ���ɴ�� ��ȯ
         SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR) AS ����,
                TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�
                -- ���̿��� 1�� �ڸ��� ����.
         FROM MEMBER;
         SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)  ||'��' AS ���ɴ�,
                COUNT(*) AS ȸ����,
                SUM(MEM_MILEAGE) AS ���ϸ����հ�
           FROM MEMBER
          GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
          ORDER BY 1;
         
     4) FLOOR(n), CEIL(n) --
      - FLOOR(n) : n�� ���ų�(n�� ������ ���) ���� �� �� ���� ū ����
      - CEIL(n) : n�� ���ų�(n�� ������ ���) ū �� �� ���� ���� ����
 (��뿹)        
        SELECT FLOOR(102.6777),FLOOR(102), FLOOR(-102.6777), -- -�϶� -102.1 �̶� -103���� ǥ��..
               CEIL(102.6777), CEIL(102), CEIL(-102.6777)
          FROM DUAL;
          
     5) REMAINDER(n, m), MOD(n, m)  -- �ַ� �������� ���� �� MOD�� ���
        - �־��� �� n�� m���� ���� �������� ��ȯ
        - ���������� ���� ����� �ٸ�
        - MOD(n, m) : �Ϲ����� �������� ��ȯ
        - REMAINDER(n, m) : �������� m�� ���ݰ�(0.5)�� �ʰ��ϸ� ��ȯ ���� ���� ���̵Ǳ� 
            ���� �ʿ��� ���� �����̸�, �׿ܴ� MOD�� ����
        - �������
            MOD       = n - m* FLOOR(n/m)
            REMAINDER = n - m* ROUND(n/m)
         ex) MOD(14, 5), REMAINDER(14,5)   
             MOD(14, 5)            = 14 - 5 * FLOOR(14/5)
                                   = 14 - 5 * FLOOR(2.8)
                                   = 14 - 5 * 2
                                   = 2
                                   
             REMAINDER(14,5)       = 14 - 5 * ROUND(14/5)
                                   = 14 - 5 * ROUND(2.8)
                                   = 14 - 5 * 3
                                   = -1
             MOD(14, 5), REMAINDER(14,5) 
            