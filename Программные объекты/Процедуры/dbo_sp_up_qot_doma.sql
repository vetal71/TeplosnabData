SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE   PROCEDURE [dbo].[sp_up_qot_doma]
	@koddom int
AS
	update doma set qot = (select sum(qot) from kvart where koddom=@koddom),
		so = (select sum(so) from kvart where koddom=@koddom)
	 where koddom=@koddom



GO