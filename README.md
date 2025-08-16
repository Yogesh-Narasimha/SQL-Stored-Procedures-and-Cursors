
CS6.302 - Software System Development
Lab - 2 :: SQL - Stored Procedures and Cursors

This document provides a complete step-by-step guide to setting up the database and executing the SQL scripts for Lab 2. The provided code includes the necessary table creation, data insertion, and all five stored procedures.

### Step 1: Database and Table Setup

First, open MySQL Workbench and connect to your local server. Execute the following SQL code to create the database and load the tables and data.

```sql
-- Create Database and use it
CREATE DATABASE lab2_db;
USE lab2_db;

-- Create Tables
CREATE TABLE Shows (
    ShowID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    ReleaseYear INT
);

CREATE TABLE Subscribers (
    SubscriberID INT PRIMARY KEY,
    SubscriberName VARCHAR(100),
    SubscriptionDate DATE
);

CREATE TABLE WatchHistory (
    HistoryID INT PRIMARY KEY,
    ShowID INT,
    SubscriberID INT,
    WatchTime INT, -- Duration in minutes
    FOREIGN KEY (ShowID) REFERENCES Shows(ShowID),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);

-- Insert Sample Data
INSERT INTO Shows (ShowID, Title, Genre, ReleaseYear) VALUES
(1, 'Stranger Things', 'Sci-Fi', 2016),
(2, 'The Crown', 'Drama', 2016),
(3, 'The Witcher', 'Fantasy', 2019);

INSERT INTO Subscribers (SubscriberID, SubscriberName, SubscriptionDate) VALUES
(1, 'Emily Clark', '2023-01-10'),
(2, 'Chris Adams', '2023-02-15'),
(3, 'Jordan Smith', '2023-03-05');

INSERT INTO WatchHistory (HistoryID, SubscriberID, ShowID, WatchTime) VALUES
(1, 1, 1, 100),
(2, 1, 2, 10),
(3, 2, 1, 20),
(4, 2, 2, 40),
(5, 2, 3, 10),
(6, 3, 2, 10),
(7, 3, 1, 10);
````

### Step 2: Stored Procedure Creation and Execution

Now, execute the following SQL code blocks one by one to create and run each procedure.

#### **q1.sql: ListAllSubscribers()**

*Creates a procedure that uses a cursor to iterate through all Subscribers and prints their names.*

```sql
DELIMITER $$
CREATE PROCEDURE ListAllSubscribers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_name VARCHAR(100);
    DECLARE cur CURSOR FOR SELECT SubscriberName FROM Subscribers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO sub_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Subscriber Name: ', sub_name);
    END LOOP;
    CLOSE cur;
END$$
DELIMITER ;
```

**To run:** `CALL ListAllSubscribers();`

#### **q2.sql: GetWatchHistoryBySubscriber(IN sub\_id INT)**

*Creates a procedure that returns all shows watched by a subscriber along with watch time.*

```sql
DELIMITER $$
CREATE PROCEDURE GetWatchHistoryBySubscriber(IN sub_id INT)
BEGIN
    SELECT S.Title, WH.WatchTime
    FROM WatchHistory WH
    JOIN Shows S ON WH.ShowID = S.ShowID
    WHERE WH.SubscriberID = sub_id;
END$$
DELIMITER ;
```

**To run:** `CALL GetWatchHistoryBySubscriber(1);`

#### **q3.sql: AddSubscriberIfNotExists(IN subName VARCHAR(100))**

*Adds a new subscriber into the Subscribers table, checking for existence first.*

```sql
DELIMITER $$
CREATE PROCEDURE AddSubscriberIfNotExists(IN subName VARCHAR(100))
BEGIN
    DECLARE subCount INT;
    SELECT COUNT(*) INTO subCount FROM Subscribers WHERE SubscriberName = subName;
    IF subCount = 0 THEN
        INSERT INTO Subscribers (SubscriberName, SubscriptionDate) VALUES (subName, CURDATE());
        SELECT 'New subscriber added successfully.';
    ELSE
        SELECT 'Subscriber already exists. No new record added.';
    END IF;
END$$
DELIMITER ;
```

**To run:** `CALL AddSubscriberIfNotExists('New Subscriber');`

#### **q4.sql: SendWatchTimeReport()**

*Creates a procedure that calls GetWatchHistoryBySubscriber() for all subscribers who have watched something.*

```sql
DELIMITER $$
CREATE PROCEDURE SendWatchTimeReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_has_history INT;
    DECLARE cur_subs CURSOR FOR SELECT SubscriberID FROM Subscribers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur_subs;
    read_loop: LOOP
        FETCH cur_subs INTO sub_id;
        IF done THEN LEAVE read_loop; END IF;
        SELECT COUNT(*) INTO sub_has_history FROM WatchHistory WHERE SubscriberID = sub_id;
        IF sub_has_history > 0 THEN
            SELECT CONCAT('--- Watch History for Subscriber ID: ', sub_id, ' ---');
            CALL GetWatchHistoryBySubscriber(sub_id);
        END IF;
    END LOOP;
    CLOSE cur_subs;
END$$
DELIMITER ;
```

**To run:** `CALL SendWatchTimeReport();`

#### **q5.sql: SubscriberWatchHistoryReport()**

*Creates a procedure with a cursor that loops through each subscriber and prints their watch history.*

```sql
DELIMITER $$
CREATE PROCEDURE SubscriberWatchHistoryReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE sub_id INT;
    DECLARE sub_name VARCHAR(100);
    DECLARE cur_subs CURSOR FOR SELECT SubscriberID, SubscriberName FROM Subscribers;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur_subs;
    read_loop: LOOP
        FETCH cur_subs INTO sub_id, sub_name;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('--- Watch History for ', sub_name, ' (ID: ', sub_id, ') ---');
        CALL GetWatchHistoryBySubscriber(sub_id);
    END LOOP;
    CLOSE cur_subs;
END$$
DELIMITER ;
```

**To run:** `CALL SubscriberWatchHistoryReport();`

### Git Repository

Git Repository Link: https://github.com/Yogesh-Narasimha/SQL-Stored-Procedures-and-Cursors
```
```
