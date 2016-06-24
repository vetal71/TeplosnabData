SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[yes_no]
	(@param int)
RETURNS char(3)
AS
BEGIN
	DECLARE @otvet char(3)
	IF (@param = 0)
		SET @otvet = 'Да'
	ELSE
		SET @otvet = 'Нет'
	RETURN @otvet
END

GO