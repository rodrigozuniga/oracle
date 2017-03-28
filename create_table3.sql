create table job_git (id int, sal int);
insert into job_git values (1,100);
insert into job_git values (2,200);

insert into job_git 
(select 3,300 from dual
union all
select 4,400 from dual);
select * from job_git;