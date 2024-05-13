
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