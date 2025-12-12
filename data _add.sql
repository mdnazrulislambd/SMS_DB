/*******************************
  Realistic data generator for
  School Management DB (T-SQL)
  - Adds Subjects, Teachers, Sections (9 & 10 streams)
  - Generates Students (~40-60 per class), Parents
  - Inserts Attendance for 2025-11-09
  - Adds simple Exam / ExamSubjects / StudentMarks samples
  Note: Run in the database that already has your schema.
  Make DB backup before running on production.
********************************/

SET NOCOUNT ON;
BEGIN TRANSACTION;

-- 1) Add Subjects (if not exists)
DECLARE @now DATETIME = GETDATE();

IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectName = 'Bangla')
BEGIN
    INSERT INTO Subjects (SubjectName, Description) VALUES
    ('Bangla', 'Bangla language and literature'),
    ('English', 'English language and literature'),
    ('Mathematics', 'Mathematics'),
    ('Physics', 'Physics'),
    ('Chemistry', 'Chemistry'),
    ('Biology', 'Biology'),
    ('Higher Math', 'Higher mathematics for secondary level'),
    ('ICT', 'Information and Communication Technology'),
    ('Business Studies', 'Business studies / commerce subjects'),
    ('Accounting', 'Accounting and finance basics'),
    ('History', 'History'),
    ('Geography', 'Geography');
END;

-- 2) Add Teachers (if not exists) - realistic set
IF NOT EXISTS (SELECT 1 FROM Teachers WHERE FullName = 'Md. Aminul Islam')
BEGIN
    INSERT INTO Teachers (FullName, Gender, DateOfBirth, HireDate, Qualification, Department, Phone, Email)
    VALUES
    ('Md. Aminul Islam','Male','1980-03-12','2010-02-01','MSc in Physics','Science','01710000001','aminul.phy@example.com'),
    ('Mrs. Shahnaz Sultana','Female','1985-07-22','2012-08-15','MA in Bangla','Bangla','01710000002','shahnaz.ban@example.com'),
    ('Mr. Rubel Hossain','Male','1982-11-05','2009-06-20','MEd','Administration','01710000003','rubel.admin@example.com'),
    ('Ms. Farhana Akter','Female','1990-02-28','2016-01-10','BEd in English','English','01710000004','farhana.eng@example.com'),
    ('Mr. Tanvir Rahman','Male','1987-09-10','2014-05-05','MSc in Mathematics','Math','01710000005','tanvir.math@example.com'),
    ('Ms. Ritu Das','Female','1992-05-18','2018-03-12','BSc in CSE','ICT','01710000006','ritu.ict@example.com'),
    ('Mr. Saiful Karim','Male','1984-12-19','2011-07-01','MCom','Business','01710000007','saiful.bus@example.com'),
    ('Ms. Laila Noor','Female','1988-06-30','2013-09-01','MSc in Chemistry','Science','01710000008','laila.chem@example.com'),
    ('Mr. Imran Siddique','Male','1986-04-02','2012-11-20','MEd','Social Studies','01710000009','imran.ss@example.com'),
    ('Ms. Nabila Rahman','Female','1991-10-15','2017-08-25','BEd','Biology','01710000010','nabila.bio@example.com');
END;

-- 3) Create Sections for Class 9 & 10 streams if not exist
-- We'll add Section names: Science, Business, Humanities for ClassID=5 (Class 9) and ClassID=6 (Class 10)
-- Ensure SectionName unique per class
DECLARE @class9 INT = 5, @class10 INT = 6;

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class9 AND SectionName = 'Science')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Science', @class9);

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class9 AND SectionName = 'Business')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Business', @class9);

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class9 AND SectionName = 'Humanities')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Humanities', @class9);

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class10 AND SectionName = 'Science')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Science', @class10);

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class10 AND SectionName = 'Business')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Business', @class10);

IF NOT EXISTS (SELECT 1 FROM Sections WHERE ClassID = @class10 AND SectionName = 'Humanities')
    INSERT INTO Sections (SectionName, ClassID) VALUES ('Humanities', @class10);

