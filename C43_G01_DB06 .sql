----------------------------------------------part 01 (fucntions)----------------------------------------------
use ITI

--1.Create a scalar function that takes a date and returns the Month name of that date.
GO
create or alter function getMonthName(@date date)
returns varchar(max)
with encryption
BEGIN
	declare @monthName varchar(max)
		select @monthName= format(@date,'MMMM')
		RETURN @monthName

END
GO
select dbo.getMonthName('07/06/2025')

--2.Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
GO
CREATE OR ALTER FUNCTION getValuedBetween(@num1 INT, @num2 INT)
RETURNS @t TABLE (
    value INT
)
with encryption
AS
BEGIN
    DECLARE @i INT;

    
    IF (@num1 < @num2)
    BEGIN
        SET @i = @num1 + 1;
        WHILE (@i < @num2)
        BEGIN
            INSERT INTO @t VALUES(@i);
            SET @i = @i + 1;
        END
    END

    ELSE IF (@num2 < @num1)
    BEGIN
        SET @i = @num2 + 1;
        WHILE (@i < @num1)
        BEGIN
            INSERT INTO @t VALUES(@i);
            SET @i = @i + 1;
        END
    END

    ELSE
    BEGIN
        INSERT INTO @t VALUES (0);
    END

    RETURN;
END
GO
select * from dbo.getValuedBetween(1,5)

--3.Create a table-valued function that takes Student No and returns Department Name with Student full name.
--inlined tabled valued
GO
create or alter function getDeptName(@stdNumber INT)
RETURNS table
WITH ENCRYPTION
AS
RETURN(
	select CONCAT(s.St_Fname,' ' ,s.St_Lname) as 'Full Name' , D.Dept_Name
	from Student S inner join Department D
	ON S.Dept_Id=D.Dept_Id
	where S.St_Id=@stdNumber

)
GO
select * from dbo.getDeptName(1)

--4.Create a scalar function that takes Student ID and returns a message to user. 
 --.	If first name and Last name are null, then display 'First name & last name are null.'
 --.	If First name is null, then display 'first name is null'
 --.	If Last name is null, then display 'last name is null.'
 --.	Else display 'First name & last name are not null'
 GO
 create or alter function getMessageByStdId(@stdId int)
 RETURNS varchar(max)
 BEGIN

	declare @msg varchar(max)
	declare @ValidationFName varchar(max)
	declare @ValidationLName varchar(max)

	SELECT @ValidationFName=s.St_Fname,@ValidationLName=s.St_Lname
	FROM Student s
	where s.St_Id=@stdId

	if(@ValidationFName is null AND @ValidationLName IS NULL )
	BEGIN
		set @msg ='First name & last name are null.'
	END

	ELSE IF(@ValidationFName is null AND @ValidationLName IS NOT NULL)
	BEGIN
		set @msg ='first name is null'
	END

	ELSE IF(@ValidationFName is NOT null AND @ValidationLName IS NULL)
	BEGIN
		set @msg ='last name is null'
	END

	ELSE 
	BEGIN
		set @msg ='First name & last name are not null'
	END
	
	RETURN @msg
	

 END
 GO
 SELECT dbo.getMessageByStdId(1)

--5.Create a function that takes an integer which represents the format of the Manager 
--hiring date and displays department name, Manager Name and hiring date with this format. 

--tabled valued function (inlined)
GO
create or alter function getDeptData(@format int)
RETURNS TABLE
AS
RETURN(
	select d.Dept_Name,d.Dept_Manager,CONVERT(varchar(max),d.Manager_hiredate,@format) as 'Manager HireDate Formmated'
	from Department d
)
GO
select * from dbo.getDeptData(102)

--6. Create multi-statement table-valued function that takes a string. 
--. If string='first name' returns student first name 
--. If string='last name' returns student last name  
--. If string='full name' returns Full Name from student table
GO
create or alter function getStudentName(@option varchar(max))
RETURNS @t table(
	name varchar(max)
	)
AS
BEGIN
	if(@option='first name')
		insert into @t
		select s.St_Fname as 'fName'
		from Student s
	else if(@option='last name') 
		insert into @t
		select s.St_Lname as 'lName'
		from Student s
	else if(@option ='full name') 
		insert into @t
		select CONCAT(s.St_Fname,' ' ,s.St_Lname) as 'Full Name'
		from Student s

RETURN
END
GO

select * from dbo.getStudentName('full name')

--Note: Use “ISNULL” function 
--7. Create function that takes project number and display all employees in this project 
--(Use MyCompany DB) 
--inlined tabled valued
use MyCompany
GO
create or alter function getEmployeesByProjectNum(@pno int)
RETURNS TABLE
AS
RETURN(
	select E.Fname,E.Lname,W.Pno
	from Employee E inner join Works_for W
	on E.SSN=W.ESSn
	where w.Pno=@pno

)

