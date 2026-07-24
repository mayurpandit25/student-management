-- Run this once in MySQL before deploying the app:
--   mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS school_db;
USE school_db;

CREATE TABLE IF NOT EXISTS students (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    name   VARCHAR(100)  NOT NULL,
    email  VARCHAR(100)  NOT NULL,
    course VARCHAR(100)  NOT NULL,
    marks  DECIMAL(5,2)  NOT NULL DEFAULT 0
);

-- Sample data
INSERT INTO students (name, email, course, marks) VALUES
    ('Aarav Sharma',  'aarav.sharma@example.com',  'Computer Science', 88.5),
    ('Priya Nair',    'priya.nair@example.com',    'Information Tech', 91.0),
    ('Rohan Mehta',   'rohan.mehta@example.com',   'Electronics',      76.2);
