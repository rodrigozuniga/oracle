--if exists does not exist in Oracle
drop table hr.job_git;
--many different objects can be created
create table hr.job_git 
(name varchar2(35)
 , id int not null 
 , sal int
 , constraint pk_id primary key(id)
);
desc hr.job_git;
--insert can only be used with table so no need to specify
insert into hr.job_git(name,id,sal) values ('Rodrigo', 1,100);
insert into hr.job_git(name,id,sal) values ('Tim',2,200);

--insert can have multiple values using select from dual
insert into hr.job_git (name,id,sal)
(
 select 'Alvaro',3,300 from dual
 union all
 select 'Jose',4,400 from dual
);

select * from hr.job_git;

create table dates2 (dt1 date, dt2 date);
insert into dates2 values(to_date('2016-08-01','YYYY-MM-DD'),to_date('2016-08-01','YYYY-MM-DD'));
insert into dates2 values(to_date('9/1/2017','MM/DD/YYYY'),to_date('9/1/2017','MM/DD/YYYY'));


--Many objects can be altered
alter table hr.job_git add (tax int);

--Only tables can be updated so no need to specify
update hr.job_git
set tax= case when sal<=200 then 0.1*sal else 0.2*sal end; 

--truncate table cannot be rolled back/cluster can also be truncated
truncate table hr.job_git;

--Delete can be rolled back
delete from hr.job_git where sal>=400;

alter table hr.job_git drop column TAX;

--VIEWS:
create view HR.my_view1 as
select a.first_name, a.last_name, b.department_name, c.first_name as manager_first_name, c.last_name as manager_last_name
from HR.EMPLOYEES a left join HR.DEPARTMENTS b on a.DEPARTMENT_ID=b.DEPARTMENT_ID
 left join HR.EMPLOYEES c on a.MANAGER_ID=c.MANAGER_ID;

drop view HR.MY_VIEW2;
create view HR.my_view2 as
select first_name, last_name, department_name
from HR.EMPLOYEES a natural join HR.DEPARTMENTS b;

create materialized view HR.my_view3 as
select first_name, last_name, department_name
from HR.EMPLOYEES a left join HR.DEPARTMENTS b on a.DEPARTMENT_ID=b.DEPARTMENT_ID;

--MINUS OPERATION:
select first_name, last_name, department_name from HR.my_view1
minus
select first_name, last_name, department_name from HR.my_view2;

--Create index
create index deptid_empid on HR.EMPLOYEES(DEPARTMENT_ID,EMPLOYEE_ID);

--LAG/LEAD
select first_name,lag(first_name) over (order by first_name) from HR.EMPLOYEES;
select first_name,lag(first_name) over () from HR.EMPLOYEES;


select first_name,lag(first_name,2) over (order by first_name) from HR.EMPLOYEES;

select first_name,lag(first_name,3) over (order by first_name) from HR.EMPLOYEES;

select first_name,lead(first_name,3) over (order by first_name) from HR.EMPLOYEES;

--ANALYTICAL FUNCTIONS:
select DEPARTMENT_ID, first_name,lag(first_name) over (partition by DEPARTMENT_ID order by first_name) 
 from HR.EMPLOYEES;

--Rank function used order by to define variable to be ranked
select DEPARTMENT_ID, first_name,rank() over (partition by DEPARTMENT_ID order by salary) 
 from HR.EMPLOYEES;

select DEPARTMENT_ID, first_name, salary, sum(salary) over (partition by DEPARTMENT_ID order by salary desc) 
 from HR.EMPLOYEES;

--LEFT JOIN: on and where clause differences
select a.first_name,b.first_name as left_name
from HR.EMPLOYEES a left join HR.EMPLOYEES b on a.employee_id=b.EMPLOYEE_ID and substr(b.first_name,1,1) not in ('A')
where 1=1
order by first_name
;

select a.first_name,b.first_name as left_name
from HR.EMPLOYEES a left join HR.EMPLOYEES b on a.employee_id=b.EMPLOYEE_ID 
where substr(b.first_name,1,1) not in ('A')
order by first_name
;

--Explain query plan
explain plan for 
select DEPARTMENT_ID, first_name, salary, 
       sum(salary) over (partition by DEPARTMENT_ID order by salary desc) 
from HR.EMPLOYEES;

--Dates
select TO_CHAR(LAST_DAY(hire_date),'YYYY-MM-DD') as hire_date, count(*)
from hr.employees
where hire_date <TO_DATE('2002-12-31','YYYY-MM-DD')
group by LAST_DAY(hire_date)
order by 1;

select TRUNC(hire_date,'month') as hire_date, count(*)
from hr.employees
where hire_date <TO_DATE('2002-12-31','YYYY-MM-DD')
group by TRUNC(hire_date,'month')
order by 1;

select trunc(to_date('2016-10-31','YYYY-MM-DD'),'MONTH') from dual;
select trunc(to_date('2016-10-31','YYYY-MM-DD'),'YEAR') from dual;
select TRUNC (TO_DATE('27-OCT-92'),'YEAR') from dual;
select round(to_date('2016-10-31','YYYY-MM-DD'),'MONTH') from dual;
select extract(day from to_date('2016-10-31','YYYY-MM-DD')) from dual;
select extract(month from to_date('2016-10-31','YYYY-MM-DD')) from dual;
select extract(year from to_date('2016-10-31','YYYY-MM-DD')) from dual;

select dbms_random.value(1,9) from dual;

select DBMS_RANDOM.NORMAL
from dual;

create table hr.sequence1b as
select rownum as nums from dual connect by rownum<=10;

create sequence sq2 start with 6 increment by 1;

drop table hr.sequence2b;
create table hr.sequence2b as
select sq2.nextval as nums from dual connect by rownum<=10;

select a.nums, b.nums
from hr.sequence1b a full join hr.sequence2b b on a.nums=b.nums order by 1;

--GROUP BY, CUBE BY, ROLLUP
select nvl(department_id,999),nvl(job_id,'ALL'),count(*)
from hr.employees
group by rollup(department_id, job_id)
order by department_id, job_id;

select /*json*/ * from hr.employees;

--REGULAR EXPRESSION
select * from hr.employees 
where REGEXP_LIKE(lower(first_name),'^[n|j|t].*a$');                                          
  --REGEXP_LIKE(first_name,'[A-Z][^a]*u*a$');                                          
select first_name, REGEXP_REPLACE(first_name,'[A-Z]','X')  from hr.employees;
select first_name, REGEXP_REPLACE(first_name,'[a-z]$','X') from hr.employees;
select first_name, REGEXP_REPLACE(first_name,'[a-z]$','X') from hr.employees;

select first_name, REGEXP_SUBSTR(first_name,'[A-Z]..') from hr.employees;
select first_name, REGEXP_SUBSTR(first_name,'^[A-Z][^aeiou]*') from hr.employees;

select first_name, REGEXP_INSTR(first_name,'[aeiou]') from hr.employees;
select first_name, REGEXP_INSTR(first_name,'a{2}|l{2}|n{2}') as re from hr.employees;

--QUERY FROM QUERY:
select * from
(
select a.*, lag(a.department_id) over(partition by a.employee_id order by a.start_date) as prev_department_id
from hr.job_history a
order by employee_id,start_date
) emp
where prev_department_id=80
;


