2022-0421-01)
    SELECT LEVEL, -- �ǻ��÷�(Pseudo Column)
           DEPARTMENT_ID AS �μ��ڵ�,
           LPAD(' ',4*(LEVEL-1)) || DEPARTMENT_NAME AS �μ���,
           PARENT_ID AS �����μ��ڵ�,
           CONNECT_BY_ISLEAF
      FROM DEPTS
     START WITH PARENT_ID IS NULL
   CONNECT BY PRIOR DEPARTMENT_ID=PARENT_ID; --DEPARTMENT_ID �ڽ��ڸ��÷�  --PARENT_ID �θ��ڸ��÷