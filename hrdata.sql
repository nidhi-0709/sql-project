CREATE TABLE employee_data (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome NUMERIC(12,2),
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(5),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
SELECT * FROM EMPLOYEE_DATA;

SELECT COUNT(*) AS TotalEmployees
FROM employee_data;

SELECT COUNT(*) AS EmployeesLeft
FROM employee_data
WHERE Attrition = 'No';

SELECT COUNT(*) AS EmployeesLeft
FROM employee_data
WHERE Attrition = 'Yes';

SELECT DISTINCT Department, JobRole
FROM employee_data;


--Attrition rate by department
SELECT Department,
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY Department
ORDER BY AttritionRate DESC;


--) Average salary by department & role
SELECT Department, JobRole, ROUND(AVG(MonthlyIncome),2) AS AvgSalary
FROM employee_data
GROUP BY Department, JobRole
ORDER BY AvgSalary DESC;

-- Max years
SELECT  Department, YearsAtCompany
FROM employee_data
ORDER BY YearsAtCompany DESC
LIMIT 5;

-- Min years
SELECT  Department, YearsAtCompany
FROM employee_data
ORDER BY YearsAtCompany ASC
LIMIT 5;

--Factors correlated with attrition – Overtime
SELECT OverTime, 
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY OverTime;

--Job Satisfaction vs Attrition
SELECT JobSatisfaction, 
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


--Age vs Attrition
SELECT Age,
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY Age
ORDER BY Age;


--Multi-factor Analysis – Department + Overtime
SELECT Department, OverTime,
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY Department, OverTime
ORDER BY AttritionRate DESC;

--Using Window Functions – Rank employees by salary within department
SELECT EmployeeID, Department, JobRole, MonthlyIncome,
       RANK() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) AS SalaryRank
FROM employee_data;

--Average Years at Company by Department & Attrition
SELECT Department, Attrition, ROUND(AVG(YearsAtCompany),2) AS AvgYears
FROM employee_data
GROUP BY Department, Attrition
ORDER BY Department;

--Correlation-like Insight – Overtime + Job Satisfaction + Attrition
SELECT OverTime, JobSatisfaction,
       COUNT(*) AS TotalEmployees,
       SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS AttritionRate
FROM employee_data
GROUP BY OverTime, JobSatisfaction
ORDER BY AttritionRate DESC;
