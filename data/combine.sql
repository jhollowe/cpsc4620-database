-- This file can be run via  $ sqlite3; .read combine.sql

-- NOTE: SQLite doesn't allow named constraints, so names were removed and foreign key checks are turned off/on

-- This allows disables foreign key checks until self-referential keys are in place
PRAGMA foreign_keys=off;

CREATE TABLE EMPLOYEE(
	Fname     VARCHAR(15) NOT NULL,
	Minit     CHAR,
	Lname     VARCHAR(15) NOT NULL,
	Ssn       CHAR(9)     NOT NULL,
	Bdate     DATE,
	Address   VARCHAR(40),
	Salary    Decimal(10, 2),
	Super_ssn CHAR(9),
	Dno       INT         NOT NULL,

	PRIMARY KEY (Ssn),
	FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn),
	FOREIGN KEY (Dno)       REFERENCES DEPARTMENT(Dnumber)
	);


CREATE TABLE DEPARTMENT(
	Dname          VARCHAR(15) NOT NULL,
	Dnumber        INT         NOT NULL,
	Mgr_ssn        CHAR(9)     NOT NULL DEFAULT 888665555,
	Mgr_start_date DATE,

	PRIMARY KEY (Dnumber),
	UNIQUE      (Dname),
	FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn) ON UPDATE CASCADE
	);


CREATE TABLE DEPT_LOCATIONS(
	Dnumber   INT         NOT NULL,
	Dlocation VARCHAR(15) NOT NULL,

	PRIMARY KEY (Dnumber, Dlocation),
	FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber) ON DELETE CASCADE ON UPDATE CASCADE
	);


CREATE TABLE PROJECT(
	Pname     VARCHAR(15) NOT NULL,
	Pnumber   INT         NOT NULL,
	Plocation VARCHAR(15),
	Dnum      INT         NOT NULL,

	PRIMARY KEY (Pnumber),
	UNIQUE      (Pname),
	FOREIGN KEY (Dnum) REFERENCES DEPARTMENT (Dnumber) 	ON UPDATE CASCADE
	);


CREATE TABLE WORKS_ON(
	Essn  CHAR(9)       NOT NULL,
	Pno   INT           NOT NULL,
	Hours DECIMAL(3, 1) NOT NULL,

	PRIMARY KEY (Essn, Pno),
	FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
	FOREIGN KEY (Pno)  REFERENCES PROJECT(Pnumber)
	);


CREATE TABLE DEPENDENT(
	Essn           CHAR(9)     NOT NULL,
	Dependent_name VARCHAR(15) NOT NULL,
	Bdate          DATE,
	Relationship   VARCHAR(8),

	PRIMARY KEY (Essn, Dependent_name),
	FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) ON UPDATE CASCADE ON DELETE CASCADE
	);


.mode csv
-- Importing into an existing table requires no header in CSV
.import DEPARTMENT_no_header.csv DEPARTMENT
.import DEPENDENT_no_header.csv DEPENDENT
.import DEPT_LOCATIONS_no_header.csv DEPT_LOCATIONS
.import EMPLOYEE_no_header.csv EMPLOYEE
.import PROJECT_no_header.csv PROJECT
.import WORKS_ON_no_header.csv WORKS_ON

-- Turn foreign key checks back on
PRAGMA foreign_keys=on;

.save COMPANY.db
