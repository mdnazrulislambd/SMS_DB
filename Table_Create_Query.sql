-- Classes Table
CREATE TABLE Classes (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);

-- Sections Table
CREATE TABLE Sections (
    SectionID INT IDENTITY(1,1) PRIMARY KEY,
    SectionName NVARCHAR(20) NOT NULL,
    ClassID INT NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);

-- Students Table
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    RollNo NVARCHAR(20) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    ClassID INT,
    SectionID INT,
    AdmissionDate DATE DEFAULT GETDATE(),
    Address NVARCHAR(255),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

-- Teachers Table
CREATE TABLE Teachers (
    TeacherID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    HireDate DATE DEFAULT GETDATE(),
    Qualification NVARCHAR(100),
    Department NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100)
);

-- Subjects Table
CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);

-- ClassSubjects Table 
CREATE TABLE ClassSubjects (
    ClassID INT NOT NULL,
    SubjectID INT NOT NULL,
    PRIMARY KEY (ClassID, SubjectID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- TeacherSubjects Table 
CREATE TABLE TeacherSubjects (
    TeacherID INT NOT NULL,
    SubjectID INT NOT NULL,
    PRIMARY KEY (TeacherID, SubjectID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- ExamTypes Table
CREATE TABLE ExamTypes (
    ExamTypeID INT IDENTITY(1,1) PRIMARY KEY,
    ExamTypeName NVARCHAR(50) NOT NULL,   
    Description NVARCHAR(200)
);

-- Exams Table
CREATE TABLE Exams (
    ExamID INT IDENTITY(1,1) PRIMARY KEY,
    ExamTypeID INT NOT NULL,
    ClassID INT NOT NULL,
    SectionID INT,
    ExamName NVARCHAR(100),
    ExamStartDate DATE,
    ExamEndDate DATE,
    FOREIGN KEY (ExamTypeID) REFERENCES ExamTypes(ExamTypeID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID)
);

-- ExamSubjects Table
CREATE TABLE ExamSubjects (
    ExamID INT NOT NULL,
    SubjectID INT NOT NULL,
    ExamDate DATE,
    FullMarks INT DEFAULT 100,
    PassMarks INT DEFAULT 33,
    PRIMARY KEY (ExamID, SubjectID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- StudentMarks Table
CREATE TABLE StudentMarks (
    MarkID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    ExamID INT NOT NULL,
    SubjectID INT NOT NULL,
    ObtainedMarks INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Grades Table
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    GradeName NVARCHAR(5),
    MinMarks INT,
    MaxMarks INT,
    GPA DECIMAL(3,2)
);

-- Attendance Table
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    Date DATE NOT NULL,
    Status NVARCHAR(10) CHECK (Status IN ('Present', 'Absent', 'Late')),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- ClassRoutine Table
CREATE TABLE ClassRoutine (
    RoutineID INT IDENTITY(1,1) PRIMARY KEY,
    ClassID INT NOT NULL,
    SectionID INT NOT NULL,
    SubjectID INT NOT NULL,
    TeacherID INT NOT NULL,
    DayOfWeek NVARCHAR(15),
    StartTime TIME,
    EndTime TIME,
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (SectionID) REFERENCES Sections(SectionID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID),
    FOREIGN KEY (TeacherID) REFERENCES Teachers(TeacherID)
);

-- Fees Table
CREATE TABLE Fees (
    FeeID INT IDENTITY(1,1) PRIMARY KEY,
    FeeType NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    Amount DECIMAL(10,2) NOT NULL
);

-- StudentFees Table
CREATE TABLE StudentFees (
    StudentFeeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    FeeID INT NOT NULL,
    AmountPaid DECIMAL(10,2),
    DueAmount DECIMAL(10,2),
    PaymentDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (FeeID) REFERENCES Fees(FeeID)
);

-- Staffs Table
CREATE TABLE Staffs (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10),
    DateOfBirth DATE,
    HireDate DATE DEFAULT GETDATE(),
    DesignationID INT,
    DepartmentID INT,
    Phone NVARCHAR(20),
    Email NVARCHAR(100)
);

-- Designations Table
CREATE TABLE Designations (
    DesignationID INT IDENTITY(1,1) PRIMARY KEY,
    DesignationName NVARCHAR(50) NOT NULL
);

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(50) NOT NULL
);

-- Transport Table
CREATE TABLE Transport (
    TransportID INT IDENTITY(1,1) PRIMARY KEY,
    VehicleNo NVARCHAR(20),
    DriverName NVARCHAR(100),
    Capacity INT
);

-- Routes Table
CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    RouteName NVARCHAR(100),
    TransportID INT,
    FOREIGN KEY (TransportID) REFERENCES Transport(TransportID)
);

-- BusStudents Table
CREATE TABLE BusStudents (
    StudentID INT NOT NULL,
    RouteID INT NOT NULL,
    PRIMARY KEY (StudentID, RouteID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID)
);

-- Hostels Table
CREATE TABLE Hostels (
    HostelID INT IDENTITY(1,1) PRIMARY KEY,
    HostelName NVARCHAR(100),
    Location NVARCHAR(255)
);

-- HostelRooms Table
CREATE TABLE HostelRooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    HostelID INT NOT NULL,
    RoomNo NVARCHAR(20),
    Capacity INT,
    FOREIGN KEY (HostelID) REFERENCES Hostels(HostelID)
);

-- StudentHostel Table
CREATE TABLE StudentHostel (
    StudentID INT NOT NULL,
    RoomID INT NOT NULL,
    PRIMARY KEY (StudentID, RoomID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (RoomID) REFERENCES HostelRooms(RoomID)
);

-- Roles Table
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL
);

-- Users Table
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100),
    RoleID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

