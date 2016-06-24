SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[end_month]
	(@data datetime)
RETURNS datetime
AS
BEGIN
	declare @data2 datetime,
  @god integer,
  @mes integer,
  @den integer
  set @god=year(@data)
  set @mes=month(@data)+1
  set @den=1
  set @data2 = convert(datetime,cast(@den as char(2))+'.'
							 +cast(@mes as char(2))+'.'+cast(@god as char(4)))-1
  return @data2
END
GO