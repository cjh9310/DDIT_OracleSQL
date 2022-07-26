2022-0418-02) 형 변환 함수
 - 함수가 사용된 위치에서 일시적으로 데이터타입의 형을 변환 시킴
 - T0_CHAR(문자열자료로 바꿔줌), 
 - TO_DATE(날짜열자료로 바꿔줌), 
 - TO_NUMBER(숫자열자료로 바꿔줌), 
 - CAST(사용자가 형을 지정해서 바꿔줌)가 제공 (많이 쓰는 순서)
 
    1) CAST(expr AS type명)    
        - 'expr'에 저장된 값의 데이터타입을 'type'으로 변환
        
사용예) SELECT '홍길동',
              CAST('홍길동' AS CHAR(20)),  -- 여백
              CAST('20200418' AS DATE) -- 숫자열은 날짜형식으로 바꿔줌.
         FROM DUAL;
     SELECT MAX(CAST(CART_NO AS NUMBER)) +1  --숫자열로 바꾸고 가장 큰 값을 구한 후 +1
       FROM CART
      WHERE CART_NO LIKE '20200507%' --결과가 오른쪽 정렬로 되어 있으므로 숫자열로 표시되어 있는 것.6

    (2) TO_CHAR(c), TO_CHAR(d | n [,fmt])
        - 주어진 문자열을 문자열로 변환(단, c타입이 CHAR or CLOB인경우 
         VARCHAR2로 변환하는 경우만 허용
        - 주어진 날짜(d) 또는 숫자 (n)을 정의된 형식(fmt)으로 변환
        -- 오라클에서 CHAR을 제외한 모든 문자열은 가변길이이다.
        -- 가변길이 : 사용자가 정의한 데이터만큼만 쓰고 나머지는 반납.
        - 날짜관련 형식문자
------------------------------------------------------------------------
    FORMAT문자       의미             사용예
------------------------------------------------------------------------    
    AD, BC           서기             SELECT TO_CHAR(SYSDATE, 'AD') FROM DUAL;
    CC, YEAR         세기,년도         SELECT TO_CHAR(SYSDATE, 'CC  YEAR') FROM DUAL; --CC 21세기.
    YYYY, YYY,YY,Y   년도             SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL; -- 앞에서부터 짤린다.
    Q                분기             SELECT TO_CHAR(SYSDATE, 'Q ') FROM DUAL; 
    MM,RM            월               SELECT TO_CHAR(SYSDATE, 'YY : MM : RM') FROM DUAL; --RM 로마식 표현 월
    MONTH, MON       월               SELECT TO_CHAR(SYSDATE, 'YY : MONTH MON') FROM DUAL; 
    W, WW, IW        주차             SELECT TO_CHAR(SYSDATE, 'W WW IW') FROM DUAL; -- WW IW 이번년도 주차
    DD, DDD, J       일차             SELECT TO_CHAR(SYSDATE, 'DD DDD  J') FROM DUAL;-- DDD는 365일 경과된 일 수?
    DAY, DY, D       요일             SELECT TO_CHAR(SYSDATE, 'DAY DY D') FROM DUAL; -- D 요일의 인덱스값.(시작일 일요일)
    AM,PM,           오전/오후        SELECT TO_CHAR(SYSDATE, 'AM A.M.') FROM DUAL;
    A.M., P.M.
    HH,HH12,HH24     시간            SELECT TO_CHAR(SYSDATE, 'HH HH12 HH24') FROM DUAL;
    MI               분              SELECT TO_CHAR(SYSDATE, 'HH24:MI') FROM DUAL;
    SS, SSSSS        초              SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS SSSSS') FROM DUAL;
     "문자열"          사용자정의      SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL;
                      형식문자열
    
        - 숫자관련 형식문자    
-----------------------------------------------------------------------------
    FORMAT문자       의미          
-----------------------------------------------------------------------------      
       9            출력형식의 자리, 유효숫자인 경우 숫자를 출력하고 무효의 0인 경우
                    공백처리
       0            출력형식의 자리, 유효숫자인 경우 숫자를 출력하고 무효의 0인 경우
                    0을 출력
       $, L         화폐기호 출력
       PR           원본자료가 음수인 경우 "-"부호 대신 "<>"안에 숫자 출력
       ,(Comma)     3자리마다의 자리점 표시 출력
       .(Dot)       소숫점 출력
-----------------------------------------------------------------------------
사용예)
    SELECT TO_CHAR(12345, '999999'),    -- 9의 의미는 원본데이터에서 위치값
           TO_CHAR(12345, '999,999.99'),
           TO_CHAR(12345.786, '000,000.0'),
           TO_CHAR(12345, '000,000'),
           TO_CHAR(-12345, '99,999PR'),
           TO_CHAR(12345, 'L99,999'),     -- L 자국의 화폐기호( 달라를 제외한)가 자동으로 설정됨.
           TO_CHAR(12345, '$99999')
      FROM DUAL;
    
    (3) TO_NUMBER(c [,fmt])
        - 주어진 문자열 자료 c를 fmt 형식의 숫자로 변환
        
사용예)
    SELECT TO_NUMBER('12345'),  --'12,345'는 혼자 쓸 수 없음
           TO_NUMBER('12,345','99,999'),
           TO_NUMBER('<1234>','9999PR'),
           TO_NUMBER('$12,234.00','$99,999.99')*1100
      FROM DUAL;
    
    (4)TO_DATE(c [,fmt])
        - 주어진 문자열 자료 c를 fmt 형식의 날짜자료로 변환

사용예)
    SELECT TO_DATE('20200405'),
           TO_DATE('220405','YYMMDD')
      FROM DUAL;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    