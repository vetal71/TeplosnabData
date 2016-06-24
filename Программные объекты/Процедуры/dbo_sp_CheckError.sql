SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE    PROCEDURE [dbo].[sp_CheckError] 
AS
	DECLARE @table char(10)
	DECLARE @sql_where char(20)
	-- Объявляем курсор
	DECLARE err_cursor CURSOR 
	FOR
		SELECT tablename_err, filter_sql FROM temp_err WHERE tip_err LIKE 'Нарушена связь'
	OPEN err_cursor			
		FETCH NEXT FROM err_cursor INTO @table,@sql_where
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
			-- Удаляем кривые записи
			EXEC ('DELETE FROM '+@table+' WHERE '+@sql_where)
		  FETCH NEXT FROM err_cursor INTO @table,@sql_where
		END
	DEALLOCATE err_cursor	
	-- Удаляем ошибки из таблицы
	DELETE FROM temp_err WHERE tip_err LIKE 'Нарушена связь'


GO