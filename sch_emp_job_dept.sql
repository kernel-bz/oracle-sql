REM ====================================================================
REM File name: 	emp_job_dept.sql
REM Comments: 	사원_직급_부서 관리을 위한 데이터베이스 스키마
REM Author:		정재준, 2008-09
REM ====================================================================


REM --------------------------------------------------------------------
REM Table name:	region_tbl
REM	Comments: 	지역코드 테이블
REM	Columns:	지역코드, 지역명(대륙명)
REM Keys:		PK(region_id)
REM --------------------------------------------------------------------
       
CREATE TABLE region_tbl
( 
	region_id NUMBER CONSTRAINT region_id_nn NOT NULL 
   , region_name VARCHAR2(25) 
);

COMMENT ON TABLE  region_tbl 				IS '지역코드 테이블';
COMMENT ON COLUMN region_tbl.region_id 		IS '지역코드(기본키)';
COMMENT ON COLUMN region_tbl.region_name 	IS '지역명';
         
COMMIT;
   

REM --------------------------------------------------------------------
REM Table name:	nation_tbl
REM	Comments: 	국가코드 테이블
REM	Columns:	국가코드, 국가명, 지역코드
REM Keys:		PK(nation_id), FK(region_id)
REM --------------------------------------------------------------------
       
CREATE TABLE nation_tbl 
( 
	nation_id CHAR(2) CONSTRAINT nation_id_nn NOT NULL 
	, nation_name VARCHAR2(40) 
   	, region_id NUMBER 
   	, CONSTRAINT nation_c_id_pk PRIMARY KEY (nation_id) 
) ORGANIZATION INDEX;

COMMENT ON TABLE  nation_tbl 				IS '국가코드 테이블';
COMMENT ON COLUMN nation_tbl.nation_id 		IS '국가코드(기본키)';
COMMENT ON COLUMN nation_tbl.nation_name 	IS '국가명';
COMMENT ON COLUMN nation_tbl.region_id 		IS '지역코드(외래키)';

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	location_tbl
REM	Comments: 	위치주소 테이블
REM	Columns:	위치코드, 주소, 우편번호, 도시명, 행정구역명, 국가코드
REM Remarks:	PK(location_id), FK(nation_id)
REM --------------------------------------------------------------------
       
CREATE TABLE location_tbl
( 
	location_id NUMBER(4)
	, street_address VARCHAR2(40)
   	, postal_code VARCHAR2(12)
   	, city VARCHAR2(30) CONSTRAINT loc_city_nn NOT NULL
   	, state_province VARCHAR2(25)
   	, nation_id CHAR(2)
);
   
COMMENT ON TABLE  location_tbl 					IS '위치주소 테이블';
COMMENT ON COLUMN location_tbl.location_id 		IS '위치코드(기본키)';
COMMENT ON COLUMN location_tbl.street_address 	IS '주소';
COMMENT ON COLUMN location_tbl.postal_code 		IS '우편번호';
COMMENT ON COLUMN location_tbl.city 			IS '도시명';
COMMENT ON COLUMN location_tbl.state_province 	IS '행정구역명';
COMMENT ON COLUMN location_tbl.nation_id 		IS '국가코드(외래키)';

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	dept_tbl
REM	Comments: 	부서 테이블
REM	Columns:	부서코드, 부서명, 부서장코드, 위치코드
REM Remarks:	PK(dept_id), FK(location_id, emp_id)
REM --------------------------------------------------------------------
       
CREATE TABLE dept_tbl
( 
	dept_id NUMBER(4)
	, dept_name VARCHAR2(30) CONSTRAINT dept_name_nn NOT NULL
	, manager_id NUMBER(6)
   	, location_id NUMBER(4)
);

COMMENT ON TABLE  dept_tbl 					IS '부서 테이블';
COMMENT ON COLUMN dept_tbl.dept_id 			IS '부서코드(기본키)';
COMMENT ON COLUMN dept_tbl.dept_name 		IS '부서명';
COMMENT ON COLUMN dept_tbl.manager_id 		IS '부서장코드(외래키)';
COMMENT ON COLUMN dept_tbl.location_id 		IS '위치코드(외래키)';

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	job_tbl
REM	Comments: 	직급 테이블
REM	Columns:	직급코드, 직급명, 급여액_최소, 급여액_최대
REM Remarks:	PK(job_id)
REM --------------------------------------------------------------------
       
CREATE TABLE job_tbl
( 
	job_id VARCHAR2(10)
	, job_title VARCHAR2(35) CONSTRAINT job_title_nn NOT NULL
	, min_salary NUMBER(6)
   	, max_salary NUMBER(6)
);

COMMENT ON TABLE  job_tbl 				IS '직급 테이블';
COMMENT ON COLUMN job_tbl.job_id 		IS '직급코드(기본키)';
COMMENT ON COLUMN job_tbl.job_title 	IS '직급명';
COMMENT ON COLUMN job_tbl.min_salary 	IS '급여액_최소';
COMMENT ON COLUMN job_tbl.max_salary 	IS '급여액_최대';

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	emp_tbl
REM	Comments: 	사원 테이블
REM	Columns:	사원코드, 성명1, 성명2, 이메일, 전화, 입사일, 직급코드, 급여액...
REM Remarks:	PK(emp_id), FK(dept_id, job_id, manager_id) 
REM --------------------------------------------------------------------
       
CREATE TABLE emp_tbl
( 
	emp_id NUMBER(6)
   	, first_name VARCHAR2(20)
   	, last_name VARCHAR2(25) CONSTRAINT emp_last_name_nn NOT NULL
   	, email VARCHAR2(25) CONSTRAINT emp_email_nn NOT NULL
   	, phone_number VARCHAR2(20)
   	, hire_date DATE CONSTRAINT emp_hire_date_nn NOT NULL
   	, job_id VARCHAR2(10) CONSTRAINT emp_job_nn NOT NULL
   	, salary NUMBER(8,2)
   	, commission_pct NUMBER(2,2)
   	, manager_id NUMBER(6)
   	, dept_id NUMBER(4)
   	, CONSTRAINT emp_salary_min CHECK (salary > 0) 
   	, CONSTRAINT emp_email_uk UNIQUE (email)
);

COMMENT ON TABLE  emp_tbl 					IS '사원 테이블';
COMMENT ON COLUMN emp_tbl.emp_id 			IS '사원코드(기본키)';
COMMENT ON COLUMN emp_tbl.first_name 		IS '이름';
COMMENT ON COLUMN emp_tbl.last_name 		IS '성명';
COMMENT ON COLUMN emp_tbl.email 			IS '이메일주소';
COMMENT ON COLUMN emp_tbl.phone_number 		IS '전화번호';
COMMENT ON COLUMN emp_tbl.hire_date 		IS '입사일';
COMMENT ON COLUMN emp_tbl.job_id 			IS '직급코드(외부키)';
COMMENT ON COLUMN emp_tbl.salary 			IS '월급여액';
COMMENT ON COLUMN emp_tbl.commission_pct 	IS '보상비율(%)';
COMMENT ON COLUMN emp_tbl.manager_id 		IS '부서장코드(외부키)';
COMMENT ON COLUMN emp_tbl.dept_id 			IS '부서코드(외부키)';

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	job_history_tbl
REM	Comments: 	직급변화 테이블
REM	Columns:	사원코드, 시작일, 종료일, 직급코드, 부서코드
REM Remarks:	PK(emp_id + start_date), FK(emp_id, job_id, dept_id) 
REM --------------------------------------------------------------------
       
