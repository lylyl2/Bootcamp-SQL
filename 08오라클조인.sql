--오라클에서 사용하는 조인문법도 있음 //요즘엔 잘 안씀

--조인을 할 때 조인의 테이블 FROM에 , 로 나열
--WHERE절에서 조인의 조건을 기술함

SELECT * FROM AUTH;
SELECT * FROM INFO;

--INNER JOIN (내부조인)
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID; --6번 데이터는 안나온다

--OUTER JOIN (외부조인)
SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID = A.AUTH_ID(+); --LEFT JOIN 오른쪽 것을 +(붙인다)한다

SELECT *
FROM INFO I, AUTH A
WHERE I.AUTH_ID(+) = A.AUTH_ID; --RIGHT JOIN

--오라클에서 FULL OUTER JOIN 없습니다!

--CROSS JOIN은 조인 조건을 적지 않으면 됩니다.
SELECT *
FROM INFO I, AUTH A; --CROSS JOIN