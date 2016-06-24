SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_ras_kot_g] 
@data1 datetime, @data2 datetime
AS
	DECLARE @cur_kot CURSOR
	DECLARE @kod int
	-- Создаем таблицу
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_kot_g' 
	  AND 	 type = 'U')
    DROP TABLE ras_kot_g
    
	CREATE TABLE ras_kot_g 
	(nazv varchar(50),nazv_pot varchar(50),kybg decimal(15,2),
	 sum_nacg decimal(20,0),per_kg	decimal(15,2),sum_perg decimal(20,0),tip int)
     
	-- Объявляем курсор
	SET @cur_kot = CURSOR FOR SELECT kodkot FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Данные по населению
		INSERT INTO ras_kot_g
		SELECT 
			a.nazk,'Население',
			sum(isnull(b.kybg,0)),
			sum(isnull(b.symg,0)),
			sum(isnull(b.pkybg,0)),
			sum(isnull(b.perg,0)),1
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtg in (3,6,7,8) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybg,0))+
					SUM(ISNULL(b.symgs,0))+
					SUM(ISNULL(b.pkybg,0))+
					SUM(ISNULL(b.perg,0))) !=0
		
        -- Данные по ЖСК
		INSERT INTO ras_kot_g
		SELECT 
			a.nazk,'в том числе ЖСК + вед.',
			sum(isnull(b.kybg,0)),
			sum(isnull(b.symg,0)),
			sum(isnull(b.pkybg,0)),
			sum(isnull(b.perg,0)),2
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtg in (3,6,7) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybg,0))+
					SUM(ISNULL(b.symgs,0))+
					SUM(ISNULL(b.pkybg,0))+
					SUM(ISNULL(b.perg,0))) !=0
		
        -- Данные по организациям
		INSERT INTO ras_kot_g
		SELECT 
			a.nazk,'Организации',
			sum(isnull(b.kybg,0)),
			sum(isnull(b.symg,0)),
			sum(isnull(b.pkybg,0)),
			sum(isnull(b.perg,0)),3
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtg not in (3,6,7,8) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybg,0))+
					SUM(ISNULL(b.symgs,0))+
					SUM(ISNULL(b.pkybg,0))+
					SUM(ISNULL(b.perg,0))) !=0
		
        -- Итоги по участку
		INSERT INTO ras_kot_g
		SELECT 
			a.nazk,'ИТОГО',
			sum(isnull(b.kybg,0)),
			sum(isnull(b.symg,0)),
			sum(isnull(b.pkybg,0)),
			sum(isnull(b.perg,0)),4
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybg,0))+
					SUM(ISNULL(b.symgs,0))+
					SUM(ISNULL(b.pkybg,0))+
					SUM(ISNULL(b.perg,0))) !=0
		-- Следующая запись
		FETCH NEXT FROM @cur_kot INTO @kod
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
	-- ИТОГИ по предприятию
	INSERT INTO ras_kot_g
	SELECT
		'ВСЕГО','Население',sum(kybg),
	 	sum(sum_nacg),sum(per_kg),sum(sum_perg),11
	FROM ras_kot_g	
	WHERE tip = 1
	INSERT INTO ras_kot_g
	SELECT
		'ВСЕГО','в том числе ЖСК + вед.',sum(kybg),
	 	sum(sum_nacg),sum(per_kg),sum(sum_perg),21
	FROM ras_kot_g	
	WHERE tip = 2
	INSERT INTO ras_kot_g
	SELECT
		'ВСЕГО','организации',sum(kybg),
	 	sum(sum_nacg),sum(per_kg),sum(sum_perg),31
	FROM ras_kot_g	
	WHERE tip = 3
	INSERT INTO ras_kot_g
	SELECT
		'ВСЕГО','ИТОГО',sum(kybg),
	 	sum(sum_nacg),sum(per_kg),sum(sum_perg),41
	FROM ras_kot_g	
	WHERE tip = 4
GO