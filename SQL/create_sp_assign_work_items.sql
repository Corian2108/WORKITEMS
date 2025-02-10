SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Agustin Ruiz
-- Create date: 08/02/2025
-- Description:	Asignación automática de tareas según la prioridad y fecha de caducidad.
-- =============================================
CREATE PROCEDURE SP_Assign_Work_Items 
AS
BEGIN

	SET NOCOUNT ON;
	
    -- Asignar ítems relevantes primero
    UPDATE w
    SET AssignedUser = u.Username
    FROM WorkItems w
    CROSS APPLY (
        SELECT TOP 1 Username
        FROM Users u
        WHERE (SELECT COUNT(*) FROM WorkItems wi WHERE wi.AssignedUser = u.Username AND wi.Status = 'Pendiente' AND wi.Priority = 'Alta') < 3
        ORDER BY (SELECT COUNT(*) FROM WorkItems wi WHERE wi.AssignedUser = u.Username AND wi.Status = 'Pendiente') ASC
    ) u
    WHERE w.AssignedUser IS NULL AND w.Priority = 'Alta';

	 -- Asignar items con fecha próxima a vencer
    UPDATE w
    SET AssignedUser = u.Username
    FROM WorkItems w
    CROSS APPLY (
        SELECT TOP 1 Username
        FROM Users u
        WHERE (SELECT COUNT(*) FROM WorkItems wi WHERE wi.AssignedUser = u.Username AND wi.Status = 'Pendiente') < 3
        ORDER BY (SELECT COUNT(*) FROM WorkItems wi WHERE wi.AssignedUser = u.Username AND wi.Status = 'Pendiente') ASC
    ) u
    WHERE w.DueDate <= DATEADD(DAY, 3, GETDATE()) AND w.AssignedUser IS NULL;

END
GO