CREATE TABLE job_history_tbl
( 
	emp_id NUMBER(6) CONSTRAINT jhist_emp_nn NOT NULL
	, start_date DATE CONSTRAINT jhist_start_date_nn NOT NULL
   	, end_date DATE CONSTRAINT jhist_end_date_nn NOT NULL
   	, job_id VARCHAR2(10) CONSTRAINT jhist_job_nn NOT NULL
   	, dept_id NUMBER(4)
   	, CONSTRAINT jhist_date_interval CHECK (end_date > start_date)
);

COMMENT ON TABLE  job_history_tbl 				IS '직급변화 테이블';
COMMENT ON COLUMN job_history_tbl.emp_id 		IS '사원코드(외부키)';
COMMENT ON COLUMN job_history_tbl.start_date 	IS '시작일';
COMMENT ON COLUMN job_history_tbl.end_date 		IS '종료일';
COMMENT ON COLUMN job_history_tbl.job_id 		IS '직급코드(외부키)';
COMMENT ON COLUMN job_history_tbl.dept_id 		IS '부서코드(외부키)';

COMMIT;


REM ====================================================================
REM 기본 데이터 입력
REM ====================================================================

REM ALTER SESSION SET NLS_LANGUAGE=American; 
ALTER SESSION SET NLS_LANGUAGE=Korean; 


REM --------------------------------------------------------------------
REM 지역코드 테이블(region_tbl)에 데이터 입력
REM --------------------------------------------------------------------

INSERT INTO region_tbl VALUES 
   ( 1
   , 'Europe' 
   );
INSERT INTO region_tbl VALUES 
   ( 2
   , 'Americas' 
   );
INSERT INTO region_tbl VALUES 
   ( 3
   , 'Asia' 
   );
INSERT INTO region_tbl VALUES 
   ( 4
   , 'Middle East' 
   );
INSERT INTO region_tbl VALUES 
   ( 5
   , 'Africa' 
   );
   
COMMIT;


REM --------------------------------------------------------------------
REM 국가코드 테이블(nation_tbl)에 데이터 입력
REM --------------------------------------------------------------------

INSERT INTO nation_tbl VALUES 
   ( 'KR'
   , 'Korea'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'IT'
   , 'Italy'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'JP'
   , 'Japan'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'US'
   , 'United States of America'
   , 2 
   );
INSERT INTO nation_tbl VALUES 
   ( 'CA'
   , 'Canada'
   , 2 
   );
INSERT INTO nation_tbl VALUES 
   ( 'CN'
   , 'China'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'IN'
   , 'India'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'AU'
   , 'Australia'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'ZW'
   , 'Zimbabwe'
   , 5 
   );
INSERT INTO nation_tbl VALUES 
   ( 'SG'
   , 'Singapore'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'UK'
   , 'United Kingdom'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'FR'
   , 'France'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'DE'
   , 'Germany'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'ZM'
   , 'Zambia'
   , 5 
   );
INSERT INTO nation_tbl VALUES 
   ( 'EG'
   , 'Egypt'
   , 5 
   );
INSERT INTO nation_tbl VALUES 
   ( 'BR'
   , 'Brazil'
   , 2 
   );
INSERT INTO nation_tbl VALUES 
   ( 'CH'
   , 'Switzerland'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'NL'
   , 'Netherlands'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'MX'
   , 'Mexico'
   , 2 
   );
INSERT INTO nation_tbl VALUES 
   ( 'KW'
   , 'Kuwait'
   , 4 
   );
INSERT INTO nation_tbl VALUES 
   ( 'IL'
   , 'Israel'
   , 4 
   );
INSERT INTO nation_tbl VALUES 
   ( 'DK'
   , 'Denmark'
   , 1 
   );
INSERT INTO nation_tbl VALUES 
   ( 'HK'
   , 'HongKong'
   , 3 
   );
INSERT INTO nation_tbl VALUES 
   ( 'NG'
   , 'Nigeria'
   , 5 
   );
INSERT INTO nation_tbl VALUES 
   ( 'AR'
   , 'Argentina'
   , 2 
   );
INSERT INTO nation_tbl VALUES 
   ( 'BE'
   , 'Belgium'
   , 1 
   );

COMMIT;


REM --------------------------------------------------------------------
REM 위치주소 테이블(location_tbl)에 데이터 입력
REM --------------------------------------------------------------------

INSERT INTO location_tbl VALUES 
   ( 100 
   , '28 종로구 연건동'
   , '110744'
   , '서울'
   , '서울광역시'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 200 
   , '1055 강서구 강동동'
   , '618800'
   , '부산'
   , '부산광역시'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 300 
   , '808 남구 대명10동'
   , '705810'
   , '대구'
   , '대구광역시'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 400 
   , '10 강화읍 갑곳리'
   , '417801'
   , '강화군'
   , '인천광역시'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 500 
   , '700 광산구 도산동'
   , '506800'
   , '광주'
   , '광주광역시'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 600 
   , '375 화도읍 가곡리'
   , '472841'
   , '남양주'
   , '경기도'
   , 'KR'
   );
INSERT INTO location_tbl VALUES 
   ( 1000 
   , '1297 Via Cola di Rie'
   , '00989'
   , 'Roma'
   , NULL
   , 'IT'
   );
INSERT INTO location_tbl VALUES 
   ( 1100 
   , '93091 Calle della Testa'
   , '10934'
   , 'Venice'
   , NULL
   , 'IT'
   );
INSERT INTO location_tbl VALUES 
   ( 1200 
   , '2017 Shinjuku-ku'
   , '1689'
   , 'Tokyo'
   , 'Tokyo Prefecture'
   , 'JP'
   );
INSERT INTO location_tbl VALUES 
   ( 1300 
   , '9450 Kamiya-cho'
   , '6823'
   , 'Hiroshima'
   , NULL
   , 'JP'
   );
INSERT INTO location_tbl VALUES 
   ( 1400 
   , '2014 Jabberwocky Rd'
   , '26192'
   , 'Southlake'
   , 'Texas'
   , 'US'
   );
INSERT INTO location_tbl VALUES 
   ( 1500 
   , '2011 Interiors Blvd'
   , '99236'
   , 'South San Francisco'
   , 'California'
   , 'US'
   );
INSERT INTO location_tbl VALUES 
   ( 1600 
   , '2007 Zagora St'
   , '50090'
   , 'South Brunswick'
   , 'New Jersey'
   , 'US'
   );
INSERT INTO location_tbl VALUES 
   ( 1700 
   , '2004 Charade Rd'
   , '98199'
   , 'Seattle'
   , 'Washington'
   , 'US'
   );
INSERT INTO location_tbl VALUES 
   ( 1800 
   , '147 Spadina Ave'
   , 'M5V 2L7'
   , 'Toronto'
   , 'Ontario'
   , 'CA'
   );
INSERT INTO location_tbl VALUES 
   ( 1900 
   , '6092 Boxwood St'
   , 'YSW 9T2'
   , 'Whitehorse'
   , 'Yukon'
   , 'CA'
   );
INSERT INTO location_tbl VALUES 
   ( 2000 
   , '40-5-12 Laogianggen'
   , '190518'
   , 'Beijing'
   , NULL
   , 'CN'
   );
INSERT INTO location_tbl VALUES 
   ( 2100 
   , '1298 Vileparle (E)'
   , '490231'
   , 'Bombay'
   , 'Maharashtra'
   , 'IN'
   );
INSERT INTO location_tbl VALUES 
   ( 2200 
   , '12-98 Victoria Street'
   , '2901'
   , 'Sydney'
   , 'New South Wales'
   , 'AU'
   );
INSERT INTO location_tbl VALUES 
   ( 2300 
   , '198 Clementi North'
   , '540198'
   , 'Singapore'
   , NULL
   , 'SG'
   );
