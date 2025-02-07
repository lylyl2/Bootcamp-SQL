--숫자 함수

--ROUND - 반올림
SELECT ROUND(45.923, 2), ROUND(45.923, 0), ROUND(45.923, -1) FROM DUAL;

--TRUNC - 절삭
SELECT TRUNC(45.923, 2), TRUNC(45.923), TRUNC(45.923, -1) FROM DUAL; --매개값을 하나만 주면, 정수부분까지 절삭!

--ABS - 절대값, CEIL 올림, FLOOR 내림, MOD 나머지  //올림과 내림은 정수 기준! 소수첫째자리수와 관련X
SELECT ABS(-3), CEIL(3.14), FLOOR(3.14), MOD(5, 2) FROM DUAL;

--------------------------------------------------------------------------------
--날짜 함수
SELECT SYSDATE FROM DUAL; --SYSDATE에 소괄호 없음!
SELECT SYSTIMESTAMP FROM DUAL;  -- + 시분초 (+협정시간)

--날짜는 연산이 가능합니다.
SELECT SYSDATE + 1, SYSDATE - 1 FROM DUAL; -- 날짜(내일, 어제)
SELECT SYSDATE - HIRE_DATE FROM EMPLOYEES; -- 일수(날짜 - 날짜)
SELECT (SYSDATE - HIRE_DATE) / 7 FROM EMPLOYEES; --주

--날짜 반올림 ROUND, 절삭 TRUNC  //쓸 일은 없을 것!
SELECT SYSDATE, ROUND(SYSDATE), TRUNC(SYSDATE) FROM DUAL; --일 기준으로 반올림, 절삭  //항상 일자가 기준!
SELECT TRUNC(SYSDATE, 'YEAR') FROM DUAL; --년 기준으로 절삭
SELECT TRUNC(SYSDATE, 'MONTH') FROM DUAL; --월 기준으로 절삭