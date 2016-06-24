SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE         PROCEDURE [dbo].[sp_calc_prib] 
	@kod int, @kod_kot int = 0, @data datetime
AS
	SET NOCOUNT ON
	DECLARE @id_pr int, @gkt decimal(15,2),@gkv decimal(15,2)
	-- Проверяем чему равен код
	IF @kod = 0 
	BEGIN
		-- Расчет всех приборов учета				
		DECLARE cur_prib CURSOR 
		FOR
			SELECT kodpr,gkt,gkv FROM dataprib WHERE gkt+gkv>0 and datan = @data
		OPEN cur_prib	
		FETCH NEXT FROM cur_prib INTO @id_pr,@gkt,@gkv
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
/*Начало расчета всех приборов*/
			-- Добавляем объекты по данному прибору
			INSERT INTO dataobekt (kodobk, kybk, kybv, datan, datak)
			SELECT kodobk, qk, qv, @data, teplosnab.dbo.end_of_month(@data) 
			FROM obekt 
			WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE
			datan = @data) and kodpr = @id_pr

			-- Обновляем объекты
			UPDATE dataobekt 
			SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@id_pr)*b.q,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@id_pr)*(b.prj+b.prjl),2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM dataobekt a, obekt b 
				WHERE a.kodobk = b.kodobk AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @id_pr
			-- Добавляем дома по данному прибору
			INSERT INTO datadoma (koddom,datan,datak)
			SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) FROM doma
			WHERE koddom NOT IN (SELECT koddom FROM datadoma WHERE datan=@data)
			and kodpr = @id_pr

			-- Обновляем дома
			UPDATE datadoma
			SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@id_pr)*b.qot,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@id_pr)*b.prj,2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM datadoma a, doma b 
				WHERE a.koddom = b.koddom AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @id_pr
		  FETCH NEXT FROM cur_prib INTO @id_pr,@gkt,@gkv
		END
		DEALLOCATE cur_prib
/*Конец расчета всех приборов*/
	END
	IF @kod = -1 
	BEGIN
		-- Расчет всех приборов учета	по котельной			
		DECLARE cur_prib CURSOR 
		FOR
			SELECT a.kodpr,a.gkt,a.gkv FROM dataprib a, pribor b 
				WHERE a.gkt+a.gkv>0 and b.kodkot=@kod_kot and a.datan = @data
		OPEN cur_prib	
		FETCH NEXT FROM cur_prib INTO @id_pr,@gkt,@gkv
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
/*Начало расчета всех приборов*/
			-- Добавляем объекты по данному прибору
			INSERT INTO dataobekt (kodobk, kybk, kybv, datan, datak)
			SELECT kodobk, qk, qv, @data, teplosnab.dbo.end_of_month(@data) 
			FROM obekt 
			WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE
			datan = @data) and kodpr = @id_pr
			-- Обновляем объекты
			UPDATE dataobekt 
			SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@id_pr)*b.q,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@id_pr)*(b.prj+b.prjl),2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM dataobekt a, obekt b 
				WHERE a.kodobk = b.kodobk AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @id_pr
			-- Добавляем дома по данному прибору
			INSERT INTO datadoma (koddom,datan,datak)
			SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) FROM doma
			WHERE koddom NOT IN (SELECT koddom FROM datadoma WHERE datan=@data)
			and kodpr = @id_pr
			-- Обновляем дома
			UPDATE datadoma
			SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@id_pr)*b.qot,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@id_pr)*b.prj,2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM datadoma a, doma b 
				WHERE a.koddom = b.koddom AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @id_pr
		  FETCH NEXT FROM cur_prib INTO @id_pr,@gkt,@gkv
		END
		DEALLOCATE cur_prib
	END
	IF @kod > 1 
	BEGIN
		print 'First'
		-- Расчет одного прибора
		SELECT @gkt = gkt,@gkv = gkv FROM dataprib WHERE datan = @data and kodpr=@kod
		print 'Second'	
		-- Обновляем объекты
		INSERT INTO dataobekt (kodobk, kybk, kybv, datan, datak)
			SELECT kodobk, qk, qv, @data, teplosnab.dbo.end_of_month(@data) 
			FROM obekt 
			WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE
			datan = @data) and kodpr = @kod
		print 'Общая площадь '+cast(teplosnab.dbo.sf_q_pr(@kod) as varchar(15))
		UPDATE dataobekt 
		  SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@kod)*b.q,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@kod)*(b.prj+b.prjl),2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM dataobekt a, obekt b 
				WHERE a.kodobk = b.kodobk AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @kod
		-- Добавляем дома по данному прибору
			INSERT INTO datadoma (koddom,datan,datak)
			SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) FROM doma
			WHERE koddom NOT IN (SELECT koddom FROM datadoma WHERE datan=@data)
			and kodpr = @kod
		-- Обновляем дома
		UPDATE datadoma
			SET gkt = ROUND(@gkt/teplosnab.dbo.sf_q_pr(@kod)*b.qot,2),
					gkv = ROUND(@gkv/teplosnab.dbo.sf_prj_pr(@kod)*b.prj,2),
					st = teplosnab.dbo.iif(@gkt,0,1,0),sv = teplosnab.dbo.iif(@gkv,0,1,0)
			FROM datadoma a, doma b 
				WHERE a.koddom = b.koddom AND a.datan = @data AND b.podkl=0 
				AND b.kodpr = @kod
	END	
	
	IF (@kod = 0) OR (@kod = -1)
	BEGIN
		-- Вызываем процедуру расчета Гкал по квартирам
		EXECUTE sp_calc_kv @data 
		print 'Просчитали квартиры'
		-- Вызываем процедуру расчета Гкал по объектам (суммируя по квартирам)
		EXECUTE sp_calc_kv_obk @data
		print 'Просчитали квартиры по объектам'
	END	

-- Вызываем процедуру расчета сумм по объектам
	EXECUTE sp_calc_obk @data
	print 'Просчитали объекты'
	-- Вызываем процедуру подсчета сумм по организациям
	EXECUTE sp_calc_org @data
	print 'Просчитали организации'
	SET NOCOUNT OFF




GO