-- Capture SectionIDs for later use
DECLARE @sec6A INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 1 AND SectionName IN ('A','A '))
      ,@sec6B INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 1 AND SectionName IN ('B','B '))
      ,@sec7A INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 2 AND SectionName IN ('A','A '))
      ,@sec7B INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 2 AND SectionName IN ('B','B '))
      ,@sec8A INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 3 AND SectionName IN ('A','A '))
      ,@sec8B INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 3 AND SectionName IN ('B','B '))
      ,@sec9Sci INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class9 AND SectionName = 'Science')
      ,@sec9Bus INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class9 AND SectionName = 'Business')
      ,@sec9Hum INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class9 AND SectionName = 'Humanities')
      ,@sec10Sci INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class10 AND SectionName = 'Science')
      ,@sec10Bus INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class10 AND SectionName = 'Business')
      ,@sec10Hum INT = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = @class10 AND SectionName = 'Humanities');

-- Fallback: if earlier A/B names were not exactly 'A' or 'B', try generic fetch
IF @sec6A IS NULL SET @sec6A = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 1 ORDER BY SectionID);
IF @sec6B IS NULL SET @sec6B = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 1 ORDER BY SectionID DESC);
IF @sec7A IS NULL SET @sec7A = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 2 ORDER BY SectionID);
IF @sec7B IS NULL SET @sec7B = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 2 ORDER BY SectionID DESC);
IF @sec8A IS NULL SET @sec8A = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 3 ORDER BY SectionID);
IF @sec8B IS NULL SET @sec8B = (SELECT TOP 1 SectionID FROM Sections WHERE ClassID = 3 ORDER BY SectionID DESC);

-- 4) Build helper tables for name generation
DECLARE @FirstNames TABLE (id INT IDENTITY(1,1), name NVARCHAR(50));
INSERT INTO @FirstNames (name) VALUES
('Rahim'),('Karim'),('Rina'),('Sumaiya'),('Nafis'),('Tania'),('Mehedi'),('Sadia'),('Arif'),('Nusrat'),
('Fahim'),('Sakib'),('Liza'),('Imran'),('Hasan'),('Mita'),('Nabila'),('Sami'),('Anika'),('Jannat');

DECLARE @LastNames TABLE (id INT IDENTITY(1,1), name NVARCHAR(50));
INSERT INTO @LastNames (name) VALUES
('Ahmed'),('Islam'),('Rahman'),('Hossain'),('Khan'),('Sultana'),('Akter'),('Chowdhury'),('Barua'),('Molla'),
('Sheikh'),('Bashar'),('Kadir'),('Mustafa'),('Uddin');

-- 5) Insert Students + Parents in loop per class/section
-- We'll generate:
-- Class 6 (ClassID=1): total 45 (A=23, B=22)
-- Class 7 (ClassID=2): total 45 (A=23, B=22)
-- Class 8 (ClassID=3): total 45 (A=23, B=22)
-- Class 9 (ClassID=5): total 50 (Science=17, Business=17, Humanities=16)
-- Class 10 (ClassID=6): total 50 (Science=17, Business=17, Humanities=16)

-- Helper vars
DECLARE @classId INT, @sectionId INT, @i INT, @count INT;
DECLARE @gender NVARCHAR(10), @fname NVARCHAR(50), @lname NVARCHAR(50), @fullname NVARCHAR(120);
DECLARE @dob DATE, @phone NVARCHAR(20), @address NVARCHAR(255), @roll NVARCHAR(20);
DECLARE @parentName NVARCHAR(100), @pphone NVARCHAR(20);
DECLARE @studentId INT, @parentId INT;

-- Function-like selection helper: get name by index
DECLARE @fnCount INT = (SELECT COUNT(*) FROM @FirstNames), @lnCount INT = (SELECT COUNT(*) FROM @LastNames);

-- seed random
DECLARE @seed VARBINARY(8) = CRYPT_GEN_RANDOM(8);

-- Insert students for a given class/section pattern
-- We'll build roll numbers like "6A001", "9S001" (S=Science stream). Map sections to roll prefix.
-- Map section prefixes:
-- For Class 6-8: section names A/B -> prefix 6A,6B etc. For Class 9/10 streams: use 9SC/9BU/9HU and 10SC/10BU/10HU

