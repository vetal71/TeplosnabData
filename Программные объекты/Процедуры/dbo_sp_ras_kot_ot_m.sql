SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_ras_kot_ot_m]
	@data1 datetime, @data2 datetime
AS
	DECLARE @cur_kot CURSOR
	DECLARE @kod int
	-- Создаем таблицу
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_kot_ot_m' 
	  AND 	 type = 'U')
    DROP TABLE ras_kot_ot_m
	CREATE TABLE ras_kot_ot_m 
	(nazv varchar(50),nazv_pot varchar(50),gk decimal(15,2),
	 sum_nac decimal(20,0),per_gk	decimal(15,2),	
	 sum_per decimal(20,0),tip int)
	-- Объявляем курсор
	SET @cur_kot = CURSOR FOR SELECT kodkot FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Данные по городу
		INSERT INTO ras_kot_ot_m
		SELECT 
			a.nazk,'ГОРОД',
			sum(isnull(b.gkt,0)+isnull(b.gkv,0)),
			sum(isnull(b.symk,0)+isnull(b.symgv,0)),
			sum(isnull(b.pgkt,0)+isnull(b.pgkv,0)),
			sum(isnull(b.pert,0)+isnull(b.perv,0)),1
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.kodkot = @kod and a.mesto=1
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.gkt,0)+ISNULL(b.gkv,0))+
				 SUM(ISNULL(b.symk,0)+ISNULL(b.symgv,0))+
				 SUM(ISNULL(b.pgkt,0)+ISNULL(b.pgkv,0))+
				 SUM(ISNULL(b.pert,0)+ISNULL(b.perv,0))) !=0		
		-- Данные по селу
		INSERT INTO ras_kot_ot_m
		SELECT 
			a.nazk,'СЕЛО',
			sum(isnull(b.gkt,0)+isnull(b.gkv,0)),
			sum(isnull(b.symk,0)+isnull(b.symgv,0)),
			sum(isnull(b.pgkt,0)+isnull(b.pgkv,0)),
			sum(isnull(b.pert,0)+isnull(b.perv,0)),2
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.mesto = 2 and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.gkt,0)+ISNULL(b.gkv,0))+
				 SUM(ISNULL(b.symk,0)+ISNULL(b.symgv,0))+
				 SUM(ISNULL(b.pgkt,0)+ISNULL(b.pgkv,0))+
				 SUM(ISNULL(b.pert,0)+ISNULL(b.perv,0))) !=0		
		-- Итоги по участку
		INSERT INTO ras_kot_ot_m
		SELECT 
			a.nazk,'ИТОГО',
			sum(isnull(b.gkt,0)+isnull(b.gkv,0)),
			sum(isnull(b.symk,0)+isnull(b.symgv,0)),
			sum(isnull(b.pgkt,0)+isnull(b.pgkv,0)),
			sum(isnull(b.pert,0)+isnull(b.perv,0)),3
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.gkt,0)+ISNULL(b.gkv,0))+
				 SUM(ISNULL(b.symk,0)+ISNULL(b.symgv,0))+
				 SUM(ISNULL(b.pgkt,0)+ISNULL(b.pgkv,0))+
				 SUM(ISNULL(b.pert,0)+ISNULL(b.perv,0))) !=0
		-- Следующая запись
		FETCH NEXT FROM @cur_kot INTO @kod
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
	-- ИТОГИ по предприятию
	INSERT INTO ras_kot_ot_m
	SELECT
		'ВСЕГО','ГОРОД',sum(gk),
	 	sum(sum_nac),sum(per_gk),sum(sum_per),11
	FROM ras_kot_ot_m	
	WHERE tip = 1
	INSERT INTO ras_kot_ot_m
	SELECT
		'ВСЕГО','СЕЛО',sum(gk),
	 	sum(sum_nac),sum(per_gk),sum(sum_per),21
	FROM ras_kot_ot_m	
	WHERE tip = 2	
	INSERT INTO ras_kot_ot_m
	SELECT
		'ВСЕГО','ИТОГО',sum(gk),
	 	sum(sum_nac),sum(per_gk),sum(sum_per),31
	FROM ras_kot_ot_m	
	WHERE tip = 3
GO