-- Part 3 & 4: Transform ER Model into SQL Tables
-- Creating the Departments Table

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) UNIQUE NOT NULL
);

-- Creating the Faculty Table
CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_name VARCHAR(100) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE CASCADE
);

-- Creating the Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    faculty_id INT NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE CASCADE
);

-- Creating the Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Creating the Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    grade VARCHAR(2) DEFAULT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE(student_id, course_id) -- Prevent duplicate enrollments
);





-- Part 5: Insert Sample Data

-- Insert Departments
INSERT INTO Departments (dept_name) VALUES ('Computer Science'), ('Mathematics');

-- Insert Faculty Members
INSERT INTO Faculty (faculty_name, dept_id) VALUES ('Dr. Thesou', 1), ('Prof. Soulux', 2);

-- Insert Courses
INSERT INTO Courses (course_code, course_name, faculty_id, dept_id) 
VALUES ('CS101', 'Intro to Programming', 1, 1),
       ('MATH201', 'Calculus I', 2, 2);

-- Insert Students
INSERT INTO Students (first_name, last_name, date_of_birth, email)
VALUES ('Sok', 'Sochetra', '2001-06-15', 'sokso@example.com'),
       ('Sean', 'Soulong', '2000-09-22', 'seansou@example.com'),
       ('Yem', 'Davith', '1999-12-10', 'yemda@example.com'),
       ('Loem', 'Theankou', '2002-01-01', 'Kou@example.com');

-- Insert Enrollments
INSERT INTO Enrollments (student_id, course_id, enrollment_date, grade)
VALUES (1, 1, '2025-03-01', 'C'),
       (2, 1, '2025-03-01', 'B'),
       (3, 2, '2025-03-02', 'A');

-- Part 6: Querying the Database

-- Retrieve all students who enrolled in a specific course
SELECT s.student_id, s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101';

--  Find all faculty members in a particular department
SELECT faculty_id, faculty_name 
FROM Faculty 
WHERE dept_id = (SELECT dept_id FROM Departments WHERE dept_name = 'Computer Science');


--  List all courses a particular student is enrolled in
SELECT c.course_code, c.course_name 
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Students s ON e.student_id = s.student_id
WHERE s.email = 'sokso@example.com';


-- Retrieve students who have not enrolled in any course
SELECT s.student_id, s.first_name, s.last_name 
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


-- Find the average grade of students in a specific course
SELECT c.course_code, c.course_name, AVG(
    CASE 
        WHEN grade = 'A' THEN 4.0
        WHEN grade = 'B' THEN 3.0
        WHEN grade = 'C' THEN 2.0
        WHEN grade = 'D' THEN 1.0
        ELSE 0
    END
) AS average_gpa
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101'
GROUP BY c.course_code, c.course_name;

