SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[sf_prj_pr]
	(@kod int)
RETURNS integer
AS
BEGIN	
	DECLARE @rezult int
	DECLARE @prj_obk int, @prj_dom int
	-- Ищем по объектам
	SELECT @prj_obk = ISNULL(SUM(prj+prjl),0) FROM obekt 
		WHERE kodpr = @kod AND podkl = 0
	-- Ищем по домам
	SELECT @prj_dom = ISNULL(SUM(prj),0) FROM doma
		WHERE kodpr = @kod AND podkl = 0
	IF @prj_obk + @prj_dom = 0
		SET @rezult = 1
	ELSE 
		SET @rezult = @prj_obk + @prj_dom
	RETURN @rezult	
END

GO