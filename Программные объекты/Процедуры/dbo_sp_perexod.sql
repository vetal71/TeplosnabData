SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE           PROCEDURE [dbo].[sp_perexod]
	@oper int, @data datetime -- Начало текущего периода	
AS
	DECLARE @add_rec int
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N't_upnewmonth' 
	  AND 	 type = 'U')
    DROP TABLE t_upnewmonth
		CREATE TABLE t_upnewmonth
		(nazv char(100),cnt_rec int,cnt_uprec int)
	
	IF @oper = 2 -- Обновление нового месяца
	BEGIN
		-- Организации
		SELECT @add_rec = count(*) FROM org
			 	WHERE kodorg NOT IN 
				(SELECT kodorg FROM dataorg WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по организациям',count(*),@add_rec
				FROM org
		INSERT INTO dataorg (kodorg,datan,datak)
				SELECT kodorg,@data,teplosnab.dbo.end_of_month(@data) FROM org
				WHERE kodorg NOT IN (SELECT kodorg FROM dataorg WHERE datan=@data)		
		-- Объекты
		SELECT @add_rec = count(*) FROM obekt
			 	WHERE kodobk NOT IN 
				(SELECT kodobk FROM dataobekt WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по объектам',count(*),@add_rec
				FROM obekt
		INSERT INTO dataobekt (kodobk,kybv,kybk,kybg,datan,datak)
				SELECT kodobk,qv,qk,qg,@data,teplosnab.dbo.end_of_month(@data) FROM obekt
				WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE datan=@data)
		-- Дома
		SELECT @add_rec = count(*) FROM doma
			 	WHERE koddom NOT IN 
				(SELECT koddom FROM datadoma WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по домам',count(*),@add_rec
				FROM doma
		INSERT INTO datadoma (koddom,datan,datak)
				SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) FROM doma
				WHERE koddom NOT IN (SELECT koddom FROM datadoma WHERE datan=@data)	
		-- Участки
		SELECT @add_rec = count(*) FROM koteln
			 	WHERE kodkot NOT IN 
				(SELECT kodkot FROM datakoteln WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по участкам',count(*),@add_rec
				FROM koteln
		INSERT INTO datakoteln (kodkot,datan,datak)
				SELECT kodkot,@data,teplosnab.dbo.end_of_month(@data) FROM koteln
				WHERE kodkot NOT IN (SELECT kodkot FROM datakoteln WHERE datan=@data)
		-- Приборы
		SELECT @add_rec = count(*) FROM pribor
			 	WHERE kod NOT IN 
				(SELECT kodpr FROM dataprib WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по приборам',count(*),@add_rec
				FROM pribor
		INSERT INTO dataprib (kodpr,datan,datak)
				SELECT kod,@data,teplosnab.dbo.end_of_month(@data) FROM pribor
				WHERE kod NOT IN (SELECT kodpr FROM dataprib WHERE datan=@data)
		-- Тарифы тепло
		SELECT @add_rec = count(*) FROM tarift
			 	WHERE kodtt NOT IN 
				(SELECT kodtt FROM datatarif WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по тарифам (тепло)',count(*),@add_rec
				FROM tarift
		INSERT INTO datatarif (kodtt,datan,datak)
				SELECT kodtt,@data,teplosnab.dbo.end_of_month(@data) FROM tarift
				WHERE kodtt NOT IN (SELECT kodtt FROM datatarif WHERE datan=@data)
		-- Тарифы вода
		SELECT @add_rec = count(*) FROM tarifv
			 	WHERE kodtv NOT IN 
				(SELECT kodtv FROM datatarifv WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по тарифам (вода)',count(*),@add_rec
				FROM tarifv
		INSERT INTO datatarifv (kodtv,datan,datak)
				SELECT kodtv,@data,teplosnab.dbo.end_of_month(@data) FROM tarifv
				WHERE kodtv NOT IN (SELECT kodtv FROM datatarifv WHERE datan=@data)
        -- Тарифы мусор
		SELECT @add_rec = count(*) FROM tarifg
			 	WHERE kodtg NOT IN 
				(SELECT kodtg FROM datatarifg WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Обновление данных по тарифам (мусор)',count(*),@add_rec
				FROM tarifg
		INSERT INTO datatarifg (kodtg,datan,datak)
				SELECT kodtg,@data,teplosnab.dbo.end_of_month(@data) FROM tarifg
				WHERE kodtg NOT IN (SELECT kodtg FROM datatarifg WHERE datan=@data)        
	END
	IF @oper = 1 -- Переход на новый месяц
	BEGIN
		-- Проверяем дату и если это начало года, 
		-- тогда сбрасываем начисления в архив
		DECLARE @s_year datetime, @l_data datetime -- Прошлый месяц
		SET @l_data = dateadd(month,-1,@data)
		SET @s_year = convert(datetime,'1/1/'+convert(char(4),year(@data)),101)
		
		-- Организации
		SELECT @add_rec = count(*) FROM org
			 	WHERE kodorg NOT IN 
				(SELECT kodorg FROM dataorg WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по организациям',count(*),@add_rec
				FROM org
		INSERT INTO dataorg (kodorg,datan,datak)
				SELECT kodorg,@data,teplosnab.dbo.end_of_month(@data) FROM org
				WHERE kodorg NOT IN (SELECT kodorg FROM dataorg WHERE datan=@data)		
		-- Объекты
		SELECT @add_rec = count(*) FROM obekt
			 	WHERE kodobk NOT IN 
				(SELECT kodobk FROM dataobekt WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по объектам',count(*),@add_rec
				FROM obekt
		INSERT INTO dataobekt (kodobk,kybv,kybk,kybg,datan,datak)
				SELECT kodobk,qv,qk,qg,@data,teplosnab.dbo.end_of_month(@data) FROM obekt
				WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE datan=@data)
		-- Дома
		SELECT @add_rec = count(*) FROM doma
			 	WHERE koddom NOT IN 
				(SELECT koddom FROM datadoma WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по домам',count(*),@add_rec
				FROM doma
		INSERT INTO datadoma (koddom,datan,datak)
				SELECT koddom,@data,teplosnab.dbo.end_of_month(@data) FROM doma
				WHERE koddom NOT IN (SELECT koddom FROM datadoma WHERE datan=@data)	
		-- Участки
		SELECT @add_rec = count(*) FROM koteln
			 	WHERE kodkot NOT IN 
				(SELECT kodkot FROM datakoteln WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по участкам',count(*),@add_rec
				FROM koteln
		INSERT INTO datakoteln (kodkot,datan,datak)
				SELECT kodkot,@data,teplosnab.dbo.end_of_month(@data) FROM koteln
				WHERE kodkot NOT IN (SELECT kodkot FROM datakoteln WHERE datan=@data)
		-- Приборы
		SELECT @add_rec = count(*) FROM pribor
			 	WHERE kod NOT IN 
				(SELECT kodpr FROM dataprib WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по приборам',count(*),@add_rec
				FROM pribor
		INSERT INTO dataprib (kodpr,datan,datak)
				SELECT kod,@data,teplosnab.dbo.end_of_month(@data) FROM pribor
				WHERE kod NOT IN (SELECT kodpr FROM dataprib WHERE datan=@data)
		-- Тарифы тепло
		SELECT @add_rec = count(*) FROM tarift
			 	WHERE kodtt NOT IN 
				(SELECT kodtt FROM datatarif WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по тарифам (тепло)',count(*),@add_rec
				FROM tarift
		INSERT INTO datatarif (kodtt,cena,datan,datak)
				SELECT kodtt,cena,@data,teplosnab.dbo.end_of_month(@data) FROM datatarif
				WHERE kodtt NOT IN (SELECT kodtt FROM datatarif WHERE datan=@data)
				and datan = @l_data
		-- Тарифы вода
		SELECT @add_rec = count(*) FROM tarifv
			 	WHERE kodtv NOT IN 
				(SELECT kodtv FROM datatarifv WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по тарифам (вода)',count(*),@add_rec
				FROM tarifv
		INSERT INTO datatarifv (kodtv,cenav,cenak,datan,datak)
				SELECT kodtv,cenav,cenak,@data,teplosnab.dbo.end_of_month(@data) FROM datatarifv
				WHERE kodtv NOT IN (SELECT kodtv FROM datatarifv WHERE datan=@data)
				and datan = @l_data
        -- Тарифы мусор
		SELECT @add_rec = count(*) FROM tarifg
			 	WHERE kodtg NOT IN 
				(SELECT kodtg FROM datatarifg WHERE datan = @data)
		INSERT INTO t_upnewmonth
				SELECT 'Добавление данных по тарифам (мусор)',count(*),@add_rec
				FROM tarifg
		INSERT INTO datatarifg (kodtg,cenag,datan,datak)
				SELECT kodtg,cenag,@data,teplosnab.dbo.end_of_month(@data) FROM datatarifg
				WHERE kodtg NOT IN (SELECT kodtg FROM datatarifg WHERE datan=@data)
				and datan = @l_data        
	END
GO