SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE     PROCEDURE [dbo].[sp_calc_kv_obk]
	@data datetime
AS
	DECLARE @id_obk int,@gkt decimal(15,2),@gkv decimal(15,2)
	DECLARE cur_kv CURSOR 
		FOR SELECT b.kodobk,ISNULL(SUM(a.gkt),0),ISNULL(SUM(a.gkv),0) FROM datakvart a,kvart b
		WHERE a.kodkv = b.kodkv and (a.gkt+a.gkv)<>0 and a.datan = @data
		GROUP BY kodobk
	OPEN cur_kv	
	FETCH NEXT FROM cur_kv INTO @id_obk,@gkt,@gkv
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN 
		-- Анализируем данные
		IF (SELECT count(*) FROM dataobekt 
							 WHERE kodobk = @id_obk AND datan = @data) = 0
		INSERT INTO dataobekt (kodobk,kybv,kybk,datan,datak)
			SELECT kodobk,qv,qk,@data,teplosnab.dbo.end_of_month(@data) 
				FROM obekt WHERE kodobk = @id_obk
		-- Обновляем данные
		UPDATE dataobekt 
		SET gkt=@gkt,gkv=@gkv 
		WHERE kodobk=@id_obk and datan=@data
		FETCH NEXT FROM cur_kv INTO @id_obk,@gkt,@gkv
	END
	DEALLOCATE cur_kv




GO