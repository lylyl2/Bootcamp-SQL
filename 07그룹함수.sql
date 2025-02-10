--그룹함수 -행에 대한 기초 통계값

--SUM, AVG, MAX, MIN, COUNT - 전부 NULL이 아닌 데이터에 대해서 통계를 구합니다.
SELECT SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(SALARY) FROM EMPLOYEES;

--MIN, MAX 날짜, 문자열에도 적용이 됩니다.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE), MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

--COUNT 함수는 2가지 사용방법이 있음
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; --35, NULL이 아닌 데이터에 대해서 집계
SELECT COUNT(*) FROM EMPLOYEES; --107, 전체행수(NULL포함)

--주의할 점: 그룹함수는 일반컬럼과 동시에 사용이 불가능
--SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES; --X
--칸 수가 안맞는다!
--방법) 그룹함수 뒤에 OVER()를 붙이면 전체행이 출력이 되고, 그룹함수 사용이 가능함
SELECT FIRST_NAME, AVG(SALARY) OVER(), COUNT(*) OVER() FROM EMPLOYEES;

--------------------------------------------------------------------------------
--GROUP BY절 - 컬럼 기준으로 그룹핑
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, SUM(SALARY), AVG(SALARY), MIN(SALARY), MAX(SALARY), COUNT(*)
FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
--주의할 점! - GROUP BY에 지정되지 않은 컬럼은 SELECT절에 사용할 수 없음.
SELECT DEPARTMENT_ID,
    FIRST_NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID; --X

--2개 이상의 그룹화
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--COUNT(*) OVER() 총 행의 수를 출력할 수도 있음
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*) AS 각그룹에대한행수, COUNT(*) OVER() AS 결과에대한전체행수
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--WHERE절에 그룹의 조건을 넣는 것이 아닙니다.
SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE SALARY >= 50  --가능. 그룹화 하기 전의 조건을 쓰는 것
GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, SUM(SALARY)
FROM EMPLOYEES
WHERE SUM(SALARY) >= 50000 --불가능! GROUP BY 조건을 쓰는 곳은 HAVING이라고 있음!
GROUP BY DEPARTMENT_ID;

--------------------------------------------------------------------------------
--HAVEING 그룹에 대한 조건. GROUP BY절 다음에 HAVING 구문을 넣을 수 있다
--WHERE랑 HAVING이랑 구분하기

--HAVING - GROUP BY의 조건
--WHERE - 일반행 조건
SELECT DEPARTMENT_ID, AVG(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000 AND COUNT(*) >= 1;

--각 직무별 셀러리~들의 급여 평균이 10000이 넘는 직무?
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID LIKE 'SA%'
GROUP BY JOB_ID
HAVING AVG(SALARY) >= 10000
ORDER BY AVG(SALARY) DESC;

--------------------------------------------------------------------------------
--시험 대비!

--ROLLUP - GROUP BY와 함께 사용되고, 상위그룹의 소계를 구합니다.
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID);

--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--CUBE - 롤업에 의해서 구해진 값 + 서브그룹의 통계가 추가됨
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--GROUPING() - 그룹절로 만들어진 경우에는 0을 반환, 롤업 OR 큐브로 만들어진 행의 경우에는 1을 반환
SELECT DEPARTMENT_ID
        ,JOB_ID
        ,AVG(SALARY)
        ,GROUPING(DEPARTMENT_ID)
        ,GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;
--응용할 수 잇음
SELECT DECODE( GROUPING(DEPARTMENT_ID ), 1, '총계', DEPARTMENT_ID ) AS DEPARTMENT_ID
        ,DECODE( GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID
        --,JOB_ID
        ,AVG(SALARY)
        ,GROUPING(DEPARTMENT_ID)
        ,GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;

-------------------------------------------------------------------------------
--그룹함수 연습문제

SELECT * FROM EMPLOYEES;
--문제 1.
--1-1
--사원 테이블에서 JOB_ID별 사원 수, 월급의 평균울 구하세요. 월급의 평균 순으로 내림차순 정렬하세요.
SELECT JOB_ID AS 직무
        ,COUNT(EMPLOYEE_ID) AS 사원수
        ,AVG(SALARY) AS 월급평균
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 월급평균 DESC;
--내림차순 정렬!!

--
SELECT JOB_ID
        ,COUNT(*) AS 사원수
        ,AVG(SALARY) AS 급여평균
        ,MIN(HIRE_DATE)
FROM EMPLOYEES
GROUP BY JOB_ID;

--1-2
--사원 테이블에서 JOB_ID별 가장 빠른 입사일을 구하세요.
SELECT JOB_ID, MIN(HIRE_DATE) AS 가장빠른입사일
FROM EMPLOYEES
GROUP BY JOB_ID;
--
SELECT TO_CHAR(HIRE_DATE, 'YY') AS 입사년도
    ,COUNT(*) AS 사원수
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'YY');

--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT HIRE_DATE AS 입사년도, COUNT(EMPLOYEE_ID) AS 사원수
FROM EMPLOYEES
GROUP BY HIRE_DATE;
--
SELECT DEPARTMENT_ID
    ,AVG(SALARY) AS 평균급여
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID;

--문제 3. *
--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID
    ,AVG(SALARY)
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000;
--
SELECT DEPARTMENT_ID
    ,AVG(SALARY) AS 평균급여
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000;

--문제 3.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순 조회하세요.
--조건) 급여평균이 10000이상인 데이터만.
SELECT AVG(SALARY) AS 급여평균, SUM(SALARY) AS 급여합계
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY SALARY
ORDER BY AVG(SALARY) DESC;
--평균기준 내림차순 조회!
--
SELECT DEPARTMENT_ID
    ,AVG(SALARY) AS 급여평균
    ,SUM(SALARY) AS 급여합계
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND TO_CHAR(HIRE_DATE,'YY') = '05'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY 급여합계;

--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT DEPARTMENT_ID, AVG(SALARY), SUM(SALARY), COUNT(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;
--커미션 어떻게 적용??
--절삭 어떻게?? TRUNC였나
--
SELECT DEPARTMENT_ID
    ,TRUNC( AVG(SALARY + SALARY * COMMISSION_PCT), 2) AS 평균
    ,SUM(SALARY + SALARY * COMMISSION_PCT) AS 합
    ,COUNT(*)
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID;

--문제 6.
--직업별 월급합, 총합계를 출력하세요
SELECT JOB_ID, SUM(SALARY) AS 월급합
FROM EMPLOYEES
GROUP BY JOB_ID;
--총합계???
--
SELECT DECODE( GROUPING(JOB_ID), 1, '총계', JOB_ID ) AS JOB_ID
    ,SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);

--문제 7.
--부서별, JOB_ID를 그룹핑 하여 토탈, 합계를 출력하세요.
--GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT DEPARTMENT_ID, GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID;
--토탈, 합계???
--
SELECT DECODE( GROUPING(DEPARTMENT_ID),1,'합계', DEPARTMENT_ID )AS DEPARTMENT_ID
        ,JOB_ID
        ,COUNT(*) AS TOTAL
        ,SUM(SALARY) AS SUM
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY SUM;











