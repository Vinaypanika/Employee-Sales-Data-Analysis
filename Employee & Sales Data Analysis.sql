CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Salary INT NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    ManagerID INT NULL REFERENCES Employees(EmployeeID),
    HireDate DATE NOT NULL
);


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID) ON DELETE CASCADE,
    SaleAmount DECIMAL(10,2) NOT NULL CHECK (SaleAmount > 0),
    SaleDate DATE NOT NULL
);




INSERT INTO Departments (DepartmentName) VALUES
('HR'), ('IT'), ('Sales'), ('Finance');


INSERT INTO Employees (FirstName, LastName, Salary, DepartmentID, ManagerID, HireDate) VALUES
('Vinay', 'Panika', 70000, 2, NULL, '2018-06-12'),
('Awadhesh', 'Yadav', 75000, 2, 1, '2019-07-19'),
('Nevendra', 'Rajput', 80000, 3, 1, '2020-08-05'),
('Himanshu', 'Sahu', 60000, 1, 2, '2021-09-10'),
('Piyush', 'Chaturvedi', 80000, 3, 3, '2022-03-25'),
('Rituraj', 'Pawar', 90000, 4, NULL, '2017-02-28'),
('Ashish', 'Singh', 72000, 2, 2, '2017-01-15'),
('Divyansh', 'Kumar', 65000, 3, 3, '2023-07-10'),
('Chetan', 'Singh', 75000, 3, 3, '2023-06-15');

INSERT INTO Sales (EmployeeID, SaleAmount, SaleDate) VALUES
(3, 1500.50, '2024-01-10'),
(3, 2500.75, '2024-02-12'),
(5, 1800.00, '2024-03-15'),
(2, 2200.30, '2024-03-20'),
(4, 2750.90, '2024-04-05');



--1.Retrieve all employee details.
select * from employees;

--2.List employees who earn more than ?75,000.
select * from employees 
where salary > 75000;

--3.Find the total number of employees in each department.
select d.Departmentname, count(e.employeeid) as Employee_count from employees as e
inner join departments as d on e.departmentid = d.departmentid
group by d.departmentname;

--4.Retrieve employees who were hired before 2020.
select * from employees
where hiredate <'2020-01-01';

--5.List employees along with their managers' names.
select e1.firstname as Employee_name, e2.firstName as Managername from employees as e1
left join employees as e2 on e1.managerid=e2.employeeid;

--6.Find the highest salary in the company.
select Employeeid,Firstname,Lastname,Salary from employees
where salary = (select max(salary) from employees);


--7.Find employees working in the Sales department.
select e.Employeeid,e.Firstname,e.Lastname,e.Salary,e.Managerid 
from employees as e
inner join departments as d on d.departmentid = e.departmentid
where d.departmentname = 'sales';

--8.Retrieve employees with the same salary (if any).
select Salary, count(*) as Employee_Count from employees
group by salary
having count(*)>1

--9.List the top 3 highest-paid employees.
select top 3 * from employees
order by salary desc;

--10.Find employees who haven't made any sales.
select e.* from employees as e
left join sales as s on e.employeeid = s.employeeid
where s.employeeid is null;

--11.Retrieve department-wise average salary.
select d.Departmentname, avg(e.salary) as Average_Salary from departments as d
inner join employees as e on d.departmentid = e.departmentid
group by d.Departmentname;


--12.Find employees earning more than their department's average salary.
select e.* from employees as e
inner join (
select departmentid,avg(salary) as dept_avg_salary from employees
group by departmentid) as t
on e.departmentid = t.departmentid
where e.salary > t.dept_avg_salary;

--13.Find the department with the highest total salary expenditure.
select top 1 d.Departmentname, sum(e.salary) as Salary_Expenditure
from departments as d
inner join employees as e on d.departmentid = e.departmentid
group by d.Departmentname
order by sum(e.salary) desc;

--14.Find employees hired in the last 3 years.
select * from employees
where HireDate >= Dateadd(year, -3,getdate());

--15.Retrieve employees whose name starts with 'V'.
select * from employees
where firstname like 'V%';


--16.Retrieve sales employees who have made more than ?2000 in sales.
select e.Firstname, e.Lastname, sum(s.saleamount) as Total_sales
from employees as e
inner join sales as s on e.employeeid = s.employeeid
group by e.Firstname, e.Lastname
having sum(s.saleamount)>2000;

--17.Retrieve employees not reporting to anyone (Top-Level Managers).
select * from employees
where managerid is null;

--18 Get the second highest salary.
select top 1 * from employees
where salary<(select max(salary) from employees)
order by salary desc;

--19.Find employees who made sales in both January & February 2024.
select distinct e.Employeeid, e.Firstname, e.Lastname from Employees as e
join sales as s1 on e.employeeid = s1.employeeid and month(s1.saledate) = 1
join sales as s2 on e.employeeid = s2.employeeid and month(s2.saledate) = 2;


--20.Find the department with the lowest average salary.
select top 1 d.Departmentname, avg(e.salary) as Average_salary from employees as e
inner join departments as d on d.departmentid = e.departmentid
group by d.Departmentname
order by avg(e.salary);

--21.Find the percentage of employees working in each department.
select d.Departmentname,
count(e.employeeid)*100.0/(select count(*) from employees) as percentage
from employees as e
inner join departments as d on e.departmentid = d.departmentid
group by d.Departmentname;

--22.Find the month with the highest total sales.
select top 1 format(saledate, 'yyyy-MM') as Salemonth, sum(saleamount) as TotalSales
from sales
group by format(saledate, 'yyyy-MM')
order by sum(saleamount) desc;

--23.Find employees who joined before their manager.
select e1.Firstname, e1.Lastname, e1.HireDate, e2.firstname as Manager, e2.HireDate as Manager_hire_date
from employees as e1
inner join employees e2 on e1.managerid = e2.employeeid
where e1.HireDate < e2.hiredate;

--24.Retrieve employees who never made a sale but belong to the Sales department.
select e.* from employees as e
inner join departments as d on e.departmentid = d.departmentid
left join sales as s on e.employeeid = s.employeeid
where d.departmentname = 'Sales' and s.employeeid is null;

--25.Rank employees based on salary within each department.
select Employeeid, Firstname,Lastname, Salary, Departmentid,
rank() over(partition by departmentid order by Salary desc) as Salary_ranking
from Employees;