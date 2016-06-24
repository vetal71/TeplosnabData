SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_avg_temp] 
	@data1 datetime, @data2 datetime, 
	@c_day integer output,@c_tmp decimal(5,1) output
AS
	SELECT @c_day = count(data), @c_tmp = avg(srt) FROM temper
		WHERE data BETWEEN @data1 and @data2 
GO