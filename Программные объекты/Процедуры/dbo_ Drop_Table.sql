SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ Drop_Table] AS
DECLARE tables_cursor CURSOR
   FOR
   SELECT name FROM sysobjects WHERE type = 'U'
OPEN tables_cursor
DECLARE @tablename sysname
FETCH NEXT FROM tables_cursor INTO @tablename
WHILE (@@FETCH_STATUS <> -1)
BEGIN
   /* A @@FETCH_STATUS of -2 means that the row has been deleted.
   There is no need to test for this because this loop drops all
   user-defined tables.   */
   EXEC ('DROP TABLE ' + @tablename)
   FETCH NEXT FROM tables_cursor INTO @tablename
END
PRINT 'All user-defined tables have been dropped from the database.'
DEALLOCATE tables_cursor
GO