GO
select * from dbo.getEmployeesByProjectNum(100)

----------------------------------------------part 02 (Views)----------------------------------------------
use ITI
--1. Create a view that displays the student's full name, course name if the student has a 
--grade more than 50.
GO
create or alter view getStudentData
With encryption
AS
select CONCAT(s.St_Fname,' ' ,s.St_Lname) as 'Full name' ,course.Crs_Name
from Student s INNER JOIN Stud_Course
on s.St_Id=Stud_Course.St_Id
INNER JOIN Course
on Course.Crs_Id=Stud_Course.Crs_Id
where Stud_Course.Grade>50
GO


--2. Create an Encrypted view that displays instructor names and the topics they teach.
GO
create or alter view getInstructorsWithTopicsView
with encryption
AS
	select distinct i.Ins_Name ,Topic.Top_Id,Topic.Top_Name
	from Instructor I inner join Ins_Course 
	on I.Ins_Id=Ins_Course.Ins_Id
	inner join course
	on Ins_Course.Crs_Id=Course.Crs_Id
	inner join Topic
	on Course.Top_Id=Topic.Top_Id
GO


--3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ 
--Department “use Schema binding” and describe what is the meaning of Schema Binding 
GO
Create schema binding
GO
create or alter view binding.getInsNameAndDeptName
with encryption
AS
	select i.Ins_Name ,d.Dept_Name
	from Instructor i inner join Department d
	on i.Dept_Id=d.Dept_Id
	where d.Dept_Name in ('sd' ,'java') with check option
GO


--4.  Create a view “V1” that displays student data for students who live in Alex or Cairo.  
--Note: Prevent the users to run the following query  
--Update V1 set st_address=’tanta’ 
--Where st_address=’alex’;
GO
create or alter view V1
with encryption
AS
	select *
	from Student
	where Student.St_Address in ('alex','cairo') with check option

GO


--5. Create a view that will display the project name and the number of employees working 
--on it. (Use Company DB) 

use MyCompany
GO
create or alter view getProjectNameAndNumOfEmployees
with encryption
AS
	select p.Pname,COUNT(E.Fname) as 'Number of employees'
	from Employee E inner join Works_for W
	on E.SSN=W.ESSn
	inner join Project P
	on w.Pno=P.Pnumber
	group by p.Pname

GO

--use IKEA_Company_DB:
--1. Create a view named “v_clerk” that will display employee Number, project Number, the 
--date of hiring of all the jobs of the type 'Clerk'.

use IKEA_Company
GO
create or alter view v_clerk
with encryption
AS
	select w.EmpNo ,w.ProjectNo,w.Enter_Date
	from Works_on W
	where w.Job='clerk'

GO

--2.Create view named  “v_without_budget” that will display all the projects data without budget 
GO
create or alter view v_without_budget
with encryption
AS
	select p.ProjectNo,p.ProjectName
	from HR.Project P

GO

GO
SELECT * FROM v_without_budget
GO

--3. Create view named  “v_count “ that will display the project name and the Number of jobs in it 
GO
create or alter view v_count
with encryption
AS
	select p.ProjectName,COUNT(W.Job) as [Numebr of jobs]
	from HR.Project P inner join Works_on W
	on p.ProjectNo=W.ProjectNo
	group by p.ProjectName
GO

--4.  Create a view named” v_project_p2” that will display the emp# s for the project# ‘p2’. 
--(use the previously created view  “v_clerk”) 

GO
create or alter view v_project_p2
with encryption
AS
	select v.EmpNo ,v.ProjectNo
	from dbo.v_clerk V
	where v.ProjectNo=2 with check option

GO

--5. modify the view named “v_without_budget” to display all DATA in project p1 and p2.

GO 
 alter view v_without_budget
 with encryption
AS
	select p.*
	from HR.Project P
GO

--6. Delete the views  “v_ clerk” and “v_count”
drop view v_clerk
drop view v_count

--7. Create view that will display the emp# and emp last name who works on deptNumber is 
--‘d2’
GO
create or alter view getEmpNumInDept2
with encryption
AS
	select E.EmpNo,E.EmpLname
	from HR.Employee E inner join Department D
	on E.DeptNo = D.DeptNo
	where D.DeptNo=2 with check option

GO

