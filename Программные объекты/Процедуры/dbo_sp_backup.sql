SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_backup]
AS
	DECLARE @str_date varchar(100)
	SET @str_date = CONVERT(nvarchar(50),getdate(),120)
	BACKUP DATABASE Teplosnab
		TO DISK = 'd:\teplosnab\backup\teplosnab.bak'
		WITH INIT, NOUNLOAD, NAME = @str_date, NOFORMAT




GO