-- Class 6
SET @classId = 1;
-- A = @sec6A (23), B = @sec6B (22)
-- SECTION A
SET @sectionId = @sec6A; SET @count = 23; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (11 + (ABS(CHECKSUM(NEWID())) % 2)), CAST('2009-01-01' AS DATE)); -- age ~ 14-16 (approx)
    SET @phone = '0172' + RIGHT('000' + CAST((1000 + (@i % 9000)) AS VARCHAR(10)),4);
    SET @address = 'Dhaka, Ward ' + CAST(((@i % 20)+1) AS VARCHAR(3));
    SET @roll = '6A' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2025-01-05', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    -- Parent
    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0182' + RIGHT('000' + CAST((2000 + (@i % 8000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Business', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- SECTION B for class 6
SET @sectionId = @sec6B; SET @count = 22; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = (((@i+3) % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = (((@i+2) % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (11 + (ABS(CHECKSUM(NEWID())) % 3)), '2009-01-01');
    SET @phone = '0173' + RIGHT('000' + CAST((3000 + (@i % 7000)) AS VARCHAR(10)),4);
    SET @address = 'Gazipur, Area ' + CAST(((@i % 15)+1) AS VARCHAR(3));
    SET @roll = '6B' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2025-01-06', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mrs. ' + @lname;
    SET @pphone = '0183' + RIGHT('000' + CAST((4000 + (@i % 6000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Female', @pphone, NULL, @address, 'Service', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Mother');

    SET @i = @i + 1;
END;

-- Class 7
SET @classId = 2;
-- A = @sec7A (23), B = @sec7B (22)
SET @sectionId = @sec7A; SET @count = 23; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*2 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*3 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (12 + (ABS(CHECKSUM(NEWID())) % 3)), '2008-01-01');
    SET @phone = '0174' + RIGHT('000' + CAST((5000 + (@i % 5000)) AS VARCHAR(10)),4);
    SET @address = 'Narayanganj, Sector ' + CAST(((@i % 10)+1) AS VARCHAR(3));
    SET @roll = '7A' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2024-12-15', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0184' + RIGHT('000' + CAST((6000 + (@i % 4000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Farmer', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- SECTION B for class 7
SET @sectionId = @sec7B; SET @count = 22; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*3 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*4 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (12 + (ABS(CHECKSUM(NEWID())) % 2)), '2008-01-01');
    SET @phone = '0175' + RIGHT('000' + CAST((7000 + (@i % 3000)) AS VARCHAR(10)),4);
    SET @address = 'Comilla, Block ' + CAST(((@i % 8)+1) AS VARCHAR(3));
    SET @roll = '7B' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2024-12-10', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0186' + RIGHT('000' + CAST((8000 + (@i % 2000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Service', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- Class 8
SET @classId = 3;
-- A = @sec8A (23), B = @sec8B (22)
SET @sectionId = @sec8A; SET @count = 23; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*4 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*5 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (13 + (ABS(CHECKSUM(NEWID())) % 3)), '2007-01-01');
    SET @phone = '0176' + RIGHT('000' + CAST((9000 + (@i % 1000)) AS VARCHAR(10)),4);
    SET @address = 'Sylhet, Area ' + CAST(((@i % 6)+1) AS VARCHAR(3));
    SET @roll = '8A' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2023-12-01', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0187' + RIGHT('000' + CAST((1000 + (@i % 9000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Shopkeeper', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- SECTION B for class 8
SET @sectionId = @sec8B; SET @count = 22; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*5 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*6 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (13 + (ABS(CHECKSUM(NEWID())) % 2)), '2007-01-01');
    SET @phone = '0177' + RIGHT('000' + CAST((2000 + (@i % 8000)) AS VARCHAR(10)),4);
    SET @address = 'Rangpur, Zone ' + CAST(((@i % 12)+1) AS VARCHAR(3));
    SET @roll = '8B' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2023-11-19', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mrs. ' + @lname;
    SET @pphone = '0188' + RIGHT('000' + CAST((3000 + (@i % 7000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Female', @pphone, NULL, @address, 'Teacher', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Mother');

    SET @i = @i + 1;
END;

-- Class 9 (streams) total 50 -> Science 17, Business 17, Humanities 16
SET @classId = @class9;
-- Science
SET @sectionId = @sec9Sci; SET @count = 17; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*7 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*2 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (14 + (ABS(CHECKSUM(NEWID())) % 2)), '2006-01-01');
    SET @phone = '0191' + RIGHT('000' + CAST((1000 + (@i % 9000)) AS VARCHAR(10)),4);
    SET @address = 'Rajshahi, Sector ' + CAST(((@i % 9)+1) AS VARCHAR(3));
    SET @roll = '9SC' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2022-01-10', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0192' + RIGHT('000' + CAST((2000 + (@i % 8000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Service', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- Business
SET @sectionId = @sec9Bus; SET @count = 17; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*8 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*3 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (14 + (ABS(CHECKSUM(NEWID())) % 3)), '2006-01-01');
    SET @phone = '0193' + RIGHT('000' + CAST((3000 + (@i % 7000)) AS VARCHAR(10)),4);
    SET @address = 'Mymensingh, Area ' + CAST(((@i % 6)+1) AS VARCHAR(3));
    SET @roll = '9BU' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2022-01-12', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mrs. ' + @lname;
    SET @pphone = '0194' + RIGHT('000' + CAST((4000 + (@i % 6000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Female', @pphone, NULL, @address, 'Business', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Mother');

    SET @i = @i + 1;
END;

-- Humanities
SET @sectionId = @sec9Hum; SET @count = 16; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*9 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*4 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (14 + (ABS(CHECKSUM(NEWID())) % 2)), '2006-01-01');
    SET @phone = '0195' + RIGHT('000' + CAST((5000 + (@i % 5000)) AS VARCHAR(10)),4);
    SET @address = 'Barishal, Block ' + CAST(((@i % 7)+1) AS VARCHAR(3));
    SET @roll = '9HU' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2022-01-08', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0196' + RIGHT('000' + CAST((6000 + (@i % 4000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Driver', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- Class 10 (streams) similar counts
SET @classId = @class10;
-- Science
SET @sectionId = @sec10Sci; SET @count = 17; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*3 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*5 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (15 + (ABS(CHECKSUM(NEWID())) % 2)), '2005-01-01');
    SET @phone = '0197' + RIGHT('000' + CAST((7000 + (@i % 3000)) AS VARCHAR(10)),4);
    SET @address = 'Chattogram, Area ' + CAST(((@i % 10)+1) AS VARCHAR(3));
    SET @roll = '10SC' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2021-01-10', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0198' + RIGHT('000' + CAST((8000 + (@i % 2000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Service', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- Business
SET @sectionId = @sec10Bus; SET @count = 17; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*6 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*7 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (15 + (ABS(CHECKSUM(NEWID())) % 3)), '2005-01-01');
    SET @phone = '0199' + RIGHT('000' + CAST((9000 + (@i % 1000)) AS VARCHAR(10)),4);
    SET @address = 'Tangail, Area ' + CAST(((@i % 9)+1) AS VARCHAR(3));
    SET @roll = '10BU' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Male' ELSE 'Female' END, @dob, @classId, @sectionId, '2021-01-12', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mrs. ' + @lname;
    SET @pphone = '0180' + RIGHT('000' + CAST((1000 + (@i % 9000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Female', @pphone, NULL, @address, 'Business', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Mother');

    SET @i = @i + 1;
END;

-- Humanities
SET @sectionId = @sec10Hum; SET @count = 16; SET @i = 1;
WHILE @i <= @count
BEGIN
    SELECT @fname = name FROM @FirstNames WHERE id = ((@i*2 % @fnCount) + 1);
    SELECT @lname = name FROM @LastNames WHERE id = ((@i*9 % @lnCount) + 1);
    SET @fullname = @fname + ' ' + @lname;
    SET @dob = DATEADD(year, - (15 + (ABS(CHECKSUM(NEWID())) % 2)), '2005-01-01');
    SET @phone = '0181' + RIGHT('000' + CAST((2000 + (@i % 8000)) AS VARCHAR(10)),4);
    SET @address = 'Jessore, Ward ' + CAST(((@i % 11)+1) AS VARCHAR(3));
    SET @roll = '10HU' + RIGHT('000' + CAST(@i AS VARCHAR(3)),3);
    INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, AdmissionDate, Address, Phone, Email)
    VALUES (@roll, @fullname, CASE WHEN (@i % 2)=0 THEN 'Female' ELSE 'Male' END, @dob, @classId, @sectionId, '2021-01-08', @address, @phone, NULL);
    SET @studentId = SCOPE_IDENTITY();

    SET @parentName = 'Mr. ' + @lname;
    SET @pphone = '0185' + RIGHT('000' + CAST((3000 + (@i % 7000)) AS VARCHAR(10)),4);
    INSERT INTO Parents (ParentName, Gender, Phone, Email, Address, Occupation, CreatedAt)
    VALUES (@parentName, 'Male', @pphone, NULL, @address, 'Retired', @now);
    SET @parentId = SCOPE_IDENTITY();

    INSERT INTO StudentParent (StudentID, ParentID, Relationship)
    VALUES (@studentId, @parentId, 'Father');

    SET @i = @i + 1;
END;

-- 6) Attendance: add one day's attendance for all students just inserted (2025-11-09)
-- We'll mark most present; randomly mark some absent/late
DECLARE @attDate DATE = '2025-11-09';

INSERT INTO Attendance (StudentID, Date, Status)
SELECT s.StudentID, @attDate,
       CASE (ABS(CHECKSUM(NEWID())) % 20)
            WHEN 0 THEN 'Late'
            WHEN 1 THEN 'Absent'
            WHEN 2 THEN 'Absent'
            ELSE 'Present'
       END
FROM Students s
WHERE s.AdmissionDate >= '2021-01-01' -- roughly the students we inserted recently (safe filter)
-- Note: this may also include some earlier students, adjust filter if needed.

-- 7) Exams & ExamSubjects & StudentMarks (simple sample)
-- Create an Exam Type if not exists
IF NOT EXISTS (SELECT 1 FROM ExamTypes WHERE ExamTypeName = 'Mid Term')
    INSERT INTO ExamTypes (ExamTypeName, Description) VALUES ('Mid Term','Half-yearly mid term exam');

-- Create a Mid Term exam for Class 6 (if not exists)
DECLARE @midExamTypeId INT = (SELECT TOP 1 ExamTypeID FROM ExamTypes WHERE ExamTypeName = 'Mid Term');
IF NOT EXISTS (SELECT 1 FROM Exams WHERE ClassID = 1 AND ExamTypeID = @midExamTypeId AND ExamName LIKE '%Mid Term 2025%')
BEGIN
    INSERT INTO Exams (ExamTypeID, ClassID, SectionID, ExamName, ExamStartDate, ExamEndDate)
    VALUES (@midExamTypeId, 1, NULL, 'Class 6 Mid Term Exam 2025', '2025-05-10', '2025-05-20');
END;

-- Grab an ExamID for class 6 exam
DECLARE @exam6 INT = (SELECT TOP 1 ExamID FROM Exams WHERE ClassID = 1 AND ExamTypeID = @midExamTypeId ORDER BY ExamID DESC);

-- Ensure ExamSubjects for Class 6 exist (Bangla, English, Math, Science)
DECLARE @banglaId INT = (SELECT TOP 1 SubjectID FROM Subjects WHERE SubjectName='Bangla'),
        @engId INT = (SELECT TOP 1 SubjectID FROM Subjects WHERE SubjectName='English'),
        @mathId INT = (SELECT TOP 1 SubjectID FROM Subjects WHERE SubjectName='Mathematics'),
        @sciId INT = (SELECT TOP 1 SubjectID FROM Subjects WHERE SubjectName='Physics');

IF @exam6 IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ExamSubjects WHERE ExamID = @exam6 AND SubjectID = @banglaId)
        INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks) VALUES (@exam6, @banglaId, '2025-05-10', 100, 33);
    IF NOT EXISTS (SELECT 1 FROM ExamSubjects WHERE ExamID = @exam6 AND SubjectID = @engId)
        INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks) VALUES (@exam6, @engId, '2025-05-12', 100, 33);
    IF NOT EXISTS (SELECT 1 FROM ExamSubjects WHERE ExamID = @exam6 AND SubjectID = @mathId)
        INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks) VALUES (@exam6, @mathId, '2025-05-15', 100, 33);
    IF NOT EXISTS (SELECT 1 FROM ExamSubjects WHERE ExamID = @exam6 AND SubjectID = @sciId)
        INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks) VALUES (@exam6, @sciId, '2025-05-17', 100, 33);
END;

-- Insert StudentMarks for Class 6 students for the above exam (sample randomized marks)
INSERT INTO StudentMarks (StudentID, ExamID, SubjectID, ObtainedMarks)
SELECT s.StudentID, @exam6, es.SubjectID,
       CAST( (50 + (ABS(CHECKSUM(NEWID())) % 51)) AS INT ) -- marks between 50-100 (sample)
FROM Students s
CROSS JOIN (SELECT SubjectID FROM ExamSubjects WHERE ExamID = @exam6) es
WHERE s.ClassID = 1
  AND @exam6 IS NOT NULL;

-- 8) ClassRoutine sample (add a few routines if empty for Class 6)
IF NOT EXISTS (SELECT 1 FROM ClassRoutine WHERE ClassID = 1)
BEGIN
    -- pick a teacher for each subject
    DECLARE @tBangla INT = (SELECT TOP 1 TeacherID FROM Teachers WHERE Department LIKE '%Bangla%' OR FullName LIKE '%Shahnaz%');
    DECLARE @tEng INT = (SELECT TOP 1 TeacherID FROM Teachers WHERE Department LIKE '%English%' OR FullName LIKE '%Farhana%');
    DECLARE @tMath INT = (SELECT TOP 1 TeacherID FROM Teachers WHERE Department LIKE '%Math%' OR FullName LIKE '%Tanvir%');
    DECLARE @tSci INT = (SELECT TOP 1 TeacherID FROM Teachers WHERE Department LIKE '%Science%' OR FullName LIKE '%Aminul%');

    INSERT INTO ClassRoutine (ClassID, SectionID, SubjectID, TeacherID, DayOfWeek, StartTime, EndTime)
    VALUES
    (1, @sec6A, @banglaId, ISNULL(@tBangla,1), 'Sunday','09:00','09:45'),
    (1, @sec6A, @engId, ISNULL(@tEng,2), 'Sunday','09:50','10:35'),
    (1, @sec6A, @mathId, ISNULL(@tMath,5), 'Sunday','10:40','11:25'),
    (1, @sec6A, @sciId, ISNULL(@tSci,1), 'Sunday','11:30','12:15');
END;

-- 9) Fees examples - only add if missing
IF NOT EXISTS (SELECT 1 FROM Fees WHERE FeeType = 'Annual Tuition')
BEGIN
    INSERT INTO Fees (FeeType, Description, Amount) VALUES
    ('Annual Tuition','Annual tuition fee for the academic year', 60000),
    ('Exam Fee','Exam fee per student per exam', 500),
    ('Library Fee','Annual library fee', 550),
    ('Transport Fee','Monthly bus fee (if applicable)', 1000);
END;

-- 10) Events & Notices sample (if not exists)
IF NOT EXISTS (SELECT 1 FROM Events WHERE EventTitle = 'Inter School Science Fair 2025')
BEGIN
    INSERT INTO Events (EventTitle, EventDate, Location, Description, CreatedBy, CreatedAt)
    VALUES ('Inter School Science Fair 2025','2025-12-05','School Auditorium','Science exhibition with school teams', 2, @now);
END;

IF NOT EXISTS (SELECT 1 FROM Notices WHERE Title = 'Parent-Teacher Meeting 2025-11-15')
BEGIN
    INSERT INTO Notices (Title, Description, CreatedBy, CreatedAt, ExpiryDate)
    VALUES ('Parent-Teacher Meeting 2025-11-15','All parents are requested to attend the PTM on 15th Nov at 3:00 PM.', 2, @now, '2025-11-15');
END;

COMMIT TRANSACTION;
SET NOCOUNT OFF;

PRINT 'Data generation complete. Check Students/Parents/Attendance/Exams tables.';
