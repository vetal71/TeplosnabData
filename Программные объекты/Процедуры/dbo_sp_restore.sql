SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_restore]
AS	
	RESTORE DATABASE Teplosnab
		FROM DISK = N'd:\teplosnab\backup\teplosnab.bak'
		WITH RECOVERY




GO