SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_calc_kv_dom]
@data datetime
AS
	DECLARE @id_obk int,@gkt decimal(15,2),@gkv decimal(15,2)
	DECLARE cur_kv CURSOR 
		FOR SELECT b.koddom,ISNULL(SUM(a.gkt),0),ISNULL(SUM(a.gkv),0) FROM datakvart a,kvart b
		WHERE a.kodkv = b.kodkv and (a.gkt+a.gkv)<>0 and a.datan = @data
		GROUP BY koddom
	OPEN cur_kv	
	FETCH NEXT FROM cur_kv INTO @id_obk,@gkt,@gkv
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN 
		-- Анализируем данные
		IF (SELECT count(*) FROM datadoma 
							 WHERE koddom = @id_obk AND datan = @data) = 0
		INSERT INTO datadoma (koddom,datan,datak)
			SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) 
				FROM doma WHERE koddom = @id_obk
		-- Обновляем данные
		UPDATE datadoma 
		SET gkt=@gkt,gkv=@gkv 
		WHERE koddom=@id_obk and datan=@data
		FETCH NEXT FROM cur_kv INTO @id_obk,@gkt,@gkv
	END
	DEALLOCATE cur_kv

GO