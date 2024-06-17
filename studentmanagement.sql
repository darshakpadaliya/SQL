CREATE DATABASE SchoolDB;
USE SchoolDB;

CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    EnrollmentDate DATE NOT NULL
);

CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(255) NOT NULL,
    CourseDescription TEXT,
    Credits INT NOT NULL
);

CREATE TABLE Enrollments (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
    GradeID INT AUTO_INCREMENT PRIMARY KEY,
    EnrollmentID INT,
    Grade CHAR(1) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F')),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

INSERT INTO Students (FirstName, LastName, DateOfBirth, Gender, Email, EnrollmentDate) VALUES
('Darshak', 'Padaliya', '2001-06-16', 'Male', 'Darshakpadaliya@gmail.com', '2019-09-01'),
('kishan', 'Padaliya', '1999-11-25', 'Male', 'kishanpadaliya@gmail.com', '2019-09-01'),
('sandip', 'padaliya', '2001-02-20', 'male', 'sandippadaliya@gmail.com', '2020-09-01');

INSERT INTO Courses (CourseName, CourseDescription, Credits) VALUES
('Mathematics', 'An introduction to mathematical concepts and techniques.', 4),
('Physics', 'Basic principles of physics and their applications.', 3),
('Computer Science', 'Introduction to computer programming and algorithms.', 4);

INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, '2019-09-01'),
(1, 2, '2019-09-01'),
(2, 2, '2019-09-01'),
(2, 3, '2019-09-01'),
(3, 1, '2020-09-01'),
(3, 3, '2020-09-01');

INSERT INTO Grades (EnrollmentID, Grade) VALUES
(1, 'A'),
(2, 'B'),
(3, 'A'),
(4, 'C'),
(5, 'B'),
(6, 'A');

DELIMITER //
CREATE PROCEDURE EnrollStudent(IN student_id INT, IN course_id INT)
BEGIN
    DECLARE enrollment_exists INT;
    SELECT COUNT(*) INTO enrollment_exists FROM Enrollments WHERE StudentID = student_id AND CourseID = course_id;
    IF enrollment_exists = 0 THEN
        INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) VALUES (student_id, course_id, CURDATE());
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student already enrolled in this course';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER AfterEnrollInsert
AFTER INSERT ON Enrollments
FOR EACH ROW
BEGIN
    INSERT INTO Grades (EnrollmentID, Grade) VALUES (NEW.EnrollmentID, 'F');
END //
DELIMITER ;

