
--Part 1 

--creating the data base

-- Create student table
CREATE TABLE student (
    sid varchar(100) PRIMARY KEY,  -- Primary key identifier for student table
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

--faced a special character issue with student sid value = 1

--code to remove special character in the begining and end of the values.

-- only after then the issue with copy values in major table and enroll table will be resolved and it is referenced from the 
-- the student table

UPDATE student  -- command to change the value of the particular key
SET sid = '1'  -- to set the right value
WHERE REGEXP_REPLACE(sid, E'[^\\x20-\\x7E]', '', 'g') = '1';

--trouble shooting code to check if the special characters are removed

select * from student where sid = '1';


--copying data to major table without headers
COPY major(dname, sid)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\major.csv' --path of the file where it is stored
WITH (FORMAT csv, HEADER false, DELIMITER ',');

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

--part 2 queries


--1 Print the names of professors who work in departments that have fewer than 50 PhD students right

--here we need to use profeesor table and department table and using join on the department name attribute
-- to check the condition where number phds is less than 50

select prof.pname
from prof
join dept on prof.dname = dept.dname
where dept.numphds < 50;

--2 Print the names of the students with the lowest GPA right

-- here we need to use nested queries to find the lowest gpa among the students in the strudent table

select sname 
from student
where gpa = (select min(gpa) from Student);

--3 For each Computer Sciences class, print the class number, section number, and the average GPA of students enrolled in the class section right

-- here we use normal join to join the course, section,enroll and student table with there primary keys.
--In order to calculate the average GPA for each section of Computer Sciences courses, they are used to match each part to its enrolled students. 
--By concentrating on certain department courses and their student performances.

select course.cno AS class_number, section.sectno AS section_number, AVG(student.gpa) AS average_gpa
from course
join section on course.cno = section.cno and course.dname = section.dname
join enroll on section.dname = enroll.dname and section.cno = enroll.cno AND section.sectno = enroll.sectno
join student on enroll.sid = student.sid
where course.dname = 'Computer Sciences'
group by course.cno, section.sectno;



-- 4. Print the names and section numbers of all sections with more than six students enrolled in them

--The class sections (by department name and section number) that have more than six enrolled students are listed in this SQL query. 
--In order to enable the COUNT operation to ascertain the number of students in each part, 
--it employs a JOIN to match enrollment records to their corresponding sections and a GROUP BY to arrange these records by section.

select section.dname , section.sectno 
from section
join enroll ON section.dname = enroll.dname and section.sectno = enroll.sectno
GROUP BY section.dname, section.sectno
having COUNT(enroll.sid) > 6;


-- 5. List the department names and the number of classes offered in each department.

--  It does this by joining the dept and course tables based on the department name, 
--then seperates the results by department name to ensure each department is listed once, 
--and counts usinf count() the number of courses associated with each department.

Select dept.dname , COUNT(course.cno) 
From dept
Join course ON dept.dname = course.dname
GROUP BY dept.dname;

-- 6. Print the names of departments that have one or more majors who are under 18 years old

-- the query is executed by joimning dept major and student to filre ou the age constraint and gives department names
select dept.dname 
from dept 
join major on dept.dname = major.dname 
join student on student.sid = major.sid
where student.age < 18; 

--7 Print the names and majors of students who are taking one of the College Geometry courses

-- The query use is to list student names and their major names
-- for those whose majors are linked with departments that has 'College Geometry 1' or 'College Geometry 2'. 
Select student.sname , major.dname 
from student 
left join major on student.sid = major.sid
left join course on major.dname =  course.dname
where course.cname in('College Geometry 1', 'College Geometry 2')
group by student.sname, major.dname;

-- 8 For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department
--Subquery to check if the department offers either of the specific courses

Select dept.dname, dept.numphds
From dept
Where NOT EXISTS ( --not exist condition evaluates to false for that particular department, because the subquery found a matching row, thus excluding the department from the final results.
 select 1 --The use of select 1 in a subquery like this is simply to return a non-null value if any rows are found that meet the subquery's conditions 
 from course 
 where course.dname = dept.dname 
 and course.cname IN ('College Geometry 1', 'College Geometry 2')
)
GROUP BY dept.dname, dept.numphds;

--9 Print the names of students who are taking either a Computer Sciences course or a Mathematics course

--the left join joins the student table with the major table based on the student ID (sid) to associate each student with their declared major, 
--then filters the results to include only those students whose major (dname) is in the specified categories: 'Mathematics' or 'Computer Sciences'.

select student.sname from student
left join major on student.sid = major.sid
where major.dname in ('Mathematics','Computer Sciences');

--10 Print the age difference between the oldest and the youngest Computer Sciences major right 

select max(student.age) - min(student.age) as agedifference
from student
join major on major.sid = student.sid  --Joins the student and major tables on the student ID
where major.dname = 'Computer Sciences'; -- Filters to include only Computer Sciences majors

--11. For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors

select dept.dname , avg(student.gpa)
from dept
join major on dept.dname = major.dname --Joins the department table with the major table to correlate departments with their students' majors
join student on major.sid = student.sid --Further joins with the student table to access the GPA of students in those majors
where student.gpa < 1.0 --Filters the data to only include students with a GPA below 1.0
group by dept.dname; --to show department wise




--12 Print the ids, names and GPAs of the students who are currently taking all the Civil Engineering courses print code with comments
-- Retrieves the identifiers, names, and GPAs of students who are enrolled in every Civil Engineering course available.
select student.sid, student.sname, student.gpa
from student
where NOT EXISTS (
-- Subquery to identify any Civil Engineering courses not currently enrolled by the student.
Select course.cno
From course
Where course.dname = 'Civil Engineering'  -- Focuses on courses within the Civil Engineering department.
and not EXISTS (
-- Subquery to check if the student is enrolled in each of the identified Civil Engineering courses.
Select enroll.sid
From enroll
Join section ON enroll.cno = section.cno AND enroll.sectno = section.sectno AND enroll.dname = section.dname
Where section.dname = 'Civil Engineering'  -- Ensures the enrollment is for a Civil Engineering course.
AND enroll.sid = student.sid  -- Matches the enrollment to the specific student.
)
)
GROUP BY student.sid;  -- Groups results by student to ensure unique entries for each.

-----------------------------------------------------End------------------------------------------------------------------------------------