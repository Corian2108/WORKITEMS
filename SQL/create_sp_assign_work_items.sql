USE [WORKITEMS]
GO
/****** Object:  StoredProcedure [dbo].[SP_Assign_Work_Items]    Script Date: 12/2/2025 20:33:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Agustin Ruiz
-- Create date: 08/02/2025
-- Description:	Asignación automática de tareas según la prioridad y fecha de caducidad. V2
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[SP_Assign_Work_Items] 
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @COUNT INT, @MAXITEMID INT, @USERNAME VARCHAR(20);
	DECLARE @ITEMS TABLE (ID INT IDENTITY(1,1), ITEMID INT, [PRIORITY] VARCHAR(20), DUEDATE DATE)

	--Primero se extrae los items que no han sido asignados, ordenando por su fecha de caducidad y su prioridad
	INSERT INTO @ITEMS (ITEMID, PRIORITY, DUEDATE)
	SELECT wi.Id, wi.Priority, wi.DueDate
	FROM WORKITEMS wi
	WHERE wi.Status = 'Pendiente'
	AND wi.AssignedUser IS NULL
	ORDER BY DueDate, [Priority] ASC

	SET @COUNT = (SELECT MIN(i.ID)
					FROM @ITEMS I)

	SET @MAXITEMID = (SELECT MAX(i.ID)
						FROM @ITEMS I)

	--Se asigna los items uno por uno empezando por los que tienen menor craga de trabajo 
	WHILE @COUNT <= @MAXITEMID
	BEGIN
		BEGIN TRAN

			--En cada iteración se selecciona el usuario con menor carga que no esté saturado
			SET @USERNAME = (SELECT TOP 1 Username
								FROM Users u
								WHERE (SELECT COUNT(*) FROM WorkItems wi 
										WHERE wi.AssignedUser = u.Username 
										AND wi.Status = 'Pendiente'
										AND wi.Priority = 'Alta') < 3
								ORDER BY (SELECT COUNT(*) FROM WorkItems wi 
											WHERE wi.AssignedUser = u.Username 
											AND wi.Status = 'Pendiente') ASC)

			UPDATE wi
			SET wi.AssignedUser = @USERNAME
			FROM WorkItems wi
			WHERE wi.Id = (SELECT I.ITEMID FROM @ITEMS I WHERE I.ID = @COUNT)

			--Después de cada asignación se ordena la lista de pendientes del usuario por su fecha y relevancia
			DECLARE @PENDINGITEMS TABLE (ID INT IDENTITY(1,1), ITEMID INT, [PRIORITY] VARCHAR(20), DUEDATE DATE)

			INSERT INTO @PENDINGITEMS (ITEMID, PRIORITY, DUEDATE)
			SELECT wi.Id, wi.Priority, wi.DueDate
			FROM WORKITEMS wi
			WHERE wi.Status = 'Pendiente'
			AND wi.AssignedUser = @USERNAME
			ORDER BY [Priority], DueDate ASC

			--Borro el orden actual para mantener la limpieza de la tabla
			DELETE FROM PendingByUser
			WHERE ItemId IN (SELECT ITEMID FROM @PENDINGITEMS)

			INSERT INTO PendingByUser (ItemId, [Order])
			SELECT P.ITEMID, P.ID
			FROM @PENDINGITEMS P

			SET @COUNT = @COUNT+1

		COMMIT TRAN
	END

	--Borro los items completados de la tabla de ordenamiento para mantener la limpieza
	DELETE FROM PendingByUser
	WHERE ItemId IN (SELECT wi.Id FROM WorkItems wi WHERE wi.Status = 'Completado')

END
