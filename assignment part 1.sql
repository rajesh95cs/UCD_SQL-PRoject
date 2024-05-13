--Part 1 

--creating the data base

-- Create student table
CREATE TABLE student (
    sid varchar(100) PRIMARY KEY,  -- Primary key identifier fro student table
    sname VARCHAR(255) NOT NULL, -- student name
    sex CHAR(1),  --male or female 
    age INT, 
    year VARCHAR(50), -- academic year
    gpa DECIMAL(4, 2) 
);

-- Create dept table department information with number of phds 
CREATE TABLE dept (
    dname VARCHAR(255) PRIMARY KEY, -- primary key fro dept table department name
    numphds INT NOT NULL -- number of phd students
);

-- Create prof table
CREATE TABLE prof (
    pname VARCHAR(255) PRIMARY KEY, -- primary key identifier for prof table professor name
    dname VARCHAR(255) NOT NULL, --  department name
    FOREIGN KEY (dname) REFERENCES dept(dname) 
);

-- Create course table to store course information
CREATE TABLE course (
    cno VARCHAR(50), --course number 
    cname VARCHAR(255) NOT NULL, --  course name
    dname VARCHAR(255) NOT NULL, -- department name
    PRIMARY KEY (cno, dname), --  composite key as courses can have same number in different departments
    FOREIGN KEY (dname) REFERENCES dept(dname) -- making sure department name exists in the dept table
);

-- Create major table storing which major each student is part of 
CREATE TABLE major (
    dname VARCHAR(255), -- department name, from which reperesents the major
    sid varchar(100), -- student id which shows is part of student table
    PRIMARY KEY (dname, sid), -- composite key a student can have only one major in a department
    FOREIGN KEY (dname) REFERENCES dept(dname), --to show department exists in the dept table
    FOREIGN KEY (sid) REFERENCES student(sid) -- to show student is referenced in the student table
);

-- Create section table storing specific class information
CREATE TABLE section (
    dname VARCHAR(255), -- department name
    cno VARCHAR(50), -- course number
    sectno INT, -- section number
    pname VARCHAR(255), -- professor name
    PRIMARY KEY (dname, cno, sectno), -- composite key to find unique sections
    FOREIGN KEY (dname) REFERENCES dept(dname),-- Ensures department name exists in the dept table
    FOREIGN KEY (cno, dname) REFERENCES course(cno, dname), --Ensures course number exists in the course table
    FOREIGN KEY (pname) REFERENCES prof(pname) --Ensures professor name exists in the prof table
);

-- Create enroll table to store student enrollents in each sections
CREATE TABLE enroll (
    sid Varchar(100),-- student id
    grade numeric(4,2), 
    dname VARCHAR(255),-- department name
    cno VARCHAR(50), -- course number 
    sectno INT, -- section number
    PRIMARY KEY (sid, dname, cno, sectno), -- composite key to find unique enrollments
    FOREIGN KEY (sid) REFERENCES student(sid), -- student id refernces to student table 
    FOREIGN KEY (dname, cno, sectno) REFERENCES section(dname, cno, sectno) -- Section exist in the section table
);

----------------------------------------------------------------------------------------------------------------------------------------------------------------

--- copying data to the data base from the csv

--copying data to major table without headers
COPY major(dname, sid)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\major.csv' --path of the file where it is stored
WITH (FORMAT csv, HEADER false, DELIMITER ',');


--faced a special character issue with student sid value = 1

--code to remove special character in the begining and end of the values.

-- only after then the issue with copy values in major table and enroll table will be resolved and it is referenced from the 
-- the student table

UPDATE student  -- command to change the value of the particular key
SET sid = '1'  -- to set the right value
WHERE REGEXP_REPLACE(sid, E'[^\\x20-\\x7E]', '', 'g') = '1';

--trouble shooting code to check if the special characters are removed

select * from student where sid = '1';

--copying data to student table without headers
COPY student(sid, sname,sex,age,year,gpa)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\student.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');

----copying data to dept table without headers
COPY dept(dname, numphds)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\dept.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');

--copying data to prof table without headers
COPY prof(pname, dname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\prof.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');

--copying data to course table without headers
COPY course(cno,cname,dname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\course.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');

--copying data to section table without headers
COPY section(dname, cno,sectno,pname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\section.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');

--copying data to enroll table without headers
COPY enroll(sid,grade,dname,cno,sectno)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\enroll.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------