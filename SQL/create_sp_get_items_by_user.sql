USE [WORKITEMS]
GO
/****** Object:  StoredProcedure [dbo].[sp_get_items_by_user]    Script Date: 13/2/2025 0:00:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Agustin Ruiz
-- Create date: 12/02/2025
-- Description:	Permite verificar la cantidad de items pendientes y completados de cualquier usuario en cualquier momento
--  =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_get_items_by_user]
	
	@USER NVARCHAR(MAX)

AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @USERNAME VARCHAR(20)

	SELECT @USERNAME = Username
	FROM OPENJSON(@USER) WITH (Username VARCHAR(20))

	SELECT wi.Id AS Id, wi.Title AS Title, wi.[Description] AS [Description], wi.AssignedUser AS [User], 
	wi.DueDate AS [Date], wi.[Priority] AS [Priority], wi.[Status] AS [Status]
	FROM WorkItems wi
	LEFT JOIN PendingByUser p
	ON p.ItemId = wi.Id
	WHERE wi.AssignedUser = @USERNAME
	ORDER BY p.[Order], wi.DueDate, wi.[Priority]
	FOR JSON PATH, INCLUDE_NULL_VALUES

END