--8. Display the employee  lastname that contains letter “J” (Use the previous view created in 
--Q#7)

GO 
create or alter view GetLNameContainsJ
with encryption
AS
	select getEmpNumInDept2.EmpLname 
	from dbo.getEmpNumInDept2 
	where EmpLname like '%j%' with check option
GO

--9. Create view named “v_dept” that will display the department# and department name
GO
create or alter view getDeptData
WITH ENCRYPTION
AS
	select D.DeptNo,D.DeptName
	from Department D
GO

--10. using the previous view try enter new department data where dept# is ’d4’ and dept 
--name is ‘Development’        => one table 
insert into dbo.getDeptData
values(4,'Development')

--11. Create view name “v_2006_check” that will display employee Number, the project 
--Number where he works and the date of joining the project which must be from the first 
--of January and the last of December 2006.this view will be used to insert data so make 
--sure that the coming new data must match the condition    => with check option

GO
CREATE OR ALTER VIEW v_2006_check
WITH ENCRYPTION
AS
	select e.EmpNo ,W.ProjectNo ,W.Enter_Date
	from HR.Employee E inner join Works_on W
	on E.EmpNo=W.EmpNo
	where W.Enter_Date between '2006-01-01' and '2006-12-31' with check option

GO

----------------------------------------------part 03 ----------------------------------------------
use RouteCompany
create table Department(
	deptNo varchar(2) primary key not null,
	DeptName varchar(max),
	Location varchar(max)

)

insert into Department
values
('d1','Research','NY'),
('d2','Accounting','DS'),
('D3','Marketing','KW')

create table Employees(
EmpN int primary key ,
[Emp Fname] varchar(max) not null ,
[Emp Lname] varchar(max) not null ,
DeptN varchar(2) foreign key references department(deptNo),
Salary int unique 

)

insert into Employees 
values
(25348,'Mathwe','Smith','d3',2500),
(10102,'Ann' ,'Jones','d3',3000),
(18316,'John','Barrymore','d1','2400'),
(29346,'James','James','d2',2800),
(9031,'Lisa','Bertoni','d2',4000),
(2581,'Elisa','Hansel','d2',3600),
(28559,'Sybl','Moser','d1',2900)

ALTER TABLE works_on
ADD CONSTRAINT DF_works_on_enter_date
DEFAULT GETDATE() FOR enter_date;



alter table works_on
add constraint FK_EMPNO
foreign key (EmpN) references Employees(EmpN)

------------------------------------------------------






 --1-Add new employee with EmpNo =11111 In the works_on table [what 
--will happen] 
 insert into Works_On
 values(11111,'p1','BackEnd developer','2025-07-07')
--The insertion fails because 11111 is a foreign key that does not exist in the Employees table.


--2-Change the employee number 10102  to 11111  in the works on table 
--[what will happen] 
update works_on
set EmpN=11111
where EmpN=10102
--The update fails because 11111 is a foreign key that does not exist in the Employees table.


--3-Modify the employee number 10102 in the employee table to 22222. 
--[what will happen] 
update Employees
set EmpN=22222
where EmpN=10102
--the update fails cuz the EmpN is a primary key referenced as a FK in Works_On table

--4-Delete the employee with id 10102 

delete from Employees
where EmpN = 10102  

--1-Add  TelephoneNumber column to the employee 
--table[programmatically] 
alter table Employees
add telephoneNumber int

--2-drop this column[programmatically] 
alter table Employees
drop column telephoneNumber


--2. Create the following schema and transfer the following tables to it  
-- . Company Schema  
-- . Department table  
-- . Project table  
-- . Human Resource Schema 
-- .   Employee table
go
create schema Company
go
alter schema Company
transfer [dbo].[Department]

alter schema Company
transfer [dbo].[Projects]

go
create schema [Human Resource]
go

alter schema [Human Resource]
transfer [dbo].[Employees]



--3. Increase the budget of the project where the manager number is 10102 by 10%. 

UPDATE [Company].[Projects]
SET Budget = Budget * 1.1
WHERE ProjectNo IN (
    SELECT ProjectNo
    FROM [dbo].[Works_On]
    WHERE EmpN = 10102
);

--4.Change the name of the department for which the employee named James works.The 
--new department name is Sales.

update [Company].[Department]
set deptName ='Sales'
where deptNo in (
				select [Human Resource].[Employees].DeptN
				from  	[Human Resource].[Employees]
				where [Human Resource].[Employees].[Emp Fname] ='James'
						)
--5. Change the enter date for the projects for those employees who work in project p1 
--and belong to department ‘Sales’. The new date is 12.12.2007. 

update Works_On
set Enter_Date='12.12.2007'
where ProjectNo='p1' AND EmpN  IN(
							select EmpN
							from [Human Resource].[Employees] inner join [Company].[Department]
							on deptNo=DeptN
							where DeptName='sales')


--6. Delete the information in the works_on table for all employees who work for the 
--department located in KW. 

delete from Works_On
where EmpN in (
select EmpN
from [Human Resource].[Employees] inner join [Company].[Department]
ON DeptN = deptNo
where Location='KW'
)