INSERT INTO location_tbl VALUES 
   ( 2400 
   , '8204 Arthur St'
   , NULL
   , 'London'
   , NULL
   , 'UK'
   );
INSERT INTO location_tbl VALUES 
   ( 2500 
   , 'Magdalen Centre, The Oxford Science Park'
   , 'OX9 9ZB'
   , 'Oxford'
   , 'Oxford'
   , 'UK'
   );
INSERT INTO location_tbl VALUES 
   ( 2600 
   , '9702 Chester Road'
   , '09629850293'
   , 'Stretford'
   , 'Manchester'
   , 'UK'
   );
INSERT INTO location_tbl VALUES 
   ( 2700 
   , 'Schwanthalerstr. 7031'
   , '80925'
   , 'Munich'
   , 'Bavaria'
   , 'DE'
   );
INSERT INTO location_tbl VALUES 
   ( 2800 
   , 'Rua Frei Caneca 1360 '
   , '01307-002'
   , 'Sao Paulo'
   , 'Sao Paulo'
   , 'BR'
   );
INSERT INTO location_tbl VALUES 
   ( 2900 
   , '20 Rue des Corps-Saints'
   , '1730'
   , 'Geneva'
   , 'Geneve'
   , 'CH'
   );
INSERT INTO location_tbl VALUES 
   ( 3000 
   , 'Murtenstrasse 921'
   , '3095'
   , 'Bern'
   , 'BE'
   , 'CH'
   );
INSERT INTO location_tbl VALUES 
   ( 3100 
   , 'Pieter Breughelstraat 837'
   , '3029SK'
   , 'Utrecht'
   , 'Utrecht'
   , 'NL'
   );
INSERT INTO location_tbl VALUES 
   ( 3200 
   , 'Mariano Escobedo 9991'
   , '11932'
   , 'Mexico City'
   , 'Distrito Federal,'
   , 'MX'
   );

COMMIT;


REM --------------------------------------------------------------------
REM 부서 테이블(dept_tbl)에 데이터 입력
REM --------------------------------------------------------------------

REM disable integrity constraint to EMPLOYEES to load data
REM ALTER TABLE dept_tbl DISABLE CONSTRAINT dept_mgr_fk;
   
INSERT INTO dept_tbl VALUES 
   ( 10
   , 'Administration'
   , 200
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 20
   , 'Marketing'
   , 201
   , 1800
   );
   
INSERT INTO dept_tbl VALUES 
   ( 30
   , 'Purchasing'
   , 114
   , 1700
   );
   
INSERT INTO dept_tbl VALUES 
   ( 40
   , 'Human Resources'
   , 203
   , 2400
   );
INSERT INTO dept_tbl VALUES 
   ( 50
   , 'Shipping'
   , 121
   , 1500
   );
   
INSERT INTO dept_tbl VALUES 
   ( 60 
   , 'IT'
   , 103
   , 1400
   );
   
INSERT INTO dept_tbl VALUES 
   ( 70 
   , 'Public Relations'
   , 204
   , 2700
   );
   
INSERT INTO dept_tbl VALUES 
   ( 80 
   , 'Sales'
   , 145
   , 2500
   );
   
INSERT INTO dept_tbl VALUES 
   ( 90 
   , 'Executive'
   , 100
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 100 
   , 'Finance'
   , 108
   , 1700
   );
   
INSERT INTO dept_tbl VALUES 
   ( 110 
   , 'Accounting'
   , 205
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 120 
   , 'Treasury'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 130 
   , 'Corporate Tax'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 140 
   , 'Control And Credit'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 150 
   , 'Shareholder Services'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 160 
   , 'Benefits'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 170 
   , 'Manufacturing'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 180 
   , 'Construction'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 190 
   , 'Contracting'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 200 
   , 'Operations'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 210 
   , 'IT Support'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 220 
   , 'NOC'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 230 
   , 'IT Helpdesk'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 240 
   , 'Government Sales'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 250 
   , 'Retail Sales'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 260 
   , 'Recruiting'
   , NULL
   , 1700
   );
INSERT INTO dept_tbl VALUES 
   ( 270 
   , 'Payroll'
   , NULL
   , 1700
   );
   
INSERT INTO dept_tbl VALUES 
   ( 280 
   , '경영지원실'
   , NULL
   , 100
   );
INSERT INTO dept_tbl VALUES 
   ( 290 
   , '영업부'
   , NULL
   , 200
   );
INSERT INTO dept_tbl VALUES 
   ( 300 
   , '연구개발실'
   , NULL
   , 300
   );
INSERT INTO dept_tbl VALUES 
   ( 310 
   , '고객지원부'
   , NULL
   , 400
   );
INSERT INTO dept_tbl VALUES 
   ( 320 
   , '홍보실'
   , NULL
   , 500
   );
INSERT INTO dept_tbl VALUES 
   ( 330 
   , '교육연수원'
   , NULL
   , 600
   );

COMMIT;  


REM --------------------------------------------------------------------
REM 직급 테이블(job_tbl)에 데이터 입력
REM --------------------------------------------------------------------

INSERT INTO job_tbl VALUES 
   ( 'JOB10'
   , '대표이사'
   , 20000
   , 40000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB20'
   , '이사'
   , 10000
   , 20000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB30'
   , '원장'
   , 8000
   , 10000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB40'
   , '실장'
   , 7000
   , 8000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB50'
   , '부장'
   , 6000
   , 7000
   );   
INSERT INTO job_tbl VALUES 
   ( 'JOB60'
   , '팀장'
   , 5000
   , 6000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB70'
   , '대리'
   , 4000
   , 5000
   );
INSERT INTO job_tbl VALUES 
   ( 'JOB80'
   , '사원'
   , 2000
   , 4000
   );
   
INSERT INTO job_tbl VALUES 
   ( 'AD_PRES'
   , 'President'
   , 20000
   , 40000
   );
INSERT INTO job_tbl VALUES 
   ( 'AD_VP'
   , 'Administration Vice President'
   , 15000
   , 30000
   );
INSERT INTO job_tbl VALUES 
   ( 'AD_ASST'
   , 'Administration Assistant'
   , 3000
   , 6000
   );
INSERT INTO job_tbl VALUES 
   ( 'FI_MGR'
   , 'Finance Manager'
   , 8200
   , 16000
   );
INSERT INTO job_tbl VALUES 
   ( 'FI_ACCOUNT'
   , 'Accountant'
   , 4200
   , 9000
   );
INSERT INTO job_tbl VALUES 
   ( 'AC_MGR'
   , 'Accounting Manager'
   , 8200
   , 16000
   );
INSERT INTO job_tbl VALUES 
   ( 'AC_ACCOUNT'
   , 'Public Accountant'
   , 4200
   , 9000
   );
INSERT INTO job_tbl VALUES 
   ( 'SA_MAN'
   , 'Sales Manager'
   , 10000
   , 20000
   );
INSERT INTO job_tbl VALUES 
   ( 'SA_REP'
   , 'Sales Representative'
   , 6000
   , 12000
   );
INSERT INTO job_tbl VALUES 
   ( 'PU_MAN'
   , 'Purchasing Manager'
   , 8000
   , 15000
   );
INSERT INTO job_tbl VALUES 
   ( 'PU_CLERK'
   , 'Purchasing Clerk'
   , 2500
   , 5500
   );
INSERT INTO job_tbl VALUES 
   ( 'ST_MAN'
   , 'Stock Manager'
   , 5500
   , 8500
   );
INSERT INTO job_tbl VALUES 
   ( 'ST_CLERK'
   , 'Stock Clerk'
   , 2000
   , 5000
   );
