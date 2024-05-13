-- Create student table
CREATE TABLE student (
    sid varchar(100) PRIMARY KEY,
    sname VARCHAR(255) NOT NULL,
    sex CHAR(1),
    age INT,
    year VARCHAR(50),
    gpa DECIMAL(3, 2)
);

-- Create dept table
CREATE TABLE dept (
    dname VARCHAR(255) PRIMARY KEY,
    numphds INT NOT NULL
);

-- Create prof table
CREATE TABLE prof (
    pname VARCHAR(255) PRIMARY KEY,
    dname VARCHAR(255) NOT NULL,
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

-- Create course table
CREATE TABLE course (
    cno VARCHAR(50),
    cname VARCHAR(255) NOT NULL,
    dname VARCHAR(255) NOT NULL,
    PRIMARY KEY (cno, dname),
    FOREIGN KEY (dname) REFERENCES dept(dname)
);

-- Create major table
CREATE TABLE major (
    dname VARCHAR(255),
    sid varchar(100),
    PRIMARY KEY (dname, sid),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (sid) REFERENCES student(sid)
);

-- Create section table
CREATE TABLE section (
    dname VARCHAR(255),
    cno VARCHAR(50),
    sectno INT,
    pname VARCHAR(255),
    PRIMARY KEY (dname, cno, sectno),
    FOREIGN KEY (dname) REFERENCES dept(dname),
    FOREIGN KEY (cno, dname) REFERENCES course(cno, dname),
    FOREIGN KEY (pname) REFERENCES prof(pname)
);

-- Create enroll table
CREATE TABLE enroll (
    sid Varchar(100),
    grade numeric(3,2),
    dname VARCHAR(255),
    cno VARCHAR(50),
    sectno INT,
    PRIMARY KEY (sid, dname, cno, sectno),
    FOREIGN KEY (sid) REFERENCES student(sid),
    FOREIGN KEY (dname, cno, sectno) REFERENCES section(dname, cno, sectno)
);




/*COPY major(dname, sid)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\major.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');*/

/*COPY student(sid, sname,sex,age,year,gpa)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\student.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY dept(dname, numphds)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\dept.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY prof(pname, dname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\prof.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY course(cno,cname,dname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\course.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY major(dname, sid)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\major.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY section(dname, cno,sectno,pname)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\section.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/

/*COPY enroll(sid,grade,dname,cno,sectno)
FROM 'C:\Users\Rajesh PC\Desktop\UCDPA_Assignment\data\enroll.csv'
WITH (FORMAT csv, HEADER false, DELIMITER ',');*/
