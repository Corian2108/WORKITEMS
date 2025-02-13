-- Creaci�n de la tabla de Items de Trabajo
CREATE TABLE WorkItems (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    AssignedUser NVARCHAR(100),
    DueDate DATE NOT NULL,
    Priority NVARCHAR(10) CHECK (Priority IN ('Alta', 'Baja')),
    Status NVARCHAR(10) CHECK (Status IN ('Pendiente', 'Completado')) DEFAULT 'Pendiente'
);

--Tabla de Usuarios para referencia
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(255) NOT NULL,
);

--Crear tabla de items pendientes por usuario
CREATE TABLE PendingByUser(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	ItemId INT FOREIGN KEY REFERENCES WorkItems(Id),
	[Order] INT 
);

-- Inserci�n de datos de prueba
INSERT INTO Users (Username) VALUES ('usuario1'), ('usuario2'), ('usuario3'), ('usuario4'), ('usuario5');

INSERT INTO WorkItems (Title, Description, AssignedUser, DueDate, Priority, Status) VALUES
 --Usuario2 con 3 tareas pendientes de alta prioridad
('Tarea 1', 'Descripci�n de tarea 1', 'usuario2', DATEADD(DAY, 5, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 2', 'Descripci�n de tarea 2', 'usuario2', DATEADD(DAY, 2, GETDATE()), 'Baja', 'Pendiente'),
('Tarea 3', 'Descripci�n de tarea 3', 'usuario2', DATEADD(DAY, 7, GETDATE()), 'Alta', 'Pendiente'),
-- Usuario3 con 3 tareas pendientes (1 de alta prioridad y 2 con fecha cercana)
('Tarea 4', 'Descripci�n de tarea 4', 'usuario3', DATEADD(DAY, 3, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 5', 'Descripci�n de tarea 5', 'usuario3', DATEADD(DAY, 2, GETDATE()), 'Baja', 'Pendiente'),
('Tarea 6', 'Descripci�n de tarea 6', 'usuario3', DATEADD(DAY, 1, GETDATE()), 'Baja', 'Pendiente'),
-- Otras tareas con fecha de caducidad cercana
('Tarea 7', 'Descripci�n de tarea 7', 'usuario4', DATEADD(DAY, 2, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 8', 'Descripci�n de tarea 8', 'usuario4', DATEADD(DAY, 3, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 9', 'Descripci�n de tarea 9', 'usuario1', DATEADD(DAY, 2, GETDATE()), 'Baja', 'Pendiente'),
('Tarea 10', 'Descripci�n de tarea 10', 'usuario5', DATEADD(DAY, 1, GETDATE()), 'Baja', 'Pendiente'),
('Tarea 11', 'Descripci�n de tarea 11', NULL, DATEADD(DAY, 2, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 12', 'Descripci�n de tarea 12', NULL, DATEADD(DAY, 2, GETDATE()), 'Alta', 'Pendiente'),
 --Tareas con fechas de caducidad superior a 3 d�as
('Tarea 13', 'Descripci�n de tarea 13', NULL, DATEADD(DAY, 4, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 14', 'Descripci�n de tarea 14', NULL, DATEADD(DAY, 5, GETDATE()), 'Alta', 'Pendiente'),
('Tarea 15', 'Descripci�n de tarea 15', NULL, DATEADD(DAY, 4, GETDATE()), 'Baja', 'Pendiente'),
('Tarea 16', 'Descripci�n de tarea 16', NULL, DATEADD(DAY, 6, GETDATE()), 'Baja', 'Pendiente');

truncate table workitems

SELECT * FROM WorkItems