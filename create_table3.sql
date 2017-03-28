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

--many objects can be altered
alter table hr.job_git add (tax int);

--only tables can be updated so no need to specify
update hr.job_git
set tax= case when sal<=200 then 0.1*sal else 0.2*sal end; 

--truncate table cannot be rolled back/cluster can also be truncated
truncate table hr.job_git;

--delete can be rolled back
delete from hr.job_git where sal>=400;

alter table hr.job_git drop column TAX;
