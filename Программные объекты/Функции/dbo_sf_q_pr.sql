SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE    FUNCTION [dbo].[sf_q_pr] (@kod int)
RETURNS decimal(15,2) 
AS
BEGIN
	DECLARE @rezult decimal(15,2)
	DECLARE @q_obk int, @q_dom int, @s_obk decimal(15,2), @s_dom decimal(15,2)
	-- Ищем по объектам
	SELECT @q_obk = ISNULL(SUM(q),0) FROM obekt 
		WHERE kodpr = @kod AND podkl = 0
	-- Ищем по домам
	SELECT @q_dom = ISNULL(SUM(qot),0) FROM doma
		WHERE kodpr = @kod AND podkl = 0
	IF @q_obk + @q_dom = 0 
		SET @rezult = 1
	ELSE
		SET @rezult = @q_obk + @q_dom
	RETURN @rezult
END	



GO