-- Classes
INSERT INTO Classes (ClassName, Description)
VALUES 

-- Sections
INSERT INTO Sections (SectionName, ClassID)
VALUES

-- Subjects
INSERT INTO Subjects (SubjectName)
VALUES 

-- Teachers
INSERT INTO Teachers (FullName, Gender, Qualification, Department, Phone)
VALUES 
   
-- ClassSubjects
INSERT INTO ClassSubjects 
VALUES 

-- TeacherSubjects
INSERT INTO TeacherSubjects 
VALUES 

-- Students
INSERT INTO Students (RollNo, FullName, Gender, DateOfBirth, ClassID, SectionID, Address, Phone)
VALUES 

-- ExamTypes
INSERT INTO ExamTypes (ExamTypeName, Description)
VALUES 

-- Exams
INSERT INTO Exams (ExamTypeID, ClassID, SectionID, ExamName, ExamStartDate, ExamEndDate)
VALUES 

-- ExamSubjects
INSERT INTO ExamSubjects (ExamID, SubjectID, ExamDate, FullMarks, PassMarks)
VALUES

-- StudentMarks
INSERT INTO StudentMarks (StudentID, ExamID, SubjectID, ObtainedMarks)
VALUES 

-- Grades
INSERT INTO Grades (GradeName, MinMarks, MaxMarks, GPA)
VALUES 

-- Attendance
INSERT INTO Attendance (StudentID, Date, Status)
VALUES 
 
-- ClassRoutine
INSERT INTO ClassRoutine (ClassID, SectionID, SubjectID, TeacherID, DayOfWeek, StartTime, EndTime)
VALUES 

-- Fees
INSERT INTO Fees (FeeType, Description, Amount)
VALUES 
 
-- StudentFees
INSERT INTO StudentFees (StudentID, FeeID, AmountPaid, DueAmount)
VALUES 

-- Designations
INSERT INTO Designations (DesignationName)
VALUES 

-- Departments
INSERT INTO Departments (DepartmentName)
VALUES 

-- Transport
INSERT INTO Transport (VehicleNo, DriverName, Capacity)
VALUES 

-- Routes
INSERT INTO Routes (RouteName, TransportID)
VALUES 
 
-- BusStudents
INSERT INTO BusStudents (StudentID, RouteID)
VALUES
 
-- Hostels
INSERT INTO Hostels (HostelName, Location)
VALUES 

-- HostelRooms
INSERT INTO HostelRooms (HostelID, RoomNo, Capacity)
VALUES 
 
-- StudentHostel
INSERT INTO StudentHostel (StudentID, RoomID)
VALUES 

-- Roles
INSERT INTO Roles (RoleName) 
VALUES 

-- Users
INSERT INTO Users (UserName, PasswordHash, FullName, RoleID)
VALUES 

-- Staffs
INSERT INTO Staffs (FullName, Gender, DateOfBirth, HireDate, DesignationID, DepartmentID, Phone, Email)
VALUES 

-- Parents
INSERT INTO Parents (ParentName, Gender, Phone, Address, Email)
VALUES

-- StudentParent
INSERT INTO StudentParent (StudentID, ParentID, Relation)
VALUES

-- BookCategories
INSERT INTO BookCategories (CategoryName, Description)
VALUES

-- LibraryBooks
INSERT INTO LibraryBooks (Title, Author, ISBN, PublishedYear, CategoryID, Quantity, AvailableCopies)
VALUES

-- BookIssues
INSERT INTO BookIssues (BookID, StudentID, IssueDate, DueDate)
VALUES

-- Periods
INSERT INTO Periods (PeriodName, StartTime, EndTime)
VALUES

-- Notices
INSERT INTO Notices (Title, Description, CreatedBy, ExpiryDate)
VALUES

-- Events
INSERT INTO Events (EventTitle, EventDate, Location, Description, CreatedBy)
VALUES

-- UserRoles
INSERT INTO UserRoles (UserID, RoleID)
VALUES
