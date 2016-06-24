SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_q_pr]
	@kod integer, @qot integer output, @tvn integer output	
AS
	DECLARE @q_obk int,@q_dom int,@tvn_obk int,@tvn_dom int,@cnt int

	SELECT @q_obk = ISNULL(sum(q),0), @tvn_obk = ISNULL(avg(t),0) from obekt where kodpr=@kod
	SELECT @q_dom = ISNULL(sum(qot),0),@cnt = count(*) from doma where kodpr=@kod
	IF @cnt>0 
		SET @tvn_dom = 18
	ELSE
		SET @tvn_dom = 0
	SET @qot = @q_obk + @q_dom
	SELECT @tvn = AVG(FLOOR(@tvn_obk)+@tvn_dom)

GO