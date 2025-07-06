# SQL Server Project – ITI, Company, and IKEA_Company_DB

## 📁 Part 01 – Functions (Using ITI DB)

### 1. Scalar Function – Get Month Name
- Input: Date
- Output: Month Name of that date

### 2. Multi-Statement Table-Valued Function – Range Between Two Numbers
- Input: 2 Integers
- Output: All values between them

### 3. Table-Valued Function – Student Full Info
- Input: Student No
- Output: Full Name + Department Name

### 4. Scalar Function – Student ID Message
- Input: Student ID
- Logic:
  - If First + Last Name = NULL → "First name & last name are null"
  - If First Name = NULL → "first name is null"
  - If Last Name = NULL → "last name is null"
  - Else → "First name & last name are not null"

### 5. Function – Formatted Hiring Date
- Input: Integer format code
- Output: Department Name + Manager Name + Hire Date in format

### 6. Multi-Statement Table-Valued Function – Student Name Options
- Input: String
- Output:
  - "first name" → Student First Name
  - "last name" → Student Last Name
  - "full name" → Student Full Name (use ISNULL)

### 7. Function (Using MyCompany DB)
- Input: Project Number
- Output: All employees in this project

---

## 📁 Part 02 – Views

### [ITI DB]
1. View – Student Full Name + Course Name where Grade > 50  
2. Encrypted View – Instructor Name + Topic Name  
3. View with Schema Binding – Instructor Name + Department for "Java"/"SD"  
4. View `V1` – Students from Alex/Cairo  
   - Prevent: `UPDATE V1 SET st_address='tanta' WHERE st_address='alex'`

### [Company DB]
5. View – Project Name + Number of Employees in each

---

### [IKEA_Company_DB]

1. View `v_clerk` – Emp#, Project#, Hire Date for all Clerks  
2. View `v_without_budget` – All project data (no budget column)  
3. View `v_count` – Project Name + Number of Jobs in it  
4. View `v_project_p2` – Emp# for project 'p2' (using `v_clerk`)  
5. Modify `v_without_budget` – Show data for `p1` + `p2`  
6. Delete Views: `v_clerk`, `v_count`  
7. View – Emp# + Last Name for deptNumber = 'd2'  
8. Filter Last Names with letter "J" using view from Q#7  
9. View `v_dept` – Dept# + Dept Name  
10. Insert into `v_dept` – Dept# = 'd4', Name = 'Development'  
11. View `v_2006_check` – Emp#, Project#, Enter_Date in 2006 only  
    - Allow only inserts that match this condition

---

## 📁 Part 03 – RouteCompany DB (Created by Wizard)

### 1. Tables (with constraints)
- Department: PK = DeptNo  
- Employee:
  - PK = EmpNo
  - FK = DeptNo
  - UNIQUE(Salary)
  - NOT NULL(Fname, Lname)
- Project:
  - PK = ProjectNo
  - NOT NULL(ProjectName)
  - NULL allowed in Budget
- Works_on:
  - Composite PK = (EmpNo, ProjectNo)
  - FK to Employee & Project
  - Job: NULL allowed
  - Enter_Date: NOT NULL + default = GETDATE()

#### 🔍 Testing Referential Integrity:
1. Insert EmpNo = 11111 in works_on → should fail if Emp doesn't exist
2. Change EmpNo = 10102 to 11111 in works_on → FK violation
3. Modify EmpNo = 10102 in employee to 22222 → FK conflict
4. Delete employee 10102 → FK conflict

---

### 2. Schemas
- Schema: `Company`
  - Tables: Department, Project
- Schema: `HumanResource`
  - Table: Employee

---

### 3–6. Business Logic Updates
3. Increase Budget for project where manager = 10102 by 10%
4. Change department name for employee James → "Sales"
5. Change Enter_Date to 12/12/2007 for employees in project p1 + Sales dept
6. Delete works_on records for employees in KW

---
