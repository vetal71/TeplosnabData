SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE     PROCEDURE [dbo].[sp_VerifyTemper]
	@data1 datetime, @data2 datetime,
	@str varchar(1000) output,@kol int output
AS
	DECLARE @den int
	DECLARE @cnt int
	SET @str = 'отсутствуют данные по температуре за '
	SET @den = DAY(@data1)
	SET @kol = 0
	WHILE @den <= DAY(@data2)
	BEGIN
		SET @cnt = 0
		SELECT @cnt = count(*) FROM temper
		WHERE data = DATEADD(DAY,@den-DAY(@data1),@data1) and srt Is Not Null
		IF @cnt = 0 
		BEGIN			
			SET @str = rtrim(@str+cast(@den as varchar(2))+',')
			SET @kol = @kol + 1
		END
		SET @den = @den + 1		
	END



GO