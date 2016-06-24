SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[DEL_OBJ]
@tab_name varchar(15),
@col_name varchar(20),
@init_vol int
AS
EXEC ('DELETE FROM  ' + @tab_name+'  WHERE  '+@col_name+'='+@init_vol)
GO