SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[sp_run_script]
AS
	SET NOCOUNT ON
	DECLARE @error int
	DECLARE @SQL varchar(1000)
	set @SQL = 'isql -S ADMIN -d teplosnab -U admin - P 00 -i "d:\teplosnab\temp\cr_arh.sql" -n'
	EXEC @error = master..xp_cmdshell @SQL
	if (@error != 0) 
		print 'Скрипт не выполнен'
	else 
		print 'Скрипт выполнен'	


GO