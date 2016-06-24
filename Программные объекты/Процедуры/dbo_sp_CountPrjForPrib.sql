SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_CountPrjForPrib]
	@kod integer, @cnt integer output	
AS
	DECLARE @cnt_obk int,@cnt_dom int
	SELECT @cnt_obk = ISNULL(sum(prj+prjl),0) 
		FROM obekt WHERE kodpr = @kod
	SELECT @cnt_dom = ISNULL(sum(prj),0) 
		FROM doma WHERE kodpr = @kod
	SET @cnt = @cnt_obk + @cnt_dom
GO