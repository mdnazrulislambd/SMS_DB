SELECT c.ClassName, COUNT(s.SectionID) AS TotalSections
FROM Classes c
JOIN Sections s ON c.ClassID = s.ClassID
GROUP BY c.ClassName;
GO

SELECT c.ClassName, COUNT(cs.SubjectID) AS TotalSubjects
FROM Classes c
JOIN ClassSubjects cs ON c.ClassID = cs.ClassID
GROUP BY c.ClassName;
GO

SELECT c.ClassName, s.SubjectName
FROM Classes c
JOIN ClassSubjects cs ON c.ClassID = cs.ClassID
JOIN Subjects s ON cs.SubjectID = s.SubjectID
ORDER BY c.ClassName, s.SubjectName;
GO

SELECT t.FullName, s.SubjectName
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
JOIN Subjects s ON ts.SubjectID = s.SubjectID
ORDER BY t.FullName;
GO

SELECT Department, FullName, COUNT(ts.SubjectID) AS TotalSubjects
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
GROUP BY Department, FullName
ORDER BY Department;
GO

SELECT s.SubjectName, COUNT(ts.TeacherID) AS TotalTeachers
FROM Subjects s
JOIN TeacherSubjects ts ON s.SubjectID = ts.SubjectID
GROUP BY s.SubjectName
ORDER BY s.SubjectName;
GO

SELECT t.FullName, COUNT(ts.SubjectID) AS SubjectCount
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
GROUP BY t.FullName
HAVING COUNT(ts.SubjectID) > 1
ORDER BY SubjectCount DESC;
GO

SELECT s.SubjectName, STRING_AGG(t.FullName, ', ') AS Teachers
FROM Subjects s
JOIN TeacherSubjects ts ON s.SubjectID = ts.SubjectID
JOIN Teachers t ON ts.TeacherID = t.TeacherID
GROUP BY s.SubjectName;
GO

SELECT Department, COUNT(TeacherID) AS TotalTeachers
FROM Teachers
GROUP BY Department
ORDER BY TotalTeachers DESC;
GO

SELECT c.ClassName, s.SubjectName, COUNT(ts.TeacherID) AS TeachersCount
FROM Classes c
JOIN ClassSubjects cs ON c.ClassID = cs.ClassID
JOIN Subjects s ON cs.SubjectID = s.SubjectID
LEFT JOIN TeacherSubjects ts ON s.SubjectID = ts.SubjectID
GROUP BY c.ClassName, s.SubjectName
ORDER BY c.ClassName, s.SubjectName;
GO

SELECT t.FullName, s.SubjectName, c.ClassName
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
JOIN Subjects s ON ts.SubjectID = s.SubjectID
JOIN ClassSubjects cs ON s.SubjectID = cs.SubjectID
JOIN Classes c ON cs.ClassID = c.ClassID
ORDER BY t.FullName, c.ClassName;
GO

SELECT s.SubjectName, STRING_AGG(c.ClassName, ', ') AS Classes
FROM Subjects s
JOIN ClassSubjects cs ON s.SubjectID = cs.SubjectID
JOIN Classes c ON cs.ClassID = c.ClassID
GROUP BY s.SubjectName
ORDER BY s.SubjectName;
GO

SELECT Gender, COUNT(*) AS Total
FROM Teachers
GROUP BY Gender;
GO

SELECT TOP 25 t.FullName, COUNT(ts.SubjectID) AS TotalSubjects
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
GROUP BY t.FullName
ORDER BY TotalSubjects DESC;
GO

SELECT TOP 25 s.SubjectName, COUNT(cs.ClassID) AS TotalClasses
FROM Subjects s
JOIN ClassSubjects cs ON s.SubjectID = cs.SubjectID
GROUP BY s.SubjectName
ORDER BY TotalClasses DESC;
GO

SELECT Department, AVG(DATEDIFF(YEAR, DateOfBirth, GETDATE())) AS AvgAge
FROM Teachers
GROUP BY Department;
GO

SELECT FullName, Department, DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
FROM Teachers
WHERE DATEDIFF(YEAR, DateOfBirth, GETDATE()) >= 59;
GO

SELECT c.ClassName,
       COUNT(DISTINCT cs.SubjectID) AS TotalSubjects,
       COUNT(DISTINCT ts.TeacherID) AS TotalTeachers
FROM Classes c
JOIN ClassSubjects cs ON c.ClassID = cs.ClassID
LEFT JOIN TeacherSubjects ts ON cs.SubjectID = ts.SubjectID
GROUP BY c.ClassName;
GO

SELECT t.FullName AS Teacher,
       s.SubjectName AS Subject,
       STRING_AGG(c.ClassName, ', ') AS Classes
FROM Teachers t
JOIN TeacherSubjects ts ON t.TeacherID = ts.TeacherID
JOIN Subjects s ON ts.SubjectID = s.SubjectID
JOIN ClassSubjects cs ON s.SubjectID = cs.SubjectID
JOIN Classes c ON cs.ClassID = c.ClassID
GROUP BY t.FullName, s.SubjectName
ORDER BY t.FullName;
