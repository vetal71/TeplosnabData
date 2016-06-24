SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE     PROCEDURE [dbo].[sp_ras_ot]
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_ot' 
	  AND 	 type = 'U')
    DROP TABLE ras_ot
	CREATE TABLE ras_ot (kod int,nazv varchar(50),nazv_par varchar(100),
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
	-- 1. ОТОПЛЕНИЕ
		INSERT INTO ras_ot (kod, nazv, nazv_par, tip)
			VALUES (@kod, @nazv, 'Отопление', 
			cast(cast(@kod as varchar(2))+cast(1 as varchar(1)) as integer))
		-- Внутренний цикл по тарифу
		SET @cur_tt = CURSOR FOR 
		SELECT kodtt FROM tarift ORDER BY kodtt		
		OPEN @cur_tt
		FETCH NEXT FROM @cur_tt INTO @kodtt
		WHILE @@FETCH_STATUS = 0
		BEGIN			
			SELECT @gk = SUM(ISNULL(b.gkt,0)+isnull(b.pgkt,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodtt = @kodtt and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			-- Пишем внешний запрос	
			SET @str_sql = 'UPDATE ras_ot SET '+
			'f'+cast(@kodtt as varchar(2))+'=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(1 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			FETCH NEXT FROM @cur_tt INTO @kodtt
		END
		CLOSE @cur_tt
		DEALLOCATE @cur_tt
		-- Конец цикла	
	-- 2. ГВС
		INSERT INTO ras_ot (kod, nazv, nazv_par, tip)
			VALUES (@kod, @nazv, 'ГВС', 
			cast(cast(@kod as varchar(2))+cast(2 as varchar(1)) as integer))
		-- Внутренний цикл по тарифу		
		SET @cur_tt = CURSOR FOR 
		SELECT kodtt FROM tarift ORDER BY kodtt		
		OPEN @cur_tt
		FETCH NEXT FROM @cur_tt INTO @kodtt
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @gk = SUM(ISNULL(b.gkv,0)+isnull(b.pgkv,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodtt = @kodtt and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			-- Пишем внешний запрос	
			SET @str_sql = 'UPDATE ras_ot SET '+
			'f'+cast(@kodtt as varchar(2))+'=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(2 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			FETCH NEXT FROM @cur_tt INTO @kodtt
		END
		CLOSE @cur_tt
		DEALLOCATE @cur_tt
		-- Конец Цикла
	-- 3. ИТОГО
		INSERT INTO ras_ot (kod, nazv, nazv_par, tip)
			VALUES (@kod, @nazv, 'ИТОГО', 
			cast(cast(@kod as varchar(2))+cast(3 as varchar(1)) as integer))
		-- Внутренний цикл по тарифу
		SET @cur_tt = CURSOR FOR 
		SELECT kodtt FROM tarift ORDER BY kodtt		
		OPEN @cur_tt
		FETCH NEXT FROM @cur_tt INTO @kodtt
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @gk = SUM(ISNULL(b.gkt,0)+ISNULL(b.gkv,0)+isnull(b.pgkt,0)+isnull(b.pgkv,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodtt = @kodtt and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			-- Пишем внешний запрос	
			SET @str_sql = 'UPDATE ras_ot SET '+
			'f'+cast(@kodtt as varchar(2))+'=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(3 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			-- Обновляем реализацию
			SELECT @gk = SUM(ISNULL(b.gkt,0)+ISNULL(b.gkv,0)+isnull(b.pgkt,0)+isnull(b.pgkv,0))
				FROM obekt a, dataobekt b
				WHERE a.kodobk = b.kodobk and a.kodkot = @kod
				and b.datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			SET @str_sql = 'UPDATE ras_ot SET '+
			'kol_usl=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(3 as varchar(1))
			SET @def = '@gkt decimal(15,2)'
			EXEC sp_executesql @str_sql, @def, @gkt=@gk
			-- Обновляем потери
			SELECT @gk = ISNULL(ps,0)
				FROM datakoteln
				WHERE kodkot = @kod and datan between @data1 and @data2
			IF @gk IS NULL SET @gk = 0
			SET @str_sql = 'UPDATE ras_ot SET '+
			'ps=@gkt where tip = '+
			cast(@kod as varchar(2))+cast(3 as varchar(1))
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
	INSERT INTO ras_ot
	SELECT 	
		NULL,'ВСЕГО:','Отопление',
		sum(ISNULL(f1,0)),sum(ISNULL(f2,0)),sum(ISNULL(f3,0)),
		sum(ISNULL(f4,0)),sum(ISNULL(f5,0)),sum(ISNULL(f6,0)),
		sum(ISNULL(f7,0)),sum(ISNULL(f8,0)),sum(ISNULL(f9,0)),
		sum(ISNULL(f10,0)),sum(ISNULL(f11,0)),sum(ISNULL(f12,0)),
		sum(ISNULL(f13,0)),sum(ISNULL(f14,0)),sum(ISNULL(f15,0)),
		sum(ISNULL(f16,0)),sum(ISNULL(f17,0)),sum(ISNULL(f18,0)),
		sum(ISNULL(kol_usl,0)),sum(ISNULL(ps,0)), tip = 1001
	FROM ras_ot
	WHERE SUBSTRING(CAST(tip as varchar(10)),LEN(CAST(tip as varchar(10))),1) = 1
	INSERT INTO ras_ot
	SELECT 	
		NULL,'ВСЕГО:','ГВС',
		sum(ISNULL(f1,0)),sum(ISNULL(f2,0)),sum(ISNULL(f3,0)),
		sum(ISNULL(f4,0)),sum(ISNULL(f5,0)),sum(ISNULL(f6,0)),
		sum(ISNULL(f7,0)),sum(ISNULL(f8,0)),sum(ISNULL(f9,0)),
		sum(ISNULL(f10,0)),sum(ISNULL(f11,0)),sum(ISNULL(f12,0)),
		sum(ISNULL(f13,0)),sum(ISNULL(f14,0)),sum(ISNULL(f15,0)),
		sum(ISNULL(f16,0)),sum(ISNULL(f17,0)),sum(ISNULL(f18,0)),
		sum(ISNULL(kol_usl,0)),sum(ISNULL(ps,0)), tip = 1002
	FROM ras_ot
	WHERE SUBSTRING(CAST(tip as varchar(10)),LEN(CAST(tip as varchar(10))),1) = 2
	INSERT INTO ras_ot
	SELECT 	
		NULL,'ВСЕГО:','ИТОГО',
		sum(ISNULL(f1,0)),sum(ISNULL(f2,0)),sum(ISNULL(f3,0)),
		sum(ISNULL(f4,0)),sum(ISNULL(f5,0)),sum(ISNULL(f6,0)),
		sum(ISNULL(f7,0)),sum(ISNULL(f8,0)),sum(ISNULL(f9,0)),
		sum(ISNULL(f10,0)),sum(ISNULL(f11,0)),sum(ISNULL(f12,0)),
		sum(ISNULL(f13,0)),sum(ISNULL(f14,0)),sum(ISNULL(f15,0)),
		sum(ISNULL(f16,0)),sum(ISNULL(f17,0)),sum(ISNULL(f18,0)),
		sum(ISNULL(kol_usl,0)),sum(ISNULL(ps,0)), tip = 1003
	FROM ras_ot
	WHERE SUBSTRING(CAST(tip as varchar(10)),LEN(CAST(tip as varchar(10))),1) = 3



GO