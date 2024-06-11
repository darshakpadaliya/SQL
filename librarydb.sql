CREATE DATABASE LibraryDB;

USE LibraryDB;

CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Birthdate DATE
);

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    ISBN VARCHAR(20),
    PublicationYear INT,
    Genre VARCHAR(50),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DateOfBirth DATE,
    MembershipDate DATE NOT NULL
);

CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    UserID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
INSERT INTO Authors (Name, Birthdate) VALUES ('J.K. Rowling', '1965-07-31');
INSERT INTO Authors (Name, Birthdate) VALUES ('George Orwell', '1903-06-25');

INSERT INTO Books (Title, AuthorID, ISBN, PublicationYear, Genre) VALUES ('Harry Potter and the Philosopher''s Stone', 1, '9780747532699', 1997, 'Fantasy');
INSERT INTO Books (Title, AuthorID, ISBN, PublicationYear, Genre) VALUES ('1984', 2, '9780451524935', 1949, 'Dystopian');

INSERT INTO Users (Name, Email, DateOfBirth, MembershipDate) VALUES ('darshak', 'darshak@example.com', '1985-03-15', CURDATE());
INSERT INTO Users (Name, Email, DateOfBirth, MembershipDate) VALUES ('ravi', 'ravi@example.com', '1990-07-20', CURDATE());

INSERT INTO Loans (BookID, UserID, LoanDate, ReturnDate) VALUES (1, 1, CURDATE(), NULL);
INSERT INTO Loans (BookID, UserID, LoanDate, ReturnDate) VALUES (2, 2, CURDATE(), NULL);

INSERT INTO Books (Title, AuthorID, ISBN, PublicationYear, Genre) VALUES ('New Book', 1, '1234567890', 2024, 'Fiction');

SELECT * FROM Books WHERE AuthorID = 1;

UPDATE Books SET Title = 'Updated Book Title' WHERE BookID = 1;

DELETE FROM Books WHERE BookID = 1;

  
