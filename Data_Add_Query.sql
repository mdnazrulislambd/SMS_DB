-- Classes
INSERT INTO Classes (ClassName, Description)
VALUES 
       ('Class 6', 'Middle school'),
       ('Class 7', 'Middle school'),
       ('Class 8', 'Upper middle school');

-- Sections
INSERT INTO Sections (SectionName, ClassID)
VALUES
       ('A', 1), ('B', 1),
       ('A', 2), ('B', 2),
       ('A', 3), ('B', 3);

-- Subjects
INSERT INTO Subjects (SubjectName)
VALUES 
       ('Bangla'), ('English'), ('Math'), ('Science'), ('ICT');

-- Teachers
INSERT INTO Teachers (FullName, Gender, Qualification, Department, Phone)
VALUES 
       ('Mr. Hasan', 'Male', 'B.Sc. in Physics', 'Science', '01700000001'),
       ('Ms. Rina', 'Female', 'M.A. in English', 'Arts', '01700000002');

-- ClassSubjects
INSERT INTO ClassSubjects 
VALUES 
       (1,1), (1,2), (1,3), (1,4), (1,5);

-- TeacherSubjects
INSERT INTO TeacherSubjects 
VALUES 
       (1,4), (2,2);

-- Students
INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, Address, Phone)
VALUES 
       ('6A01', 'Rahim Ahmed', 'Male', '2010-02-15', 1, 1, 'Dhaka', '0171000001'),
       ('6A02', 'Karim Islam', 'Male', '2010-06-21', 1, 1, 'Gazipur', '0171000002'),
       ('6B01', 'Rina Akter', 'Female', '2010-04-10', 1, 2, 'Narayanganj', '0171000003');

-- ExamTypes
INSERT INTO ExamTypes (ExamTypeName, Description)
VALUES 
       ('Mid Term', 'Half-yearly examination'),
       ('Final Exam', 'Annual examination'),
       ('Class Test', 'Short test before main exam');

-- Exams
INSERT INTO Exams (ExamTypeID, ClassID, SectionID, ExamName, ExamStartDate, ExamEndDate)
VALUES 
       (1, 1, 1, 'Class 6 Mid Term Exam 2025', '2025-05-10', '2025-05-20');

-- ExamSubjects
INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks)
VALUES
       (1, 1, '2025-05-10', 100, 33),
       (1, 2, '2025-05-12', 100, 33),
       (1, 3, '2025-05-15', 100, 33);

-- StudentMarks
INSERT INTO StudentMarks (StudentID, ExamID, SubjectID, ObtainedMarks)
VALUES 
       (1, 1, 1, 78),
       (1, 1, 2, 84),
       (2, 1, 1, 62),
       (2, 1, 2, 70);

-- Grades
INSERT INTO Grades (GradeName, MinMarks, MaxMarks, GPA)
VALUES 
       ('A+', 80, 100, 5.00),
       ('A', 70, 79, 4.00),
       ('B', 60, 69, 3.50),
       ('C', 50, 59, 3.00),
       ('D', 40, 49, 2.00),
       ('F', 0, 39, 0.00);

-- Attendance
INSERT INTO Attendance (StudentID, Date, Status)
VALUES 
       (1, '2025-05-10', 'Present'),
       (2, '2025-05-10', 'Absent'),
       (3, '2025-05-10', 'Present');

-- ClassRoutine
INSERT INTO ClassRoutine (ClassID, SectionID, SubjectID, TeacherID, DayOfWeek, StartTime, EndTime)
VALUES 
       (1, 1, 1, 2, 'Sunday', '09:00', '09:45'),
       (1, 1, 2, 2, 'Sunday', '09:50', '10:35'),
       (1, 1, 4, 1, 'Sunday', '10:40', '11:25');

-- Fees
INSERT INTO Fees (FeeType, Description, Amount)
VALUES 
       ('Tuition', 'Monthly tuition fee', 5000.00),
       ('Exam Fee', 'Per exam fee', 500.00),
       ('Transport Fee', 'Monthly bus fee', 1000.00);

-- StudentFees
INSERT INTO StudentFees (StudentID, FeeID, AmountPaid, DueAmount)
VALUES 
       (1, 1, 5000, 0),
       (2, 1, 3000, 2000),
       (3, 2, 500, 0);

-- Designations
INSERT INTO Designations (DesignationName)
VALUES 
       ('Headmaster'), ('Accountant'), ('Librarian'), ('Peon');

-- Departments
INSERT INTO Departments (DepartmentName)
VALUES 
       ('Administration'), ('Library'), ('Accounts'), ('Transport');

-- Transport
INSERT INTO Transport (VehicleNo, DriverName, Capacity)
VALUES 
       ('Dhaka-1234', 'Rahim', 40),
       ('Gazipur-5678', 'Karim', 35);

-- Routes
INSERT INTO Routes (RouteName, TransportID)
VALUES 
       ('Dhaka City Route', 1),
       ('Gazipur Route', 2);

-- BusStudents
INSERT INTO BusStudents (StudentID, RouteID)
VALUES
       (1,1),
       (2,2);

-- Hostels
INSERT INTO Hostels (HostelName, Location)
VALUES 
       ('Boys Hostel', 'North Campus'),
       ('Girls Hostel', 'South Campus');

-- HostelRooms
INSERT INTO HostelRooms (HostelID, RoomNo, Capacity)
VALUES 
       (1, '101', 4),
       (1, '102', 4),
       (2, '201', 3);

-- StudentHostel
INSERT INTO StudentHostel (StudentID, RoomID)
VALUES (1,1),
       (3,3);

-- Roles
INSERT INTO Roles (RoleName) 
VALUES 
       ('Admin'), ('Teacher'), ('Parent');

-- Users
INSERT INTO Users (UserName, PasswordHash, FullName, RoleID)
VALUES 
       ('admin', 'hashedpassword', 'Administrator', 1),
       ('teacher1', 'hashedpassword', 'Mr. Hasan', 2);

-- Staffs
INSERT INTO Staffs (FullName, Gender, DateOfBirth, HireDate, DesignationID, DepartmentID, Phone, Email)
VALUES 
       ('Mr. Alam', 'Male', '1985-03-15', '2015-01-10', 1, 1, '01711110001', 'alam@example.com'),              -- Headmaster, Administration
       ('Ms. Joya', 'Female', '1990-07-22', '2018-05-15', 3, 2, '01711110002', 'joya@example.com'),            -- Librarian, Library
       ('Mr. Rahman', 'Male', '1988-11-05', '2017-03-12', 2, 3, '01711110003', 'rahman@example.com'),          -- Accountant, Accounts
       ('Ms. Sultana', 'Female', '1992-09-18', '2019-06-01', 4, 1, '01711110004', 'sultana@example.com'),      -- Peon, Administration
       ('Mr. Karim', 'Male', '1987-12-30', '2016-08-20', 4, 4, '01711110005', 'karim@example.com');            -- Peon, Transport
