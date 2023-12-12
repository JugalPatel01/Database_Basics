-- create schema
CREATE SCHEMA LEARNDB;
USE LEARNDB;
show databases;
show schemas;
show tables;

-- create table
/*
	In this schema we make two tables emp and address.and in address we use foreign key as primary key of emp table
*/
CREATE TABLE emp ( id INT ,  name varchar(20), salary numeric(10), dept varchar(20));
desc emp;
select * from emp;

-- insert values into table
insert into emp values(1,"jugal",2200000,"IT"); 
insert into emp values(2,"xyz",440000,"HR");

# modify table using alter command

-- add column 
alter table emp add (address varchar(30));

-- remove column
alter table emp drop column address;
insert into emp values(4,"raju",23000,"IT");

-- modify datatype of column
alter table emp modify id varchar(10);
alter table emp modify id int;

-- modify datatype length
alter table emp modify name varchar(30);

-- rename column of table
alter table emp rename column id to roll_no;

-- rename table name
alter table emp rename to xyz;
desc xyz;
alter table xyz rename to emp;

-- add and remove constraints 
alter table emp add primary key (roll_no);
alter table emp drop primary key;
alter table emp modify name varchar(20) not null;

-- update command
update emp set salary = salary * 2;
update emp set salary = (salary / 1.2) where roll_no = 1;

-- Delete,drop,truncate
delete from emp where name = "raju";
create table student (name int);
insert into student values(3);
select * from student;
truncate student;
drop table student;

# constraints
alter table emp add primary key (roll_no);
alter table emp drop primary key;
alter table emp modify name varchar(20) unique not null;
alter table emp add check(roll_no>0);
alter table emp add constraint chk_roll check (roll_no>0 and salary > 0);
alter table emp drop constraint chk_roll;
desc emp;

-- aggregate functions

select max(salary) from emp;
select min(salary) from emp;
select sum(salary) from emp;
select avg(salary) from emp;
select first(salary) from emp;
select last(salary) from emp;
select count(roll_no) from emp;
select * , GROUP_CONCAT(salary) as "salary" from emp group by salary;
select * from emp;

# use of arithmetic operator in select 

select (avg(salary)/100) as avgdiv100 from emp;
select (avg(salary)*100) as avgmul100 from emp;

# range queries

select * from emp where salary between 40000 and 400000;
select * from emp where name between 'abc' and 'ravi';
select * from emp where dept not between 'IT' and 'MRKT';
/* 
	we can use between opeartor between dates 
    eg. between '2020-09-01' and '2022-09-01' 
    eg. between #10/01/2020# and #31/01/2020#
*/

# subqueries or nested query

-- name of highest salary gainer
select name from emp where salary =(select  max(salary) from emp);

-- name of the person who get second highest salary
select name from emp where salary in (select max(salary) from emp where salary <> (select max(salary) from emp));

-- department name with no of employee
select dept, count(*) from emp group by dept;

-- dept names where no. of employees are less then 2 and emp names from that dept
select name,dept from emp where dept in (select dept from emp group by dept having count(*)<2);
select dept from emp group by dept order by count(dept);

-- highest salary department wise and name of that emp 
select dept,name , salary from emp group by dept having max(salary) order by salary desc;

-- example of in or not in 
select * from address where city in ("delhi","pune","vadodara");
select * from address where city not in ("delhi");

-- name of emps who are working in city
select * from emp join address where emp.roll_no=address.eid and roll_no in (select distinct(eid) from address);

-- type of join 
select * from emp join address where emp.roll_no=address.eid and roll_no in (select distinct(eid) from address);
select * from emp left join address on emp.roll_no=address.eid;			-- LEFT JOIN OR LEFT [OUTER] JOIN
select * from emp right join address on emp.roll_no = address.eid;
select * from emp inner join address on emp.roll_no = address.eid;
select * from emp cross join address;
select * from emp e1 , emp e2 where e1.name = e2.name;

-- full join 
use learndb;
select * from emp left join address on emp.roll_no = address.eid union select * from emp right join address on emp.roll_no= address.eid;

-- exist / not exist
select * from emp where exists (select eid from address where emp.roll_no = address.eid);

-- nth highest salary using sql
select * from emp e1 where 2 = (Select(count(distinct salary)) from emp e2 where e2.salary>e1.salary);

-- row_number(), rank(), dense_rank() and ntile(n)
select *,row_number() over(order by dept desc) RowNumber from emp;
select *,rank() over(order by dept desc) RankNumber from emp;
select *,dense_rank() over(order by dept desc) DenseRankNumber from emp;
select *, ntile(2) over (order by salary desc) ntileNumber from emp;

select *,row_number() over(order by dept desc) RowNumber ,rank() over(order by dept desc) RankNumber ,dense_rank() over(order by dept desc) DenseRankNumber, ntile(2) over (order by dept desc) ntileNumber from emp;

