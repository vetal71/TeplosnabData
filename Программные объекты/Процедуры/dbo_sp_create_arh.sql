SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_create_arh] 
	@data datetime
AS
	-- Проверяем дату и если это начало года, 
		-- тогда сбрасываем начисления в архив
		DECLARE @s_year datetime
		SET @s_year = convert(datetime,'1/1/'+convert(char(4),year(@data)),101)

			INSERT INTO arh_datadoma
				SELECT * FROM datadoma
				WHERE datan < @s_year
			INSERT INTO arh_datakvart
				SELECT * FROM datakvart
				WHERE datan < @s_year
			INSERT INTO arh_dataobekt
				SELECT * FROM dataobekt
				WHERE datan < @s_year
			DELETE FROM datadoma
				WHERE datan < @s_year
			DELETE FROM datakvart
				WHERE datan < @s_year
			DELETE FROM dataobekt
				WHERE datan < @s_year
			UPDATE paramorg
				SET arh_data = @s_year-1



GO