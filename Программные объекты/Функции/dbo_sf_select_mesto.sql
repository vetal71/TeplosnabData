SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[sf_select_mesto]
	(@mesto int)
RETURNS char(5) 
AS
BEGIN
	DECLARE @rasp char(5)
	IF (@mesto = 1)
		SET @rasp = 'ГОРОД'
	ELSE
		SET @rasp = 'СЕЛО'
	RETURN @rasp
END	
GO