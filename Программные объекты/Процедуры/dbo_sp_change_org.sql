SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_change_org] 
	@kodorg integer, @kodobk integer
AS
	UPDATE obekt 
	SET kodorg = @kodorg WHERE kodobk = @kodobk
GO