CREATE DATABASE HostelManagement;

USE HostelManagement;

-- Table to store hostel information
CREATE TABLE Hostels (
    HostelID INT AUTO_INCREMENT PRIMARY KEY,
    HostelName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL
);

-- Table to store room information
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    HostelID INT,
    RoomNumber VARCHAR(10) NOT NULL,
    Capacity INT NOT NULL,
    Occupied INT DEFAULT 0,
    FOREIGN KEY (HostelID) REFERENCES Hostels(HostelID)
);

-- Table to store student information
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL
);

-- Table to store booking information
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    RoomID INT,
    BookingDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- Insert data into Hostels table
INSERT INTO Hostels (HostelName, Address) VALUES
('Hostel A', '123 Street, City'),
('Hostel B', '456 Avenue, City');

-- Insert data into Rooms table
INSERT INTO Rooms (HostelID, RoomNumber, Capacity) VALUES
(1, '101', 2),
(1, '102', 3),
(2, '201', 2),
(2, '202', 3);

-- Insert data into Students table
INSERT INTO Students (StudentName, Age, Gender) VALUES
('John Doe', 20, 'Male'),
('Jane Smith', 22, 'Female');

DELIMITER //


-- TRIGGER FOR UPDATE ROOM OCCUPANCY
CREATE TRIGGER UpdateRoomOccupancy
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Rooms
    SET Occupied = Occupied + 1
    WHERE RoomID = NEW.RoomID;
END;


-- TRIGGER FOR CHECKROOM CAPACITY
DELIMITER//
CREATE TRIGGER CheckRoomCapacity
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE room_capacity INT;
    DECLARE room_occupied INT;

    SELECT Capacity, Occupied INTO room_capacity, room_occupied
    FROM Rooms
    WHERE RoomID = NEW.RoomID;

    IF room_occupied >= room_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Room capacity exceeded';
    END IF;
END;

-- PROCEDURE BOOK ROOM
DELIMITER //
CREATE PROCEDURE BookRoom(
    IN p_StudentID INT,
    IN p_RoomID INT,
    IN p_BookingDate DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Bookings (StudentID, RoomID, BookingDate)
    VALUES (p_StudentID, p_RoomID, p_BookingDate);

    COMMIT;
END //

DELIMITER ;

-- CALL THE PROCEDURE
CALL BookRoom(1, 1, '2024-06-01');
CALL BookRoom(2, 2, '2024-06-02');



