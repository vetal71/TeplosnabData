SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_ras_g] 
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_vk' 
	  AND 	 type = 'U')
    DROP TABLE ras_vk
	CREATE TABLE ras_vk (kod int,nazv varchar(50),nazv_par varchar(100),
	f1 decimal(15,2),f2 decimal(15,2),f3 decimal(15,2),
	f4 decimal(15,2),f5 decimal(15,2),f6 decimal(15,2),
	f7 decimal(15,2),f8 decimal(15,2),f9 decimal(15,2),
	f10 decimal(15,2),f11 decimal(15,2),f12 decimal(15,2),
	f13 decimal(15,2),f14 decimal(15,2),f15 decimal(15,2),
	f16 decimal(15,2),f17 decimal(15,2),f18 decimal(15,2),
	kol_usl decimal(15,2),ps decimal(15,2), tip int)
	
	DECLARE @str_sql nvarchar(1000)
	DECLARE @cur_kot CURSOR -- Объявляем курсор
	DECLARE @kod int, @nazv varchar(100)
	DECLARE @cur_tt CURSOR -- Объявляем курсор
	DECLARE @kodtt int 
	DECLARE @gk decimal(15,2), @def nvarchar(1000)
	SET @cur_kot = CURSOR FOR 
		SELECT kodkot, nazk FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod, @nazv	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- 1. ВОДА
		INSERT INTO ras_vk (kod, nazv, nazv_par, tip)
			VALUES (@kod, @nazv, 'Хол.вода', 
			cast(cast(@kod as varchar(2))+cast(1 as varchar(1)) as integer))
		-- Внутренний цикл по тарифу
		SET @cur_tt = CURSOR FOR 
		SELECT kodtv FROM tarifv ORDER BY kodtv		
		OPEN @cur_tt
		FETCH NEXT FROM @cur_tt INTO @kodtt
		WHILE @@FETCH_STATUS = 0
		BEGIN			
			SELECT @gk = SUM(ISNULL(b.kybv,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodtv = @kodtt and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			-- Пишем внешний запрос	
			SET @str_sql = 'UPDATE ras_vk SET '+
			'f'+cast(@kodtt as varchar(2))+'=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(1 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			-- Обновляем реализацию
			SELECT @gk = SUM(ISNULL(b.kybv,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			SET @str_sql = 'UPDATE ras_vk SET '+
			'kol_usl=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(1 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk

			FETCH NEXT FROM @cur_tt INTO @kodtt
		END
		CLOSE @cur_tt
		DEALLOCATE @cur_tt
		-- Конец цикла	
	-- 2. Стоки
		INSERT INTO ras_vk (kod, nazv, nazv_par, tip)
			VALUES (@kod, @nazv, 'Стоки', 
			cast(cast(@kod as varchar(2))+cast(2 as varchar(1)) as integer))
		-- Внутренний цикл по тарифу		
		SET @cur_tt = CURSOR FOR 
		SELECT kodtv FROM tarifv ORDER BY kodtv		
		OPEN @cur_tt
		FETCH NEXT FROM @cur_tt INTO @kodtt
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @gk = SUM(ISNULL(b.kybk,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodtv = @kodtt and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			-- Пишем внешний запрос	
			SET @str_sql = 'UPDATE ras_vk SET '+
			'f'+cast(@kodtt as varchar(2))+'=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(2 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			-- Обновляем реализацию
			SELECT @gk = SUM(ISNULL(b.kybk,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			SET @str_sql = 'UPDATE ras_vk SET '+
			'kol_usl=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(2 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			
			FETCH NEXT FROM @cur_tt INTO @kodtt
		END
		CLOSE @cur_tt
		DEALLOCATE @cur_tt
		-- Конец Цикла						
		FETCH NEXT FROM @cur_kot INTO @kod, @nazv 
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot

	-- Общие итоги
	INSERT INTO ras_vk
	SELECT 	
		NULL,'ВСЕГО:','Хол. вода',
		sum(ISNULL(f1,0)),sum(ISNULL(f2,0)),sum(ISNULL(f3,0)),
		sum(ISNULL(f4,0)),sum(ISNULL(f5,0)),sum(ISNULL(f6,0)),
		sum(ISNULL(f7,0)),sum(ISNULL(f8,0)),sum(ISNULL(f9,0)),
		sum(ISNULL(f10,0)),sum(ISNULL(f11,0)),sum(ISNULL(f12,0)),
		sum(ISNULL(f13,0)),sum(ISNULL(f14,0)),sum(ISNULL(f15,0)),
		sum(ISNULL(f16,0)),sum(ISNULL(f17,0)),sum(ISNULL(f18,0)),
		sum(ISNULL(kol_usl,0)),sum(ISNULL(ps,0)), tip = 1001
	FROM ras_vk
	WHERE SUBSTRING(CAST(tip as varchar(10)),LEN(CAST(tip as varchar(10))),1) = 1
	INSERT INTO ras_vk
	SELECT 	
		NULL,'ВСЕГО:','Стоки',
		sum(ISNULL(f1,0)),sum(ISNULL(f2,0)),sum(ISNULL(f3,0)),
		sum(ISNULL(f4,0)),sum(ISNULL(f5,0)),sum(ISNULL(f6,0)),
		sum(ISNULL(f7,0)),sum(ISNULL(f8,0)),sum(ISNULL(f9,0)),
		sum(ISNULL(f10,0)),sum(ISNULL(f11,0)),sum(ISNULL(f12,0)),
		sum(ISNULL(f13,0)),sum(ISNULL(f14,0)),sum(ISNULL(f15,0)),
		sum(ISNULL(f16,0)),sum(ISNULL(f17,0)),sum(ISNULL(f18,0)),
		sum(ISNULL(kol_usl,0)),sum(ISNULL(ps,0)), tip = 1002
	FROM ras_vk
	WHERE SUBSTRING(CAST(tip as varchar(10)),LEN(CAST(tip as varchar(10))),1) = 2
GO