-- query for finding highest nth salary from each department
select * from ( select *,rank() over(partition by dept order by salary desc) as r_number from emp) as dummytable where r_number<=1;

/*
	group by gives one row per group in result, meanwhile partition by gives aggregated columns with each record in the specificied table.
*/


/*
	row_number function assigns the sequential rank number to each unique row.
    rank function assigns the rank number to each row in a partition. it skips the number for similar values. 
    dense_rank function assigns the rank number to each row in partition. it does not skip the number for similar values.
    ntile function divides the number of rows as per specified partition and assigns unique value in the partition.
*/

-- for removing duplicate tuples
delete from emp where roll_no in (select roll_no from(select roll_no,row_number() over (partition by roll_no,name,dept) as rownum from emp)as sub where rownum>1);
-- or 
delete e1,e2 from emp e1 inner join emp e2 on e1.name = e2.name and e1.salary = e2.salary where e1.roll_no<e2.roll_no;

-- view
create view v1 as 
select concat("username_",name),salary,"employee_of_company" as people_in_company from emp;		-- create view

create or replace view v1 as 
select roll_no,name from emp;		-- update view

select * from v1;		-- using view 
drop view v1;		-- dropping view

/*
-- trigger
create table trigger_test (message varchar(20));
# run on mysql command line
delimiter $$		-- run this for changing delimiter to $$ from ;

create trigger my_trigger before insert on emp for each row 
	begin 
		insert into my_trigger values(new.name);
	end$$ 		-- run this for creating trigger 
delimiter ; 		-- run this for changing delimiter to ; again from $$

select * from emp;
insert into emp values(6,"kallu",25343,"MRKT");
delete from emp where roll_no=6;
select * from trigger_test;

*/

use learndb;
show tables;
select * from emp;
insert into emp values(7,"amc",233343,"MRKT");


-- indexing

-- show all indexes on table
SHOW INDEXES FROM emp IN learndb;

/* creating index to imporve search on database */
create index uid_first_name_idx on emp(name);

-- drop index
DROP INDEX uid_first_name_idx ON emp;

-- explain
EXPLAIN SELECT * FROM emp;

show schemas;
use learndb;
show tables;

drop table if exists movie;
CREATE TABLE movie ( Id INT AUTO_INCREMENT PRIMARY KEY,Movie_name varchar(20), Rating int, CHECK (Rating<11 and Rating>0));
ALTER TABLE movie auto_increment = 10;
INSERT INTO movie (Movie_name,Rating) VALUES ("FIRST_MOVIE",7);
INSERT INTO movie (Movie_name,Rating) VALUES ("SECOND_MOVIE",7);
SELECT * FROM movie;
TRUNCATE TABLE movie;

-- ROW_NUMBER FUNCTION 
SELECT * , ROW_NUMBER() OVER (PARTITION BY Movie_name,Rating) AS row_num FROM movie;

-- ONLY DUPLICATE ROWS
SELECT * FROM (SELECT Id,Movie_name,Rating,ROW_NUMBER() OVER (PARTITION BY Movie_name,Rating ORDER BY Movie_name,Rating) AS  row_num FROM movie) AS TEMP_TABLE where row_num > 1;
SELECT * , COUNT(Movie_name) FROM movie GROUP BY Movie_name HAVING COUNT(Movie_name)>1;

-- DELETE DUPLICATE ROWS
DELETE FROM movie WHERE Id IN (SELECT Id FROM (SELECT Id,ROW_NUMBER() OVER (PARTITION BY Movie_name,Rating) as row_num FROM movie) AS TEMP_TABLE WHERE row_num > 1);

-- delete duplicate row using join 
DELETE M1 FROM movie AS M1 INNER JOIN movie AS M2 ON M1.Movie_name = M2.Movie_name WHERE M1.Id>M2.Id;

-- cast function	(DATE , DATETIME, TIME , CHAR, UNSIGNED, SIGNED ,BINARY, DECIMAL)
SELECT CONCAT('CAST Function ',CAST(5 AS CHAR));
SELECT CAST(3-6 AS UNSIGNED);
SELECT CAST('3-6' AS SIGNED);
SELECT CAST("2022-4-30" AS DATE);

-- FLOW FUNCTION --> CASE,IF(),IFNULL(),NULLIF()
SELECT IF(200>350,'YES','NO');
SELECT IFNULL(NULL,5);
SELECT NULLIF(NULL,"HELLO");

SELECT CASE 1 
WHEN 1 THEN 'ONE' 
WHEN 2 THEN 'TWO'
 ELSE 'MORE' END;
 
 -- LIKE COMMAND
 SELECT * FROM emp;
 SELECT * FROM emp WHERE NAME LIKE 'r_ju';
 SELECT * FROM emp WHERE NAME LIKE 'r%';

-- select nth row using rownum / ROW_NUMBER() function
SET @row_number = 0;
select * from (select * ,(@row_number:=@row_number + 1) as rownumber from emp) as temp_table where rownumber = 5;
