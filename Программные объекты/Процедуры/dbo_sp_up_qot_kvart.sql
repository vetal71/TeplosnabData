SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_up_qot_kvart]
	@qs float, @koddom int
AS
	update kvart set qot=round(so*@qs,0) where koddom=@koddom

GO