INSERT INTO job_tbl VALUES 
   ( 'SH_CLERK'
   , 'Shipping Clerk'
   , 2500
   , 5500
   );
INSERT INTO job_tbl VALUES 
   ( 'IT_PROG'
   , 'Programmer'
   , 4000
   , 10000
   );
INSERT INTO job_tbl VALUES 
   ( 'MK_MAN'
   , 'Marketing Manager'
   , 9000
   , 15000
   );
INSERT INTO job_tbl VALUES 
   ( 'MK_REP'
   , 'Marketing Representative'
   , 4000
   , 9000
   );
INSERT INTO job_tbl VALUES 
   ( 'HR_REP'
   , 'Human Resources Representative'
   , 4000
   , 9000
   );
INSERT INTO job_tbl VALUES 
   ( 'PR_REP'
   , 'Public Relations Representative'
   , 4500
   , 10500
   );
       
COMMIT;


REM --------------------------------------------------------------------
REM 사원 테이블(emp_tbl)에 데이터 입력
REM --------------------------------------------------------------------

INSERT INTO emp_tbl VALUES 
   ( 10
   , '재준'
   , '정'
   , 'jungjj'
   , '02-123-4567'
   , TO_DATE('2002-01-20', 'yyyy-mm-dd')
   , 'JOB60'
   , 5500
   , .30
   , 11
   , 300
   );
INSERT INTO emp_tbl VALUES 
   ( 11
   , '길동'
   , '홍'
   , 'hongkd'
   , '02-123-4567'
   , TO_DATE('2001-02-19', 'yyyy-mm-dd')
   , 'JOB10'
   , 40000
   , .10
   , NULL
   , 280
   );
INSERT INTO emp_tbl VALUES 
   ( 12
   , '종서'
   , '김'
   , 'kimjs'
   , '02-123-4567'
   , TO_DATE('2001-03-15', 'yyyy-mm-dd')
   , 'JOB20'
   , 20000
   , .15
   , 11
   , 290
   );
INSERT INTO emp_tbl VALUES 
   ( 13
   , '순신'
   , '이'
   , 'leess'
   , '02-123-4567'
   , TO_DATE('2002-03-02', 'yyyy-mm-dd')
   , 'JOB30'
   , 10000
   , .20
   , 12
   , 310
   );
INSERT INTO emp_tbl VALUES 
   ( 14
   , '치원'
   , '최'
   , 'choicw'
   , '02-123-4567'
   , TO_DATE('2003-02-01', 'yyyy-mm-dd')
   , 'JOB40'
   , 8000
   , .25
   , 13
   , 320
   );
INSERT INTO emp_tbl VALUES 
   ( 15
   , '지성'
   , '박'
   , 'parkjs'
   , '02-123-4567'
   , TO_DATE('2005-04-23', 'yyyy-mm-dd')
   , 'JOB70'
   , 4000
   , .05
   , 14
   , 330
   );
INSERT INTO emp_tbl VALUES 
   ( 100
   , 'Steven'
   , 'King'
   , 'SKING'
   , '515.123.4567'
   , TO_DATE('17-01-1987', 'dd-mm-yyyy')
   , 'AD_PRES'
   , 24000
   , NULL
   , NULL
   , 90
   );
INSERT INTO emp_tbl VALUES 
   ( 101
   , 'Neena'
   , 'Kochhar'
   , 'NKOCHHAR'
   , '515.123.4568'
   , TO_DATE('21-09-1989', 'dd-mm-yyyy')
   , 'AD_VP'
   , 17000
   , NULL
   , 100
   , 90
   );
INSERT INTO emp_tbl VALUES 
   ( 102
   , 'Lex'
   , 'De Haan'
   , 'LDEHAAN'
   , '515.123.4569'
   , TO_DATE('13-01-1993', 'dd-mm-yyyy')
   , 'AD_VP'
   , 17000
   , NULL
   , 100
   , 90
   );
