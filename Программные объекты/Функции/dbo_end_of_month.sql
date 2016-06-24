SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[end_of_month]
	(@data datetime)
RETURNS datetime 
AS
begin
  declare @data2 datetime
  set @data2 = dateadd(month,1,dateadd(day,1-day(@data),@data))-1 
  return(@data2)
end	

GO