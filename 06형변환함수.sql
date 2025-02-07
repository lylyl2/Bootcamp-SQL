--형변환 함수  //중요! //쓸 일이 많고 중요하니 다 기억하세요!

--자동형변환을 제공합니다. NUMBER <-> 문자, DATE <-> 문자
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; --문자를 넣어도 자동으로 숫자로 형변환을 해줘서 찾아진다!
SELECT HIRE_DATE FROM EMPLOYEES WHERE HIRE_DATE = '05/09/30'; --이것도 문자를 날짜로 자동형변환 해줌!

--강제형변환
--TO_CHAR - 1)날짜 -> 문자로 강제 형변환 (날짜 포멧형식이 쓰입니다)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --SYSDATE는 날짜까지만 보여주는데 사실은 시분초까지 있다는거! 사람이 볼 수 있는 문자로 바꿔줌
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY년 MM월 DD일') FROM DUAL; --X 한글은 포멧문자가 아니라서 실행X
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL; --날짜의 포멧형식이 아닌 값은 " "으로 묶어준다
SELECT FIRST_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD AM') FROM EMPLOYEES;
--TO_CHAR - 2)숫자 -> 문자로 강제 형변환 (숫자 포멧형식 쓰입니다)
SELECT TO_CHAR(20000, '999999999') FROM DUAL; --자리수 넓찍하게 준거!
SELECT TO_CHAR(20000, '099999999') FROM DUAL; --남는 자리는 0으로 채움
SELECT TO_CHAR(20000, '9999') FROM DUAL; --자리가 부족하면 #으로 처리됨
SELECT TO_CHAR(20000.123, '9999.999') FROM DUAL; --소수점 3자리까지 표현한다.
SELECT TO_CHAR(20000, '$999,999.99') FROM DUAL; --$는 그냥 쓰면 됩니다. L을 붙이면 지역화페기호!
SELECT TO_CHAR(20000, 'L999,999.99') FROM DUAL; --L을 붙이면 지역화페기호!

SELECT '2000' + 2000 FROM DUAL; --자동형변환 때문에 가능하다
SELECT '$2000' + 2000 FROM DUAL; --자동형변환이 불가능한 문자있어서 안된다$ //금액형에서 일어나는 문제

--TO_NUMBER - 문자 -> 숫자로 강제 형변환
SELECT TO_NUMBER('$2,000', '$9,999') + 2000 FROM DUAL; --숫자로 형변환

--TO_DATE - 문자 -> 날짜로 강제 형변환
SELECT TO_DATE('2024-02-07', 'YYYY-MM-DD') FROM DUAL;
SELECT '2024-02-07' - HIRE_DATE FROM EMPLOYEES; --X 당연히 안됨
SELECT TO_DATE('2024-02-07', 'YYYY-MM-DD') - HIRE_DATE FROM EMPLOYEES;
SELECT TO_DATE('2024년 02월 07일', 'YYYY"년" MM"월" DD"일"') FROM DUAL;
SELECT TO_DATE('2024-02-07 02:32:24', 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --날짜에선 시간 안보임! 문자에서만 시간 보임


--------------------------------------------------------------------------------
--변환 함수 //이것도 다 중요해요. 외우세요!

--NULL처리 함수
--NVL(타겟, NULL일 경우 대체할 값)
SELECT NVL(3000,0), NVL(NULL, 0) FROM DUAL; --NULL이 아니니까 3000출력, NULL이니까 0출력
--//급여계산 때 필요
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT AS 실제급여 FROM EMPLOYEES; --NULL에 연산이 들어가면 NULL이 나옵니다
--X COMMISSION이 NULL이면 실제급여가 NULL이 되는 경우 발생 (숫자컬럼에서 이런 일이 발생. 우리가 이런거 다 바꿔야 함)
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) AS 실제급여 FROM EMPLOYEES;

--NVL2(타겟, NULL이 아닐 때, NULL일 때)
SELECT NVL2(300, 'NOT NULL', 'NULL') FROM DUAL;
SELECT FIRST_NAME
    ,COMMISSION_PCT
    ,NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY)
FROM EMPLOYEES;

--DECODE(값, 비교값, 결과값, .....여러개....., ELSE문)
SELECT DECODE('B', 'A', 'A입니다', 'B', 'B입니다', 'C', 'C입니다', '나머지입니다') FROM DUAL;
SELECT DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1
                    , 'FT_MGR', SALARY * 1.2
                    , 'AD_VP', SALARY * 1.3
                    , SALARY)
    ,JOB_ID
FROM EMPLOYEES;

--CASE ~ WHEN ~ THEN ~ ELSE ~ END
SELECT FIRST_NAME
    ,JOB_ID
    ,SALARY
    ,CASE JOB_ID WHEN 'IT_PROG' THEN SALARY * 1.1
                WHEN 'FI_MGR' THEN SALARY * 1.2
                WHEN 'AD_VP' THEN SALARY * 1.3
                ELSE SALARY
    END
FROM EMPLOYEES;
--CASE 2번째 방법
--WHEN 조건식을 넣을 수도 있음
SELECT FIRST_NAME
    ,JOB_ID
    ,SALARY
    ,CASE WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.1
        WHEN JOB_ID = 'FI_MGR' THEN SALARY * 1.2
        WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.3
        ELSE SALARY
    END
FROM EMPLOYEES;

