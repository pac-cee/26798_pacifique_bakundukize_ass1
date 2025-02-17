

-- ======================================================================================
-- TABLE CREATION: Base Tables for Library Management System
-- ======================================================================================


ALTER SESSION SET CONTAINER = PDB26798;


--------------------------------------------------
-- DDL: Create Tables for the Library System
--------------------------------------------------

-- 1. Categories Table (One-to-Many: Category → Books)
CREATE TABLE Categories (
    category_id   NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL
);


-- 2. Books Table (One-to-Many: Category → Books, One-to-Many: Books → Loans)
CREATE TABLE Books (
    book_id           NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    title             VARCHAR2(200) NOT NULL,
    publication_year  NUMBER(4),
    category_id       NUMBER,
    price             NUMBER(8,2),
    rating            NUMBER(3,1),
    CONSTRAINT fk_books_category
        FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 3. Authors Table (Many-to-Many with Books)
CREATE TABLE Authors (
    author_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name      VARCHAR2(150) NOT NULL,
    bio       CLOB
);

-- 4. BookAuthors Table (Join table for many-to-many Books <--> Authors)
CREATE TABLE BookAuthors (
    book_id   NUMBER,
    author_id NUMBER,
    CONSTRAINT pk_bookauthors PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES Authors(author_id)
);


-- 5. Members Table (One-to-Many: Members → Loans, One-to-One with MemberProfiles)
CREATE TABLE Members (
    member_id       NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    name            VARCHAR2(150) NOT NULL,
    email           VARCHAR2(150) UNIQUE,
    membership_date DATE DEFAULT SYSDATE
);

-- 6. MemberProfiles Table (One-to-One with Members)
CREATE TABLE MemberProfiles (
    member_id NUMBER PRIMARY KEY,
    address   VARCHAR2(250),
    phone     VARCHAR2(20),
    CONSTRAINT fk_profile_member FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


-- 7. Loans Table (Transaction table: Many-to-One with Books and Members)
CREATE TABLE Loans (
    loan_id     NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    book_id     NUMBER,
    member_id   NUMBER,
    loan_date   DATE DEFAULT SYSDATE,
    return_date DATE,
    created_at  DATE DEFAULT SYSDATE,
    CONSTRAINT fk_loans_book FOREIGN KEY (book_id) REFERENCES Books(book_id),
    CONSTRAINT fk_loans_member FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


--------------------------------------------------
-- DCL: Granting Privileges (example)
--------------------------------------------------
--USER TO BE CREATED
CREATE USER bpacifique26798 IDENTIFIED BY "Euqificap12."
QUOTA UNLIMITED ON USERS;
-- Grant necessary system privileges to the new user
GRANT CREATE SESSION TO bpacifique26798;
GRANT CREATE TABLE TO bpacifique26798;

-- Grant SELECT, INSERT, UPDATE, DELETE on these tables to the new user
-- Grant object privileges for the Library Management System tables
GRANT SELECT, INSERT, UPDATE, DELETE ON Categories TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON Books TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON Authors TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON BookAuthors TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON Members TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON MemberProfiles TO bpacifique26798;
GRANT SELECT, INSERT, UPDATE, DELETE ON Loans TO bpacifique26798;


--------------------------------------------------
-- DML: Insert, Update, and Delete Data
--------------------------------------------------

-- Inserting sample data into Categories
INSERT INTO Categories (category_name) VALUES ('Technology');
INSERT INTO Categories (category_name) VALUES ('Biography');
INSERT INTO Categories (category_name) VALUES ('History');
INSERT INTO Categories (category_name) VALUES ('Self-Help');
INSERT INTO Categories (category_name) VALUES ('Poetry');
INSERT INTO Categories (category_name) VALUES ('Mystery');
INSERT INTO Categories (category_name) VALUES ('Science Fiction');
INSERT INTO Categories (category_name) VALUES ('Non-Fiction');
INSERT INTO Categories (category_name) VALUES ('Science');
COMMIT;
-- Inserting sample data into Books
INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('The Oracle of Delphi', 2018, 1, 29.99, 4.5);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('Learning SQL', 2020, 3, 39.99, 4.7);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('History of Rome', 2015, 2, 24.99, 4.3);
INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('Database Design Fundamentals', 2023, 4, 45.99, 4.8);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('Steve Jobs: The Biography', 2021, 5, 35.50, 4.9);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('World War II Chronicles', 2022, 6, 55.99, 4.6);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('Mindfulness in Practice', 2024, 7, 29.99, 4.2);

INSERT INTO Books (title, publication_year, category_id, price, rating)
VALUES ('Modern Poetry Collection', 2023, 8, 19.99, 4.0);
COMMIT;


-- Inserting sample data into Authors
INSERT INTO Authors (name, bio) VALUES ('Alice Walker', 'Author of various technical and literary works.');
INSERT INTO Authors (name, bio) VALUES ('Bob Smith', 'Historian and author.');
INSERT INTO Authors (name, bio) VALUES ('Sarah Johnson', 'Renowned technology author and researcher');

INSERT INTO Authors (name, bio) VALUES ('Michael Chang', 'Award-winning biographer'); 

INSERT INTO Authors (name, bio) VALUES ('Emily Roberts', 'Historical fiction specialist'); 

INSERT INTO Authors (name, bio) VALUES ('David Wilson', 'Self-help guru and motivational speaker');
COMMIT;

-- Inserting data into BookAuthors (associating books with authors)
-- Assume: Book 1 is by Alice Walker; Book 2 is by Alice Walker; Book 3 is by Bob Smith.
INSERT INTO BookAuthors (book_id, author_id) VALUES (1, 1);
INSERT INTO BookAuthors (book_id, author_id) VALUES (2, 1);
INSERT INTO BookAuthors (book_id, author_id) VALUES (3, 2);
INSERT INTO BookAuthors (book_id, author_id) VALUES (4, 3); -- Database Design by Sarah Johnson
INSERT INTO BookAuthors (book_id, author_id) VALUES (5, 4); -- Steve Jobs Bio by Michael Chang
INSERT INTO BookAuthors (book_id, author_id) VALUES (6, 5); -- WWII Chronicles by Emily Roberts
INSERT INTO BookAuthors (book_id, author_id) VALUES (7, 6); -- Mindfulness by David Wilson
INSERT INTO BookAuthors (book_id, author_id) VALUES (8, 1); -- Poetry by Alice Walker
COMMIT;


-- Inserting sample data into Members
INSERT INTO Members (name, email) VALUES ('John Doe', 'john.doe@example.com');
INSERT INTO Members (name, email) VALUES ('Jane Smith', 'jane.smith@example.com');
INSERT INTO Members (name, email) VALUES ('Maria Garcia', 'maria.garcia@gmail.com');
INSERT INTO Members (name, email) VALUES ('James Wilson', 'jwilson@university.edu');
INSERT INTO Members (name, email) VALUES ('Sarah Chen', 'schen@company.org');
INSERT INTO Members (name, email) VALUES ('Ahmed Hassan', 'a.hassan@research.net');
COMMIT;


-- Inserting sample data into MemberProfiles
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (1, '123 Main St', '555-1234');
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (2, '456 Elm St', '555-5678');
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (3, '789 Pine Boulevard, Boston, MA 02108', '555-9012');
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (4, '321 University Ave, Cambridge, MA 02139', '555-3456');
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (5, '567 Corporate Drive, New York, NY 10001', '555-7890');
INSERT INTO MemberProfiles (member_id, address, phone) VALUES (6, '890 Research Park, San Jose, CA 95110', '555-4321');
COMMIT;


-- Inserting sample data into Loans
-- Create several loans so that we can later test queries for "past 7 days" and "more than 3 transactions"
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (1, 1, SYSDATE - 2, NULL, SYSDATE - 2);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (2, 1, SYSDATE - 6, SYSDATE - 1, SYSDATE - 6);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (3, 1, SYSDATE - 8, SYSDATE - 3, SYSDATE - 8);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (1, 2, SYSDATE - 1, NULL, SYSDATE - 1);

-- Extra loans for member 1 to test "more than 3 related transactions"
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (2, 1, SYSDATE - 1, NULL, SYSDATE - 1);
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (4, 3, SYSDATE - 3, NULL, SYSDATE - 3);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (5, 3, SYSDATE - 5, SYSDATE - 1, SYSDATE - 5);

-- Older loans (more than 7 days)
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (6, 4, SYSDATE - 15, SYSDATE - 8, SYSDATE - 15);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (7, 4, SYSDATE - 20, SYSDATE - 13, SYSDATE - 20);

-- Multiple loans for same member (testing frequency)
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (8, 5, SYSDATE - 10, SYSDATE - 3, SYSDATE - 10);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (1, 5, SYSDATE - 7, NULL, SYSDATE - 7);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (2, 5, SYSDATE - 4, NULL, SYSDATE - 4);

-- Current active loans
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (3, 6, SYSDATE - 1, NULL, SYSDATE - 1);

INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (4, 6, SYSDATE, NULL, SYSDATE);
COMMIT;


-- Update Example: Correct a book title
UPDATE Books
SET title = 'The Oracle at Delphi'
WHERE book_id = 1;
COMMIT;


-- Delete Example: Remove an author that is no longer needed
-- First delete the related records from BookAuthors
DELETE FROM BookAuthors WHERE author_id = 2;

-- Then delete the author
DELETE FROM Authors WHERE author_id = 2;

COMMIT;




--------------------------------------------------
-- SQL Queries
--------------------------------------------------

-- 1. Basic SELECT: Retrieve all books with their categories (using a join)
SELECT b.book_id,
       b.title,
       c.category_name,
       b.price,
       b.rating
FROM Books b
LEFT JOIN Categories c ON b.category_id = c.category_id;
/

-- 2. Identify records (loans) created in the past 7 days
SELECT *
FROM Loans
WHERE created_at >= SYSDATE - 7;
/

-- 3. Retrieve the top 5 highest priced books in each category
-- (Using analytic function ROW_NUMBER)
SELECT book_id, title, category_id, price, rating
FROM (
    SELECT b.*,
           ROW_NUMBER() OVER (PARTITION BY b.category_id ORDER BY b.price DESC) AS rn
    FROM Books b
) 
WHERE rn <= 5;
/

-- 4. Retrieve members who have more than 3 loan transactions
SELECT m.member_id, m.name, COUNT(l.loan_id) AS total_loans
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(l.loan_id) > 3;
/

-- 5. A sample subquery: Find books that have been loaned at least once by members from a specific email domain
SELECT *
FROM Books
WHERE book_id IN (
    SELECT DISTINCT l.book_id
    FROM Loans l
    JOIN Members m ON l.member_id = m.member_id
    WHERE m.email LIKE '%@example.com'
);
-- 1. Members with more than 3 loans
SELECT 
    m.member_id,
    m.name,
    m.email,
    COUNT(*) as loan_count
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.member_id, m.name, m.email
HAVING COUNT(*) > 3;

-- 2. Books that have been loaned more than 3 times
SELECT 
    b.book_id,
    b.title,
    c.category_name,
    COUNT(*) as loan_count
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
JOIN Categories c ON b.category_id = c.category_id
GROUP BY b.book_id, b.title, c.category_name
HAVING COUNT(*) > 3;

-- 3. Detailed view of transactions for entities with more than 3 loans
SELECT 
    m.member_id,
    m.name,
    b.title,
    l.loan_date,
    l.return_date,
    CASE 
        WHEN l.return_date IS NULL THEN 'Active'
        ELSE 'Returned'
    END as loan_status
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
JOIN Books b ON l.book_id = b.book_id
WHERE m.member_id IN (
    SELECT member_id
    FROM Loans
    GROUP BY member_id
    HAVING COUNT(*) > 3
)
ORDER BY m.member_id, l.loan_date;
/
-- ======================================================================================
-- TCL OPERATIONS: Transaction Control Examples
-- ======================================================================================
--------------------------------------------------
-- TCL Example: Using Savepoint and Rollback
--------------------------------------------------

-- Suppose we want to insert a loan but then rollback if something goes wrong:
SAVEPOINT before_loan;
INSERT INTO Loans (book_id, member_id, loan_date, return_date, created_at)
VALUES (3, 2, SYSDATE, NULL, SYSDATE);

-- If an error or check fails, you could rollback:
-- ROLLBACK TO before_loan;
-- Otherwise, finalize:
COMMIT;
/
-- Set a savepoint before performing a risky DML operation
SAVEPOINT before_delete;

-- Delete operation: Delete a loan record (simulate a scenario)
DELETE FROM Loans WHERE loan_id = 8;

-- Rolling back to the savepoint (if the delete is not desired)
ROLLBACK TO SAVEPOINT before_delete;

-- Finally, commit the transaction
COMMIT;
/
