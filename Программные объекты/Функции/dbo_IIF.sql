SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[IIF] 
	(@check_exp real, @check_val real,@return_value1 real, @return_value2 real)
RETURNS real 
AS
BEGIN
	DECLARE @rez real
	IF @check_exp = @check_val
		SET @rez = @return_value1
	ELSE
		SET @rez = @return_value2
	RETURN @rez
END
GO