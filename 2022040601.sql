2022-0406-01) ����� ����
-����Ŭ ����� ����
(�������)
CREATE USER ������ IDENTIFIED BY ��ȣ;
CREATE USER CJH99 IDENTIFIED BY java;

- ���� ����
    (�������)
GRANT ���Ѹ� [,���Ѹ�,...] TO ������;
GRANT CONNECT, RESOURCE, DBA TO CJH99;

- HR ���� Ȱ��ȭ
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY java;

