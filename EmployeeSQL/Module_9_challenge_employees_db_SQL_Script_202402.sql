﻿-- Table Schema - for employees_db - Module 9 Challenge - Ryan MacFarlane

-- employees table - main table
CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" char(5)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "sex" char(1)   NOT NULL,
    "hire_date" date   NOT NULL,
-- primary key
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

-- dept_emp table
CREATE TABLE dept_emp (
    emp_no int NOT NULL,
    dept_no char(4) NOT NULL,
    CONSTRAINT pk_dept_emp PRIMARY KEY (emp_no, dept_no)
);

-- titles table
CREATE TABLE "titles" (
    "title_id" char(5)   NOT NULL,
    "title" varchar(50)   NOT NULL,
-- primary key
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

-- salaries table
CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
-- primary key
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

-- dept_manager table
CREATE TABLE "dept_manager" (
    "dept_no" char(4)   NOT NULL,
    "emp_no" int   NOT NULL,
-- primary key
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

-- departments table
CREATE TABLE "departments" (
    "dept_no" char(4)   NOT NULL,
    "dept_name" varchar(50)   NOT NULL,
-- primary key
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

-- employees foreign key - emp_title_id - traces to title table - title_id column
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

-- dept_emp foreign key - emp_no - traces to employees table - emp_no column
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- dept_emp foreign key - dept_no - traces to employees table - dept_no column
ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- salaries foreign key - emp_no - traces to employees table - emp_no column
ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- dept_manager foreign key - dept_no - traces to departments table - dept_no column
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-- dept_manager foreign key - emp_no - traces to employees table - emp_no column
ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-- files were imported manually to each table at this point :

-- verify data imported correctly :

SELECT * FROM employees

SELECT * FROM departments

SELECT * FROM dept_emp

SELECT * FROM dept_manager

SELECT * FROM titles

SELECT * FROM salaries

-- data looks good - 

-- Data Analysis queries :

-- Question 1: List the employee number, last name, firs tname, sex, and salary of each employee:
SELECT a.emp_no, a.last_name, a.first_name, a.sex, b.salary
FROM employees AS a
INNER JOIN salaries AS b ON b.emp_no = a.emp_no

-- Question 2: List the first name, last name, and hire date for the employees who were hired in 1986:
SELECT first_name, last_name, hire_date 
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986

-- Question 3: List the manager of each department along with their department number, department name
-- employee number, last name and first name:
SELECT a.emp_no, b.first_name, b.last_name, c.dept_name
FROM dept_manager AS a
INNER JOIN employees AS b ON b.emp_no = a.emp_no
INNER JOIN departments AS c ON c.dept_no = a.dept_no
ORDER BY a.emp_no

-- Question 4: List the department number for each employee along with that employees's employee number, 
-- last name, first name, and department name:

SELECT a.dept_no, a.emp_no, b.first_name, b.last_name, c.dept_name
FROM dept_emp AS a
INNER JOIN employees AS b ON b.emp_no = a.emp_no
INNER JOIN departments AS c ON c.dept_no = a.dept_no
ORDER BY a.emp_no

-- Question 5: List first name, last name, and sex of each employee whose first name is Hercules and
-- whose last name begins with the letter B:

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

-- Question 6: List each employee in the Sales department, including their employee number, last name, and
-- first name:

SELECT a.emp_no, a.first_name, a.last_name
FROM employees AS a
INNER JOIN dept_emp AS b ON b.emp_no = a.emp_no
WHERE b.dept_no = 'd007'

-- Question 7: List each employee in the Sales and Development departments, including their employee number,
-- last name, first name, and department name:

SELECT a.emp_no, a.first_name, a.last_name, c.dept_name
FROM employees AS a
INNER JOIN dept_emp AS b ON b.emp_no = a.emp_no
INNER JOIN departments AS c ON c.dept_no = b.dept_no
WHERE b.dept_no IN ('d005', 'd007')

-- Question 8: List the frequency counts, in descending order, of all the employee last names (that is,
-- how many employees share each last name)

SELECT last_name, COUNT(last_name) AS Total 
FROM employees
GROUP BY last_name
ORDER BY Total DESC