INSERT INTO emp_tbl VALUES 
   ( 103
   , 'Alexander'
   , 'Hunold'
   , 'AHUNOLD'
   , '590.423.4567'
   , TO_DATE('03-01-1990', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 9000
   , NULL
   , 102
   , 60
   );
INSERT INTO emp_tbl VALUES 
   ( 104
   , 'Bruce'
   , 'Ernst'
   , 'BERNST'
   , '590.423.4568'
   , TO_DATE('21-05-1991', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 6000
   , NULL
   , 103
   , 60
   );
INSERT INTO emp_tbl VALUES 
   ( 105
   , 'David'
   , 'Austin'
   , 'DAUSTIN'
   , '590.423.4569'
   , TO_DATE('25-01-1997', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 4800
   , NULL
   , 103
   , 60
   );
INSERT INTO emp_tbl VALUES 
   ( 106
   , 'Valli'
   , 'Pataballa'
   , 'VPATABAL'
   , '590.423.4560'
   , TO_DATE('05-02-1998', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 4800
   , NULL
   , 103
   , 60
   );
INSERT INTO emp_tbl VALUES 
   ( 107
   , 'Diana'
   , 'Lorentz'
   , 'DLORENTZ'
   , '590.423.5567'
   , TO_DATE('07-02-1999', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 4200
   , NULL
   , 103
   , 60
   );
INSERT INTO emp_tbl VALUES 
   ( 108
   , 'Nancy'
   , 'Greenberg'
   , 'NGREENBE'
   , '515.124.4569'
   , TO_DATE('17-08-1994', 'dd-mm-yyyy')
   , 'FI_MGR'
   , 12000
   , NULL
   , 101
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 109
   , 'Daniel'
   , 'Faviet'
   , 'DFAVIET'
   , '515.124.4169'
   , TO_DATE('16-08-1994', 'dd-mm-yyyy')
   , 'FI_ACCOUNT'
   , 9000
   , NULL
   , 108
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 110
   , 'John'
   , 'Chen'
   , 'JCHEN'
   , '515.124.4269'
   , TO_DATE('28-09-1997', 'dd-mm-yyyy')
   , 'FI_ACCOUNT'
   , 8200
   , NULL
   , 108
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 111
   , 'Ismael'
   , 'Sciarra'
   , 'ISCIARRA'
   , '515.124.4369'
   , TO_DATE('30-09-1997', 'dd-mm-yyyy')
   , 'FI_ACCOUNT'
   , 7700
   , NULL
   , 108
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 112
   , 'Jose Manuel'
   , 'Urman'
   , 'JMURMAN'
   , '515.124.4469'
   , TO_DATE('07-03-1998', 'dd-mm-yyyy')
   , 'FI_ACCOUNT'
   , 7800
   , NULL
   , 108
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 113
   , 'Luis'
   , 'Popp'
   , 'LPOPP'
   , '515.124.4567'
   , TO_DATE('07-12-1999', 'dd-mm-yyyy')
   , 'FI_ACCOUNT'
   , 6900
   , NULL
   , 108
   , 100
   );
INSERT INTO emp_tbl VALUES 
   ( 114
   , 'Den'
   , 'Raphaely'
   , 'DRAPHEAL'
   , '515.127.4561'
   , TO_DATE('07-12-1994', 'dd-mm-yyyy')
   , 'PU_MAN'
   , 11000
   , NULL
   , 100
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 115
   , 'Alexander'
   , 'Khoo'
   , 'AKHOO'
   , '515.127.4562'
   , TO_DATE('18-05-1995', 'dd-mm-yyyy')
   , 'PU_CLERK'
   , 3100
   , NULL
   , 114
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 116
   , 'Shelli'
   , 'Baida'
   , 'SBAIDA'
   , '515.127.4563'
   , TO_DATE('24-12-1997', 'dd-mm-yyyy')
   , 'PU_CLERK'
   , 2900
   , NULL
   , 114
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 117
   , 'Sigal'
   , 'Tobias'
   , 'STOBIAS'
   , '515.127.4564'
   , TO_DATE('24-07-1997', 'dd-mm-yyyy')
   , 'PU_CLERK'
   , 2800
   , NULL
   , 114
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 118
   , 'Guy'
   , 'Himuro'
   , 'GHIMURO'
   , '515.127.4565'
   , TO_DATE('15-11-1998', 'dd-mm-yyyy')
   , 'PU_CLERK'
   , 2600
   , NULL
   , 114
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 119
   , 'Karen'
   , 'Colmenares'
   , 'KCOLMENA'
   , '515.127.4566'
   , TO_DATE('10-08-1999', 'dd-mm-yyyy')
   , 'PU_CLERK'
   , 2500
   , NULL
   , 114
   , 30
   );
INSERT INTO emp_tbl VALUES 
   ( 120
   , 'Matthew'
   , 'Weiss'
   , 'MWEISS'
   , '650.123.1234'
   , TO_DATE('18-07-1996', 'dd-mm-yyyy')
   , 'ST_MAN'
   , 8000
   , NULL
   , 100
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 121
   , 'Adam'
   , 'Fripp'
   , 'AFRIPP'
   , '650.123.2234'
   , TO_DATE('10-04-1997', 'dd-mm-yyyy')
   , 'ST_MAN'
   , 8200
   , NULL
   , 100
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 122
   , 'Payam'
   , 'Kaufling'
   , 'PKAUFLIN'
   , '650.123.3234'
   , TO_DATE('01-05-1995', 'dd-mm-yyyy')
   , 'ST_MAN'
   , 7900
   , NULL
   , 100
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 123
   , 'Shanta'
   , 'Vollman'
   , 'SVOLLMAN'
   , '650.123.4234'
   , TO_DATE('10-10-1997', 'dd-mm-yyyy')
   , 'ST_MAN'
   , 6500
   , NULL
   , 100
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 124
   , 'Kevin'
   , 'Mourgos'
   , 'KMOURGOS'
   , '650.123.5234'
   , TO_DATE('16-11-1999', 'dd-mm-yyyy')
   , 'ST_MAN'
   , 5800
   , NULL
   , 100
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 125
   , 'Julia'
   , 'Nayer'
   , 'JNAYER'
   , '650.124.1214'
   , TO_DATE('16-07-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3200
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 126
   , 'Irene'
   , 'Mikkilineni'
   , 'IMIKKILI'
   , '650.124.1224'
   , TO_DATE('28-09-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2700
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 127
   , 'James'
   , 'Landry'
   , 'JLANDRY'
   , '650.124.1334'
   , TO_DATE('14-01-1999', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2400
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 128
   , 'Steven'
   , 'Markle'
   , 'SMARKLE'
   , '650.124.1434'
   , TO_DATE('08-03-2000', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2200
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 129
   , 'Laura'
   , 'Bissot'
   , 'LBISSOT'
   , '650.124.5234'
   , TO_DATE('20-08-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3300
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 130
   , 'Mozhe'
   , 'Atkinson'
   , 'MATKINSO'
   , '650.124.6234'
   , TO_DATE('30-10-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2800
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 131
   , 'James'
   , 'Marlow'
   , 'JAMRLOW'
   , '650.124.7234'
   , TO_DATE('16-02-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2500
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 132
   , 'TJ'
   , 'Olson'
   , 'TJOLSON'
   , '650.124.8234'
   , TO_DATE('10-04-1999', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2100
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 133
   , 'Jason'
   , 'Mallin'
   , 'JMALLIN'
   , '650.127.1934'
   , TO_DATE('14-01-1996', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3300
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 134
   , 'Michael'
   , 'Rogers'
   , 'MROGERS'
   , '650.127.1834'
   , TO_DATE('26-08-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2900
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 135
   , 'Ki'
   , 'Gee'
   , 'KGEE'
   , '650.127.1734'
   , TO_DATE('12-12-1999', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2400
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 136
   , 'Hazel'
   , 'Philtanker'
   , 'HPHILTAN'
   , '650.127.1634'
   , TO_DATE('06-02-2000', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2200
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 137
   , 'Renske'
   , 'Ladwig'
   , 'RLADWIG'
   , '650.121.1234'
   , TO_DATE('14-07-1995', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3600
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 138
   , 'Stephen'
   , 'Stiles'
   , 'SSTILES'
   , '650.121.2034'
   , TO_DATE('26-10-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3200
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 139
   , 'John'
   , 'Seo'
   , 'JSEO'
   , '650.121.2019'
   , TO_DATE('12-02-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2700
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 140
   , 'Joshua'
   , 'Patel'
   , 'JPATEL'
   , '650.121.1834'
   , TO_DATE('06-04-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2500
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 141
   , 'Trenna'
   , 'Rajs'
   , 'TRAJS'
   , '650.121.8009'
   , TO_DATE('17-10-1995', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3500
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 142
   , 'Curtis'
   , 'Davies'
   , 'CDAVIES'
   , '650.121.2994'
   , TO_DATE('29-01-1997', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 3100
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 143
   , 'Randall'
   , 'Matos'
   , 'RMATOS'
   , '650.121.2874'
   , TO_DATE('15-03-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2600
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 144
   , 'Peter'
   , 'Vargas'
   , 'PVARGAS'
   , '650.121.2004'
   , TO_DATE('09-07-1998', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 2500
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 145
   , 'John'
   , 'Russell'
   , 'JRUSSEL'
   , '011.44.1344.429268'
   , TO_DATE('01-10-1996', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 14000
   , .4
   , 100
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 146
   , 'Karen'
   , 'Partners'
   , 'KPARTNER'
   , '011.44.1344.467268'
   , TO_DATE('05-01-1997', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 13500
   , .3
   , 100
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 147
   , 'Alberto'
   , 'Errazuriz'
   , 'AERRAZUR'
   , '011.44.1344.429278'
   , TO_DATE('10-03-1997', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 12000
   , .3
   , 100
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 148
   , 'Gerald'
   , 'Cambrault'
   , 'GCAMBRAU'
   , '011.44.1344.619268'
   , TO_DATE('15-10-1999', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 11000
   , .3
   , 100
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 149
   , 'Eleni'
   , 'Zlotkey'
   , 'EZLOTKEY'
   , '011.44.1344.429018'
   , TO_DATE('29-01-2000', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 10500
   , .2
   , 100
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 150
   , 'Peter'
   , 'Tucker'
   , 'PTUCKER'
   , '011.44.1344.129268'
   , TO_DATE('30-01-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 10000
   , .3
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 151
   , 'David'
   , 'Bernstein'
   , 'DBERNSTE'
   , '011.44.1344.345268'
   , TO_DATE('24-03-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9500
   , .25
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 152
   , 'Peter'
   , 'Hall'
   , 'PHALL'
   , '011.44.1344.478968'
   , TO_DATE('20-08-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9000
   , .25
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 153
   , 'Christopher'
   , 'Olsen'
   , 'COLSEN'
   , '011.44.1344.498718'
   , TO_DATE('30-03-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 8000
   , .2
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 154
   , 'Nanette'
   , 'Cambrault'
   , 'NCAMBRAU'
   , '011.44.1344.987668'
   , TO_DATE('09-12-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7500
   , .2
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 155
   , 'Oliver'
   , 'Tuvault'
   , 'OTUVAULT'
   , '011.44.1344.486508'
   , TO_DATE('23-11-1999', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7000
   , .15
   , 145
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 156
   , 'Janette'
   , 'King'
   , 'JKING'
   , '011.44.1345.429268'
   , TO_DATE('30-01-1996', 'dd-mm-yyyy')
   , 'SA_REP'
   , 10000
   , .35
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 157
   , 'Patrick'
   , 'Sully'
   , 'PSULLY'
   , '011.44.1345.929268'
   , TO_DATE('04-03-1996', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9500
   , .35
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 158
   , 'Allan'
   , 'McEwen'
   , 'AMCEWEN'
   , '011.44.1345.829268'
   , TO_DATE('01-08-1996', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9000
   , .35
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 159
   , 'Lindsey'
   , 'Smith'
   , 'LSMITH'
   , '011.44.1345.729268'
   , TO_DATE('10-03-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 8000
   , .3
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 160
   , 'Louise'
   , 'Doran'
   , 'LDORAN'
   , '011.44.1345.629268'
   , TO_DATE('15-12-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7500
   , .3
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 161
   , 'Sarath'
   , 'Sewall'
   , 'SSEWALL'
   , '011.44.1345.529268'
   , TO_DATE('03-11-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7000
   , .25
   , 146
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 162
   , 'Clara'
   , 'Vishney'
   , 'CVISHNEY'
   , '011.44.1346.129268'
   , TO_DATE('11-11-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 10500
   , .25
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 163
   , 'Danielle'
   , 'Greene'
   , 'DGREENE'
   , '011.44.1346.229268'
   , TO_DATE('19-03-1999', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9500
   , .15
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 164
   , 'Mattea'
   , 'Marvins'
   , 'MMARVINS'
   , '011.44.1346.329268'
   , TO_DATE('24-01-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7200
   , .10
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 165
   , 'David'
   , 'Lee'
   , 'DLEE'
   , '011.44.1346.529268'
   , TO_DATE('23-02-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 6800
   , .1
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 166
   , 'Sundar'
   , 'Ande'
   , 'SANDE'
   , '011.44.1346.629268'
   , TO_DATE('24-03-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 6400
   , .10
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 167
   , 'Amit'
   , 'Banda'
   , 'ABANDA'
   , '011.44.1346.729268'
   , TO_DATE('21-04-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 6200
   , .10
   , 147
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 168
   , 'Lisa'
   , 'Ozer'
   , 'LOZER'
   , '011.44.1343.929268'
   , TO_DATE('11-03-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 11500
   , .25
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 169 
   , 'Harrison'
   , 'Bloom'
   , 'HBLOOM'
   , '011.44.1343.829268'
   , TO_DATE('23-03-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 10000
   , .20
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 170
   , 'Tayler'
   , 'Fox'
   , 'TFOX'
   , '011.44.1343.729268'
   , TO_DATE('24-01-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 9600
   , .20
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 171
   , 'William'
   , 'Smith'
   , 'WSMITH'
   , '011.44.1343.629268'
   , TO_DATE('23-02-1999', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7400
   , .15
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 172
   , 'Elizabeth'
   , 'Bates'
   , 'EBATES'
   , '011.44.1343.529268'
   , TO_DATE('24-03-1999', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7300
   , .15
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 173
   , 'Sundita'
   , 'Kumar'
   , 'SKUMAR'
   , '011.44.1343.329268'
   , TO_DATE('21-04-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 6100
   , .10
   , 148
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 174
   , 'Ellen'
   , 'Abel'
   , 'EABEL'
   , '011.44.1644.429267'
   , TO_DATE('11-05-1996', 'dd-mm-yyyy')
   , 'SA_REP'
   , 11000
   , .30
   , 149
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 175
   , 'Alyssa'
   , 'Hutton'
   , 'AHUTTON'
   , '011.44.1644.429266'
   , TO_DATE('19-03-1997', 'dd-mm-yyyy')
   , 'SA_REP'
   , 8800
   , .25
   , 149
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 176
   , 'Jonathon'
   , 'Taylor'
   , 'JTAYLOR'
   , '011.44.1644.429265'
   , TO_DATE('24-03-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 8600
   , .20
   , 149
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 177
   , 'Jack'
   , 'Livingston'
   , 'JLIVINGS'
   , '011.44.1644.429264'
   , TO_DATE('23-04-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 8400
   , .20
   , 149
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 178
   , 'Kimberely'
   , 'Grant'
   , 'KGRANT'
   , '011.44.1644.429263'
   , TO_DATE('24-05-1999', 'dd-mm-yyyy')
   , 'SA_REP'
   , 7000
   , .15
   , 149
   , NULL
   );
INSERT INTO emp_tbl VALUES 
   ( 179
   , 'Charles'
   , 'Johnson'
   , 'CJOHNSON'
   , '011.44.1644.429262'
   , TO_DATE('04-01-2000', 'dd-mm-yyyy')
   , 'SA_REP'
   , 6200
   , .10
   , 149
   , 80
   );
INSERT INTO emp_tbl VALUES 
   ( 180
   , 'Winston'
   , 'Taylor'
   , 'WTAYLOR'
   , '650.507.9876'
   , TO_DATE('24-01-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3200
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 181
   , 'Jean'
   , 'Fleaur'
   , 'JFLEAUR'
   , '650.507.9877'
   , TO_DATE('23-02-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3100
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 182
   , 'Martha'
   , 'Sullivan'
   , 'MSULLIVA'
   , '650.507.9878'
   , TO_DATE('21-01-1999', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2500
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 183
   , 'Girard'
   , 'Geoni'
   , 'GGEONI'
   , '650.507.9879'
   , TO_DATE('03-02-2000', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2800
   , NULL
   , 120
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 184
   , 'Nandita'
   , 'Sarchand'
   , 'NSARCHAN'
   , '650.509.1876'
   , TO_DATE('27-01-1996', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 4200
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 185
   , 'Alexis'
   , 'Bull'
   , 'ABULL'
   , '650.509.2876'
   , TO_DATE('20-02-1997', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 4100
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 186
   , 'Julia'
   , 'Dellinger'
   , 'JDELLING'
   , '650.509.3876'
   , TO_DATE('24-01-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3400
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 187
   , 'Anthony'
   , 'Cabrio'
   , 'ACABRIO'
   , '650.509.4876'
   , TO_DATE('07-02-1999', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3000
   , NULL
   , 121
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 188
   , 'Kelly'
   , 'Chung'
   , 'KCHUNG'
   , '650.505.1876'
   , TO_DATE('14-01-1997', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3800
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 189
   , 'Jennifer'
   , 'Dilly'
   , 'JDILLY'
   , '650.505.2876'
   , TO_DATE('13-08-1997', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3600
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 190
   , 'Timothy'
   , 'Gates'
   , 'TGATES'
   , '650.505.3876'
   , TO_DATE('11-07-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2900
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 191
   , 'Randall'
   , 'Perkins'
   , 'RPERKINS'
   , '650.505.4876'
   , TO_DATE('19-12-1999', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2500
   , NULL
   , 122
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 192
   , 'Sarah'
   , 'Bell'
   , 'SBELL'
   , '650.501.1876'
   , TO_DATE('04-02-1996', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 4000
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 193
   , 'Britney'
   , 'Everett'
   , 'BEVERETT'
   , '650.501.2876'
   , TO_DATE('03-03-1997', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3900
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 194
   , 'Samuel'
   , 'McCain'
   , 'SMCCAIN'
   , '650.501.3876'
   , TO_DATE('01-07-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3200
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 195
   , 'Vance'
   , 'Jones'
   , 'VJONES'
   , '650.501.4876'
   , TO_DATE('17-03-1999', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2800
   , NULL
   , 123
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 196
   , 'Alana'
   , 'Walsh'
   , 'AWALSH'
   , '650.507.9811'
   , TO_DATE('24-04-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3100
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 197
   , 'Kevin'
   , 'Feeney'
   , 'KFEENEY'
   , '650.507.9822'
   , TO_DATE('23-05-1998', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 3000
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 198
   , 'Donald'
   , 'OConnell'
   , 'DOCONNEL'
   , '650.507.9833'
   , TO_DATE('21-01-1999', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2600
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 199
   , 'Douglas'
   , 'Grant'
   , 'DGRANT'
   , '650.507.9844'
   , TO_DATE('13-01-2000', 'dd-mm-yyyy')
   , 'SH_CLERK'
   , 2600
   , NULL
   , 124
   , 50
   );
INSERT INTO emp_tbl VALUES 
   ( 200
   , 'Jennifer'
   , 'Whalen'
   , 'JWHALEN'
   , '515.123.4444'
   , TO_DATE('17-09-1987', 'dd-mm-yyyy')
   , 'AD_ASST'
   , 4400
   , NULL
   , 101
   , 10
   );
INSERT INTO emp_tbl VALUES 
   ( 201
   , 'Michael'
   , 'Hartstein'
   , 'MHARTSTE'
   , '515.123.5555'
   , TO_DATE('17-02-1996', 'dd-mm-yyyy')
   , 'MK_MAN'
   , 13000
   , NULL
   , 100
   , 20
   );
INSERT INTO emp_tbl VALUES 
   ( 202
   , 'Pat'
   , 'Fay'
   , 'PFAY'
   , '603.123.6666'
   , TO_DATE('17-08-1997', 'dd-mm-yyyy')
   , 'MK_REP'
   , 6000
   , NULL
   , 201
   , 20
   );
INSERT INTO emp_tbl VALUES 
   ( 203
   , 'Susan'
   , 'Mavris'
   , 'SMAVRIS'
   , '515.123.7777'
   , TO_DATE('07-01-1994', 'dd-mm-yyyy')
   , 'HR_REP'
   , 6500
   , NULL
   , 101
   , 40
   );
INSERT INTO emp_tbl VALUES 
   ( 204
   , 'Hermann'
   , 'Baer'
   , 'HBAER'
   , '515.123.8888'
   , TO_DATE('07-01-1994', 'dd-mm-yyyy')
   , 'PR_REP'
   , 10000
   , NULL
   , 101
   , 70
   );
INSERT INTO emp_tbl VALUES 
   ( 205
   , 'Shelley'
   , 'Higgins'
   , 'SHIGGINS'
   , '515.123.8080'
   , TO_DATE('07-01-1994', 'dd-mm-yyyy')
   , 'AC_MGR'
   , 12000
   , NULL
   , 101
   , 110
   );
INSERT INTO emp_tbl VALUES 
   ( 206
   , 'William'
   , 'Gietz'
   , 'WGIETZ'
   , '515.123.8181'
   , TO_DATE('07-01-1994', 'dd-mm-yyyy')
   , 'AC_ACCOUNT'
   , 8300
   , NULL
   , 205
   , 110
   );

COMMIT;

   
REM --------------------------------------------------------------------
REM 직급변화 테이블(job_history_tbl)에 데이터 입력
REM --------------------------------------------------------------------
       
INSERT INTO job_history_tbl
         VALUES (102
   , TO_DATE('13-01-1993', 'dd-mm-yyyy')
   , TO_DATE('24-07-1998', 'dd-mm-yyyy')
   , 'IT_PROG'
   , 60);
INSERT INTO job_history_tbl
         VALUES (101
   , TO_DATE('21-09-1989', 'dd-mm-yyyy')
   , TO_DATE('27-10-1993', 'dd-mm-yyyy')
   , 'AC_ACCOUNT'
   , 110);
INSERT INTO job_history_tbl
         VALUES (101
   , TO_DATE('28-10-1993', 'dd-mm-yyyy')
   , TO_DATE('15-03-1997', 'dd-mm-yyyy')
   , 'AC_MGR'
   , 110);
INSERT INTO job_history_tbl
         VALUES (201
   , TO_DATE('17-02-1996', 'dd-mm-yyyy')
   , TO_DATE('19-12-1999', 'dd-mm-yyyy')
   , 'MK_REP'
   , 20);
INSERT INTO job_history_tbl
         VALUES (114
   , TO_DATE('24-03-1998', 'dd-mm-yyyy')
   , TO_DATE('31-12-1999', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 50
   );
INSERT INTO job_history_tbl
         VALUES (122
   , TO_DATE('01-01-1999', 'dd-mm-yyyy')
   , TO_DATE('31-12-1999', 'dd-mm-yyyy')
   , 'ST_CLERK'
   , 50
   );
INSERT INTO job_history_tbl
         VALUES (200
   , TO_DATE('17-09-1987', 'dd-mm-yyyy')
   , TO_DATE('17-01-1993', 'dd-mm-yyyy')
   , 'AD_ASST'
   , 90
   );
INSERT INTO job_history_tbl
         VALUES (176
   , TO_DATE('24-03-1998', 'dd-mm-yyyy')
   , TO_DATE('31-12-1998', 'dd-mm-yyyy')
   , 'SA_REP'
   , 80
   );
INSERT INTO job_history_tbl
         VALUES (176
   , TO_DATE('01-01-1999', 'dd-mm-yyyy')
   , TO_DATE('31-12-1999', 'dd-mm-yyyy')
   , 'SA_MAN'
   , 80
   );
INSERT INTO job_history_tbl
         VALUES (200
   , TO_DATE('01-07-1994', 'dd-mm-yyyy')
   , TO_DATE('31-12-1998', 'dd-mm-yyyy')
   , 'AC_ACCOUNT'
   , 90
   );

COMMIT;


REM ====================================================================
REM 객체 생성
REM ====================================================================

REM --------------------------------------------------------------------
REM Table name:	region_tbl
REM	Comments: 	지역코드 테이블 객체 생성
REM Keys:		PK(region_id)
REM --------------------------------------------------------------------

CREATE UNIQUE INDEX reg_id_pk
         ON region_tbl (region_id);
         
ALTER TABLE region_tbl ADD 
( 
	CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
);
         
COMMIT;
   

REM --------------------------------------------------------------------
REM Table name:	nation_tbl
REM	Comments: 	국가코드 테이블 객체 생성
REM Keys:		PK(nation_id), FK(region_id)
REM --------------------------------------------------------------------
       
ALTER TABLE nation_tbl ADD 
( 
	CONSTRAINT nation_reg_fk
   		FOREIGN KEY (region_id)
   			REFERENCES region_tbl(region_id) 
);

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	location_tbl
REM	Comments: 	위치주소 테이블 객체 생성
REM Remarks:	PK(location_id), FK(nation_id)
REM --------------------------------------------------------------------
       
CREATE UNIQUE INDEX loc_id_pk
	ON location_tbl (location_id) ;
         
ALTER TABLE location_tbl ADD
( 
	CONSTRAINT loc_id_pk PRIMARY KEY (location_id)
	, CONSTRAINT loc_c_id_fk FOREIGN KEY (nation_id)
   		REFERENCES nation_tbl (nation_id)
);

CREATE INDEX loc_city_ix 			ON location_tbl (city);
CREATE INDEX loc_state_province_ix  ON location_tbl (state_province);
CREATE INDEX loc_nation_ix 			ON location_tbl (nation_id);

CREATE SEQUENCE location_seq
	START WITH 3300
   	INCREMENT BY 100
   	MAXVALUE 9900
   	NOCACHE
   	NOCYCLE
;

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	dept_tbl
REM	Comments: 	부서 테이블 객체 생성
REM Remarks:	PK(dept_id), FK(location_id, emp_id)
REM --------------------------------------------------------------------
       
CREATE UNIQUE INDEX dept_id_pk
         ON dept_tbl (dept_id);
         
ALTER TABLE dept_tbl ADD 
( 
	CONSTRAINT dept_id_pk PRIMARY KEY (dept_id)
	, CONSTRAINT dept_loc_fk FOREIGN KEY (location_id)
		REFERENCES location_tbl (location_id)
);

CREATE INDEX dept_location_ix 	ON dept_tbl (location_id);

CREATE SEQUENCE dept_seq
	START WITH 340
   	INCREMENT BY 10
   	MAXVALUE 9990
   	NOCACHE
   	NOCYCLE
;

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	job_tbl
REM	Comments: 	직급 테이블 객체 생성
REM Remarks:	PK(job_id)
REM --------------------------------------------------------------------

CREATE UNIQUE INDEX job_id_pk 
		ON job_tbl (job_id);
		
ALTER TABLE job_tbl ADD 
( 
	CONSTRAINT job_id_pk PRIMARY KEY(job_id)
);

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	emp_tbl
REM	Comments: 	사원 테이블 객체 생성
REM	Columns:	사원코드, 성명1, 성명2, 이메일, 전화, 입사일, 직급코드, 급여액...
REM Remarks:	PK(emp_id), FK(dept_id, job_id, manager_id) 
REM --------------------------------------------------------------------

CREATE UNIQUE INDEX emp_emp_id_pk
	ON emp_tbl (emp_id) ;
       
ALTER TABLE emp_tbl ADD
( 
	CONSTRAINT emp_emp_id_pk PRIMARY KEY (emp_id)
   	, CONSTRAINT emp_dept_fk FOREIGN KEY (dept_id) REFERENCES dept_tbl (dept_id)
   	, CONSTRAINT emp_job_fk  FOREIGN KEY (job_id)  REFERENCES job_tbl (job_id)
   	, CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES emp_tbl
);

ALTER TABLE dept_tbl ADD 
( 
	CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES emp_tbl (emp_id)
);

CREATE INDEX emp_dept_ix 		ON emp_tbl (dept_id);
CREATE INDEX emp_job_ix 		ON emp_tbl (job_id);
CREATE INDEX emp_manager_ix 	ON emp_tbl (manager_id);
CREATE INDEX emp_name_ix 		ON emp_tbl (last_name, first_name);
       
CREATE SEQUENCE emp_seq
	START WITH 207
   	INCREMENT BY 1
   	NOCACHE
   	NOCYCLE
;

COMMIT;


REM --------------------------------------------------------------------
REM Table name:	job_history_tbl
REM	Comments: 	직급변화 테이블 객체 생성
REM Remarks:	PK(emp_id + start_date), FK(emp_id, job_id, dept_id) 
REM --------------------------------------------------------------------

CREATE UNIQUE INDEX jhist_emp_id_st_date_pk 
	ON job_history_tbl (emp_id, start_date);

CREATE INDEX jhist_job_ix 	ON job_history_tbl (job_id);
CREATE INDEX jhist_emp_ix 	ON job_history_tbl (emp_id);
CREATE INDEX jhist_dept_ix 	ON job_history_tbl (dept_id);
	
ALTER TABLE job_history_tbl ADD 
( 
	CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (emp_id, start_date)
	, CONSTRAINT jhist_emp_fk FOREIGN KEY (emp_id)
   		REFERENCES emp_tbl
   	, CONSTRAINT jhist_job_fk FOREIGN KEY (job_id)
		REFERENCES job_tbl   	
   	, CONSTRAINT jhist_dept_fk FOREIGN KEY (dept_id)
   		REFERENCES dept_tbl
);

COMMIT;


REM ====================================================================
REM View 생성
REM ====================================================================

REM --------------------------------------------------------------------
REM View name:	emp_details_viw
REM	Comments: 	사원 상세정보 뷰
REM	Columns:	사원코드, 직급코드, 부서장코드, 부서코드, 위치코드, 국가코드...
REM Remarks:	조인 테이블(emp_tbl, dept_tbl, job_tbl, location_tbl, nation_tbl, region_tbl)
REM --------------------------------------------------------------------
       
CREATE OR REPLACE VIEW emp_details_viw
(
	emp_id, job_id, manager_id, dept_id, location_id, nation_id
	, first_name, last_name, salary, commission_pct, dept_name
	, job_title, city, state_province, nation_name, region_name
)
AS SELECT
	A.emp_id, A.job_id, A.manager_id, A.dept_id, B.location_id, D.nation_id
	, A.first_name, A.last_name, A.salary, A.commission_pct, B.dept_name
	, C.job_title, D.city, D.state_province, E.nation_name, F.region_name
	
	FROM
		emp_tbl A
		, dept_tbl B
		, job_tbl C
		, location_tbl D
		, nation_tbl E
		, region_tbl F
   	WHERE 
   		A.dept_id = B.dept_id
		AND B.location_id = D.location_id		
		AND D.nation_id = E.nation_id
		AND E.region_id = F.region_id
		AND C.job_id = A.job_id 
		
	WITH READ ONLY
;
 
COMMIT;


REM enable integrity constraint to DEPARTMENTS
ALTER TABLE dept_tbl 
   ENABLE CONSTRAINT dept_mgr_fk;
   
COMMIT;


REM ====================================================================
REM Procedure, Trigger 생성
REM ====================================================================

REM --------------------------------------------------------------------
REM Procedure:	prc_secure_dml
REM	Comments: 	주중 업무시간 검사
REM --------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prc_secure_dml
IS
BEGIN
   	IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
   		OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
   			RAISE_APPLICATION_ERROR (-20205, '주중의 업무시간에만 데이터을 변경할 수 있습니다.');
	END IF;
END prc_secure_dml;
/

REM --------------------------------------------------------------------
REM Trigger:	trg_secure_emp
REM	Comments: 	사원테이블(emp_tbl) 변경시 prc_secure_dml 호출
REM --------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_secure_emp
	BEFORE INSERT OR UPDATE OR DELETE ON emp_tbl
BEGIN
   	prc_secure_dml;
END trg_secure_emp;
/

ALTER TRIGGER trg_secure_emp DISABLE;


REM --------------------------------------------------------------------
REM Procedure:	prc_add_job_history
REM	Comments: 	직급변화 테이블에 데이터 저장
REM --------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE prc_add_job_history
(
	p_emp_id 		job_history_tbl.emp_id%type
	, p_start_date 	job_history_tbl.start_date%type
   	, p_end_date 	job_history_tbl.end_date%type
   	, p_job_id 		job_history_tbl.job_id%type
   	, p_dept_id 	job_history_tbl.dept_id%type 
)
IS
BEGIN
	INSERT INTO job_history_tbl (emp_id, start_date, end_date, job_id, dept_id)
   				VALUES (p_emp_id, p_start_date, p_end_date, p_job_id, p_dept_id);
END prc_add_job_history;
/

REM --------------------------------------------------------------------
REM Trigger:	trg_update_job_history
REM	Comments: 	사원테이블(emp_tbl)에서 job_id, dept_id 변경시 prc_add_job_history 호출
REM --------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_update_job_history
	AFTER UPDATE OF job_id, dept_id ON emp_tbl
   	FOR EACH ROW
BEGIN
	prc_add_job_history(:old.emp_id, :old.hire_date, sysdate, :old.job_id, :old.dept_id);
END trg_update_job_history;
/
  
COMMIT;

 