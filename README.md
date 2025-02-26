## Employee & Sales Data Analysis Using SQL Server

## SQL Queries for Analysis

## 1. Retrieve all employee details
```sql
SELECT * FROM Employees;
```

## 2. List employees who earn more than ₹75,000
```sql
SELECT * FROM Employees WHERE Salary > 75000;
```

## 3. Find the total number of employees in each department
```sql
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Employee_Count 
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
```

## 4. Retrieve employees who were hired before 2020
```sql
SELECT * FROM Employees WHERE HireDate < '2020-01-01';
```

## 5. List employees along with their managers' names
```sql
SELECT e1.FirstName AS Employee_Name, e2.FirstName AS Manager_Name 
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID;
```

## 6. Find the highest salary in the company
```sql
SELECT EmployeeID, FirstName, LastName, Salary 
FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees);
```

## 7. Find employees working in the Sales department
```sql
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary, e.ManagerID 
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = e.DepartmentID
WHERE d.DepartmentName = 'Sales';
```

## 8. Retrieve employees with the same salary (if any)
```sql
SELECT Salary, COUNT(*) AS Employee_Count 
FROM Employees
GROUP BY Salary
HAVING COUNT(*) > 1;
```

## 9. List the top 3 highest-paid employees
```sql
SELECT TOP 3 * FROM Employees ORDER BY Salary DESC;
```

## 10. Find employees who haven't made any sales
```sql
SELECT e.* FROM Employees e
LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
WHERE s.EmployeeID IS NULL;
```

## 11. Retrieve department-wise average salary
```sql
SELECT d.DepartmentName, AVG(e.Salary) AS Average_Salary 
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;
```

## 12. Find employees earning more than their department's average salary
```sql
SELECT e.* FROM Employees e
INNER JOIN (
    SELECT DepartmentID, AVG(Salary) AS Dept_Avg_Salary FROM Employees
    GROUP BY DepartmentID
) AS t ON e.DepartmentID = t.DepartmentID
WHERE e.Salary > t.Dept_Avg_Salary;
```

## 13. Find the department with the highest total salary expenditure
```sql
SELECT TOP 1 d.DepartmentName, SUM(e.Salary) AS Salary_Expenditure
FROM Departments d
INNER JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY SUM(e.Salary) DESC;
```

## 14. Find employees hired in the last 3 years
```sql
SELECT * FROM Employees 
WHERE HireDate >= DATEADD(YEAR, -3, GETDATE());
```

## 15. Retrieve employees whose name starts with 'V'
```sql
SELECT * FROM Employees WHERE FirstName LIKE 'V%';
```

## 16. Retrieve sales employees who have made more than ₹2000 in sales
```sql
SELECT e.FirstName, e.LastName, SUM(s.SaleAmount) AS Total_Sales
FROM Employees e
INNER JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.FirstName, e.LastName
HAVING SUM(s.SaleAmount) > 2000;
```

## 17. Retrieve employees not reporting to anyone (Top-Level Managers)
```sql
SELECT * FROM Employees WHERE ManagerID IS NULL;
```

## 18. Get the second highest salary
```sql
SELECT TOP 1 * FROM Employees
WHERE Salary < (SELECT MAX(Salary) FROM Employees)
ORDER BY Salary DESC;
```

## 19. Find employees who made sales in both January & February 2024
```sql
SELECT DISTINCT e.EmployeeID, e.FirstName, e.LastName 
FROM Employees e
JOIN Sales s1 ON e.EmployeeID = s1.EmployeeID AND MONTH(s1.SaleDate) = 1
JOIN Sales s2 ON e.EmployeeID = s2.EmployeeID AND MONTH(s2.SaleDate) = 2;
```

## 20. Find the department with the lowest average salary
```sql
SELECT TOP 1 d.DepartmentName, AVG(e.Salary) AS Average_Salary 
FROM Employees e
INNER JOIN Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AVG(e.Salary);
```

## 21. Find the percentage of employees working in each department
```sql
SELECT d.DepartmentName,
COUNT(e.EmployeeID) * 100.0 / (SELECT COUNT(*) FROM Employees) AS Percentage
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
```

## 22. Find the month with the highest total sales
```sql
SELECT TOP 1 FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
ORDER BY SUM(SaleAmount) DESC;
```

## 23. Find employees who joined before their manager
```sql
SELECT e1.FirstName, e1.LastName, e1.HireDate, e2.FirstName AS Manager, e2.HireDate AS Manager_Hire_Date
FROM Employees e1
INNER JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID
WHERE e1.HireDate < e2.HireDate;
```

## 24. Retrieve employees who never made a sale but belong to the Sales department
```sql
SELECT e.* FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
WHERE d.DepartmentName = 'Sales' AND s.EmployeeID IS NULL;
```

## 25. Rank employees based on salary within each department
```sql
SELECT EmployeeID, FirstName, LastName, Salary, DepartmentID,
RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS Salary_Ranking
FROM Employees;
```
