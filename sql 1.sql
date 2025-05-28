create database rcdu_colleges;
use rcdu_colleges;
CREATE TABLE STUDENT (
    RollNo CHAR(6) PRIMARY KEY,
    StudentName VARCHAR(20) NOT NULL,
    Course VARCHAR(10) NOT NULL,
    DOB DATE NOT NULL
);
CREATE TABLE SOCIETY (
    SocID CHAR(6) PRIMARY KEY,
    SocName VARCHAR(20) NOT NULL,
    MentorName VARCHAR(15) NOT NULL,
    TotalSeats  INT NOT NULL
);
CREATE TABLE ENROLLMENT (
    RollNo CHAR(6),
    SID CHAR(6),
    DateOfEnrollment DATE NOT NULL,
    EnrollmentFees ENUM('yes', 'no') DEFAULT 'no',
    PRIMARY KEY (RollNo, SID),
    FOREIGN KEY (RollNo) REFERENCES STUDENT(RollNo),
    FOREIGN KEY (SID) REFERENCES SOCIETY(SocID)
);
INSERT INTO STUDENT (RollNo, StudentName, Course, DOB) VALUES
('X001', 'Avantika', 'b tech', '2001-05-15'),
('X002', 'Bavesh', 'chemistry', '2000-08-20'),
('X003', 'Chavvi', 'maths', '2002-01-10'),
('Z001', 'Dev', 'b tech', '2001-12-30'),
('Z002', 'Esha', 'chemistry', '2000-11-25'),
('X004', 'Anna', 'biology', '2003-03-05'),
('Z003', 'Fatima', 'b tech', '2001-07-22'),
('X005', 'Garima', 'chemistry', '2002-09-15'),
('X006', 'Harsh', 'maths', '2000-04-18');
INSERT INTO SOCIETY (SocID, SocName, MentorName, TotalSeats) VALUES
('S001', 'NSS', 'Dr. Gupta', 30),
('S002', 'Debating', 'Mr. Sharma', 20),
('S003', 'Dance', 'Ms. Verma', 25),
('S004', 'Sashakt', 'Mr. Singh', 15),
('S005', 'Tech Club', 'Dr. Rao', 40);
INSERT INTO ENROLLMENT (RollNo, SID, DateOfEnrollment, EnrollmentFees) VALUES
('X001', 'S001', '2023-01-10', 'yes'),
('X002', 'S001', '2023-01-12', 'no'),
('X003', 'S002', '2023-01-15', 'yes'),
('Z001', 'S003', '2023-01-20', 'no'),
('Z002', 'S001', '2023-01-22', 'yes'),
('X004', 'S002', '2023-01-25', 'no'),
('Z003', 'S004', '2023-01-30', 'yes'),
('X005', 'S001', '2023-02-01', 'yes'),
('X006', 'S005', '2023-02-05', 'no'),
('X001', 'S002', '2023-02-10', 'yes');
SELECT DISTINCT S.StudentName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo;
SELECT DISTINCT SocName
FROM SOCIETY;
SELECT StudentName
FROM STUDENT
WHERE StudentName LIKE 'A%';
SELECT *
FROM STUDENT
WHERE Course IN ('b tech', 'chemistry');
SELECT StudentName
FROM STUDENT
WHERE RollNo LIKE 'X%9' OR RollNo LIKE 'Z%9';
SELECT *
FROM SOCIETY
WHERE TotalSeats > ?;
UPDATE SOCIETY
SET MentorName = 'New Mentor Name'  
WHERE SocID = 'SpecificSocID';
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
HAVING COUNT(E.RollNo) > 5;
SELECT S.StudentName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo
WHERE E.SID = 'NSS'
ORDER BY S.DOB DESC
LIMIT 1;
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
ORDER BY COUNT(E.RollNo) DESC
LIMIT 1;
SELECT S.SocName
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
ORDER BY COUNT(E.RollNo) ASC
LIMIT 2;
SELECT StudentName
FROM STUDENT
WHERE RollNo NOT IN (SELECT RollNo FROM ENROLLMENT);
SELECT S.StudentName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo
GROUP BY S.StudentName
HAVING COUNT(E.SID) >= 2;
SELECT S.SocName
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName
HAVING COUNT(E.RollNo) = (
    SELECT MAX(EnrollmentCount)
    FROM (
        SELECT COUNT(E.RollNo) AS EnrollmentCount
        FROM SOCIETY S
        JOIN ENROLLMENT E ON S.SocID = E.SID
        GROUP BY S.SocName
    ) AS Subquery
);
SELECT DISTINCT S.StudentName, Soc.SocName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo
JOIN SOCIETY Soc ON E.SID = Soc.SocID;
SELECT DISTINCT S.StudentName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo
JOIN SOCIETY Soc ON E.SID = Soc.SocID
WHERE Soc.SocName IN ('Debating', 'Dance', 'Sashakt');
SELECT SocName
FROM SOCIETY
WHERE MentorName LIKE '%Gupta%';
SELECT S.SocName, S.TotalSeats
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName, S.TotalSeats
HAVING COUNT(E.RollNo) = 0.1 * S.TotalSeats;
SELECT S.SocName, (S.TotalSeats - COUNT(E.RollNo)) AS VacantSeats
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName, S.TotalSeats;
SET SQL_SAFE_UPDATES = 0;
UPDATE SOCIETY
SET TotalSeats = TotalSeats * 1.10;
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE ENROLLMENT
ADD COLUMN EnrollmentFeesPaid ENUM('yes', 'no') DEFAULT 'no';
UPDATE ENROLLMENT
SET DateOfEnrollment = CASE 
    WHEN SID = 's1' THEN '2018-01-15'
    WHEN SID = 's2' THEN CURDATE()
    WHEN SID = 's3' THEN '2018-01-02'
END
WHERE SID IN ('s1', 's2', 's3');
CREATE VIEW SocietyEnrollmentCount AS
SELECT S.SocName, COUNT(E.RollNo) AS TotalEnrolled
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocName;
SELECT S.StudentName
FROM STUDENT S
WHERE NOT EXISTS (
    SELECT SocID
    FROM SOCIETY
) OR NOT EXISTS (
    SELECT E.SID
    FROM ENROLLMENT E
    WHERE E.RollNo = S.RollNo
);
SELECT COUNT(*) AS SocietyCount
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocID
HAVING COUNT(E.RollNo) > 5;
ALTER TABLE STUDENT
ADD COLUMN MobileNumber VARCHAR(15) DEFAULT '9999999999';
SELECT COUNT(*) AS TotalStudents
FROM STUDENT
WHERE YEAR(CURDATE()) - YEAR(DOB) > 20;
SELECT S.StudentName
FROM STUDENT S
JOIN ENROLLMENT E ON S.RollNo = E.RollNo
WHERE YEAR(S.DOB) = 2001;
SELECT COUNT(*) AS SocietyCount
FROM SOCIETY S
JOIN ENROLLMENT E ON S.SocID = E.SID
WHERE S.SocName LIKE 'S%t'
GROUP BY S.SocID
HAVING COUNT(E.RollNo) >= 5;
SELECT S.SocName, S.MentorName, S.TotalSeats AS TotalCapacity, COUNT(E.RollNo) AS TotalEnrolled,
       (S.TotalSeats - COUNT(E.RollNo)) AS UnfilledSeats
FROM SOCIETY S
LEFT JOIN ENROLLMENT E ON S.SocID = E.SID
GROUP BY S.SocID, S.SocName, S.MentorName, S.TotalSeats;
