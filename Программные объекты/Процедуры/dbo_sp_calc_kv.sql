SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE          PROCEDURE [dbo].[sp_calc_kv]
	@data datetime	
AS	
	DECLARE @id_dom int,@gkt decimal(15,2),@gkv decimal(15,2),
	@not decimal(15,5),@ngv decimal(15,5),
	@so decimal(15,2),@prj int,@cnt int
	SET @cnt = 0
	DECLARE cur_dom CURSOR 
		FOR SELECT a.koddom,a.gkt,a.gkv,a.normativ,a.normativgv,
				teplosnab.dbo.IIF(b.so,0,1,b.so),
				teplosnab.dbo.IIF(b.prj,0,1,b.prj) 
				FROM datadoma a, doma b 
				WHERE a.koddom = b.koddom and a.gkt+a.gkv<>0 and a.datan = @data
	OPEN cur_dom	
	FETCH NEXT FROM cur_dom INTO @id_dom,@gkt,@gkv,@not,@ngv,@so,@prj
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		-- Обновляем площадь дома
		UPDATE doma
		SET
			so = (SELECT ISNULL(SUM(so),0) from kvart WHERE koddom = @id_dom and podkl = 0)
		WHERE koddom = @id_dom

		INSERT INTO datakvart (kodkv,datan,datak)
			SELECT kodkv,@data,teplosnab.dbo.end_of_month(@data) FROM kvart
			WHERE kodkv NOT IN (SELECT kodkv FROM datakvart WHERE datan=@data)
			and koddom = @id_dom

		-- Обновляем Гкал по квартирам
		UPDATE datakvart
		SET gkt=ROUND(@gkt/@so*d.so,2),
				gkv=ROUND(@gkv/@prj*d.prj,2),
				normativ=@not,normativgv=@ngv
		FROM
    	kvart as d join datakvart as b on d.kodkv=b.kodkv
    	WHERE d.koddom=@id_dom and b.datan=@data
		PRINT 'обновили данные'		
		set @cnt = @cnt + 1
		FETCH NEXT FROM cur_dom INTO @id_dom,@gkt,@gkv,@not,@ngv,@so,@prj
	END
	DEALLOCATE cur_dom
	
	PRINT 'Обработано '+cast(@cnt as varchar)+' домов'








GO