SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[up_kvart_podklgv]	
AS
	DECLARE @kod int
	DECLARE cur_dom CURSOR 
	FOR 
		SELECT koddom from doma where podklgv=0
	OPEN cur_dom
	FETCH NEXT FROM cur_dom INTO @kod
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
			-- Обновляем записи по квартирам
			update kvart set podklgv=0 where koddom=@kod
		  FETCH NEXT FROM cur_dom INTO @kod
		END
	DEALLOCATE cur_dom
	------------------------------------------------- 
	DECLARE cur_dom CURSOR 
	FOR 
		SELECT koddom from doma where podklgv=1
	OPEN cur_dom
	FETCH NEXT FROM cur_dom INTO @kod
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
			-- Обновляем записи по квартирам
			update kvart set podklgv=1 where koddom=@kod
		  FETCH NEXT FROM cur_dom INTO @kod
		END
	DEALLOCATE cur_dom


GO