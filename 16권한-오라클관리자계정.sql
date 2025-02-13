SELECT * FROM HR.EMPLOYEES;

--사용자 계정 확인
SELECT * FROM ALL_USERS;

--현재 사용자의 권한 확인
SELECT * FROM USER_SYS_PRIVS; --//여기까지 안외워도 됨

--사용자 계정을 생성 (관리자만 할 수 있음)
CREATE USER USER01 IDENTIFIED BY USER01; --USER01이 비번 //접속권한이 없어서 접속을 못함. 권한을 줘야함

--데이터베이스에 접속 하려면 접속권한
--테이블생성을 하려면 테이블 생성권한
--뷰 생성을 하려면 뷰 생성권한
--시퀀스 생성을 하려면 시퀀스 생성권한
--프로시저 생성을 하려면 프로시저 생성권한

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE
TO USER01;

--//테이블생성권한을 받았더라도 테이블생성을 못함

--테이블 스페이스 - 테이블에 데이터가 저장되는 물리적인 공간
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; --//안외워도 됨

--권한 회후 REVOKE ~ FROM
REVOKE CREATE SESSION FROM USER01;

--계정 삭제
DROP USER USER01 /*CASCADE*/; --계정이 테이블과 내 데이터를 가지고 있으면, 테이블 포함해서 삭제 일어나야 합니다. //CASCADE(위험, 쓸일X)하면 테이블도 지워버리고 계정도 지워버리고.
