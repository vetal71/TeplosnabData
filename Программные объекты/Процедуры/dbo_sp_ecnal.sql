SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_ecnal]
@data1 datetime, @data2 datetime
AS
	DECLARE @cur_kot CURSOR
	DECLARE @kod int
	-- Создаем таблицу
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_kot_e' 
	  AND 	 type = 'U')
    DROP TABLE ras_kot_e
	CREATE TABLE ras_kot_e 
	(nazv varchar(50),nazv_pot varchar(50),gkt decimal(15,2),	 	
	 gkv decimal(15,2),sum_gk	decimal(15,2),	
	 kybv decimal(15,2),kybk decimal(15,2), tip int)
	-- Объявляем курсор
	SET @cur_kot = CURSOR FOR SELECT kodkot FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Данные по льготе
		INSERT INTO ras_kot_e
		SELECT 
			a.nazk,'Льгота',
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)),
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0)),
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)+isnull(b.gkv,0)+isnull(b.pgkv,0)),
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0)),
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0)),1			
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.ecnal = 0 and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (sum(isnull(b.gkt,0)+isnull(b.pgkt,0))+
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0))+			
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0))+
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0))) !=0
		-- Данные без льготы
		INSERT INTO ras_kot_e
		SELECT 
			a.nazk,'Без льготы',
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)),
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0)),	
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)+isnull(b.gkv,0)+isnull(b.pgkv,0)),		
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0)),
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0)),2			
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.ecnal = 1 and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (sum(isnull(b.gkt,0)+isnull(b.pgkt,0))+
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0))+			
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0))+
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0))) !=0		
		-- Итоги по участку
		INSERT INTO ras_kot_e
		SELECT 
			a.nazk,'ИТОГО',
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)),
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0)),
			sum(isnull(b.gkt,0)+isnull(b.pgkt,0)+
			isnull(b.gkv,0)+isnull(b.pgkv,0)),
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0)),
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0)),3
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (sum(isnull(b.gkt,0)+isnull(b.pgkt,0))+
			sum(isnull(b.gkv,0)+isnull(b.pgkv,0))+			
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0))+
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0))) !=0
		-- Следующая запись
		FETCH NEXT FROM @cur_kot INTO @kod
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
	-- ИТОГИ по предприятию
	INSERT INTO ras_kot_e
	SELECT
		'ВСЕГО','Льгота',sum(gkt),sum(gkv),
	 	sum(sum_gk),sum(kybv),sum(kybk),11
	FROM ras_kot_e	
	WHERE tip = 1
	INSERT INTO ras_kot_e
	SELECT
		'ВСЕГО','Без льготы',sum(gkt),sum(gkv),
	 	sum(sum_gk),sum(kybv),sum(kybk),21
	FROM ras_kot_e	
	WHERE tip = 2	
	INSERT INTO ras_kot_e
	SELECT
		'ВСЕГО','ИТОГО',sum(gkt),sum(gkv),
	 	sum(sum_gk),sum(kybv),sum(kybk),31
	FROM ras_kot_e	
	WHERE tip = 3	


GO