--COALESCE(값, 값, ....여러개....) //코얼레스 - NULL이 아닌 첫 번째 인자값을 반환하는 함수
SELECT COALESCE('A', 'B', 'C') FROM DUAL;
SELECT COALESCE(NULL, 'B', 'C') FROM DUAL;
SELECT COALESCE(NULL, NULL, 'C') FROM DUAL;
SELECT COALESCE(NULL, NULL, NULL) FROM DUAL; --셋 다 NULL이면 어쩔 수 없이 널이 나옴

SELECT COALESCE(COMMISSION_PCT, 0), NVL(COMMISSION_PCT, 0) FROM EMPLOYEES;


--------------------------------------------------------------------------------
--날짜 함수, 변환 함수 파트
--문제 1.
--1) 오늘의 환율이 1302.69원 입니다 SALARY컬럼을 한국돈으로 변경해서 소수점 2자리수까지 출력 하세요.
SELECT TO_CHAR(SALARY * 1302.69, 'L99,999,999.99') FROM EMPLOYEES;

SELECT TO_DATE('2024년 02월 07일', 'YYYY"년" MM"월" DD"일"') FROM DUAL;
--2) '20250207' 문자를 '2025년 02월 07일' 로 변환해서 출력하세요.
SELECT TO_DATE('20250207', 'YYYY"년" MM"월" DD"일"') FROM DUAL;  --? 한번에 안바뀜
--문자 -> 문자 로 바꾸는 것은 없음!

SELECT TO_CHAR(TO_DATE('20250207', 'YYYYMMDD'), 'YYY"년" MM"월" DD"일"') FROM DUAL; --먼저 날짜로 바꾼다음 문자로 바꾼다

--문제 2.
SELECT * FROM EMPLOYEES;
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요.
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다.
SELECT EMPLOYEE_ID AS 사원번호, FIRST_NAME || ' ' || LAST_NAME AS 사원명, HIRE_DATE AS 입사일자, FLOOR((SYSDATE - HIRE_DATE) / 365) AS 근속년수
FROM EMPLOYEES WHERE (SYSDATE - HIRE_DATE) / 365 > 10 ORDER BY HIRE_DATE;

SELECT EMPLOYEE_ID AS 사원번호
    , FIRST_NAME || ' ' || LAST_NAME AS 사원명
    , HIRE_DATE AS 입사일자
    , TRUNC((SYSDATE - HIRE_DATE) / 365) AS 근속년수
FROM EMPLOYEES
ORDER BY 근속년수 DESC;  --왜 WHERE을 안쓰지?

--문제 3.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘부장’ 
--120이라면 ‘과장’
--121이라면 ‘대리’
--122라면 ‘주임’
--나머지는 ‘사원’ 으로 출력합니다.
SELECT FIRST_NAME, MANAGER_ID
    ,CASE MANAGER_ID WHEN 100 THEN '부장'
                    WHEN 120 THEN '과장'
                    WHEN 121 THEN '대리'
                    WHEN 122 THEN '주임'
                    ELSE '사원'
    END AS 직급
FROM EMPLOYEES;
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
SELECT FIRST_NAME, MANAGER_ID
    ,CASE MANAGER_ID WHEN 100 THEN '부장'
                    WHEN 120 THEN '과장'
                    WHEN 121 THEN '대리'
                    WHEN 122 THEN '주임'
                    ELSE '사원'
    END AS 직급
FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;

--조건 2) DECODE구문으로 표현해보세요.
SELECT FIRST_NAME
    ,MANAGER_ID
    ,DECODE(MANAGER_ID, 100, '부장'
                        ,120, '과장'
                        ,121, '대리'
                        ,122, '주임'
                        ,'사원') AS 직급
FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;

--조건 3) CASE구문으로 표현해보세요.
SELECT FIRST_NAME
    ,MANAGER_ID
    ,CASE MANAGER_ID WHEN 100 THEN '부장'
                    WHEN 120 THEN '과장'
                    WHEN 121 THEN '대리'
                    WHEN 122 THEN '주임'
                    ELSE '사원'
    END AS 직급
FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;


--문제 4. 
SELECT * FROM EMPLOYEES;
--EMPLOYEES 테이블의 이름, 입사일, 급여, 진급대상, 급여상태 를 출력합니다.
SELECT FIRST_NAME AS 이름, HIRE_DATE AS 입사일, SALARY AS 급여 FROM EMPLOYEES;

--조건1) HIRE_DATE를 XXXX년XX월XX일 형식으로 출력하세요. 
SELECT HIRE_DATE FROM EMPLOYEES;
--조건2) 급여는 커미션값이 퍼센트로 더해진 값을 출력하고, 1300을 곱한 원화로 바꿔서 출력하세요.
--조건3) 진급대상은 5년 마다 이루어 집니다. 근속년수가 5의 배수라면 진급대상으로 출력합니다.
--조건4) 부서가 NULL이 아닌 데이터를 대상으로 출력합니다.
--조건5) 급여상태는 10000이상이면 '상' 10000~5000이라면 '중', 5000이하라면 '하' 로 출력해주세요.


SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름
    ,TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') AS 입사일
    ,TO_CHAR( (SALARY + SALARY * NVL(COMMISSION_PCT,0)) * 1300, 'L999,999,999') AS 급여
    ,DECODE( MOD( TRUNC((SYSDATE - HIRE_DATE) / 365), 5 ), 0, '진급대상', '대상아님') AS 진급상태
    ,CASE WHEN SALARY >= 10000 THEN '상'
        WHEN SALARY >= 5000 THEN '중'
        ELSE '하'
    END AS 급여상태
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL;


