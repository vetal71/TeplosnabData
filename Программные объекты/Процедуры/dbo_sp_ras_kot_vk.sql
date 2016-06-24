SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[sp_ras_kot_vk] 
@data1 datetime, @data2 datetime
AS
	DECLARE @cur_kot CURSOR
	DECLARE @kod int
	-- Создаем таблицу
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_kot_vk' 
	  AND 	 type = 'U')
    DROP TABLE ras_kot_vk
	CREATE TABLE ras_kot_vk 
	(nazv varchar(50),nazv_pot varchar(50),kybv decimal(15,2),
	 sum_nacv decimal(20,0),per_kv	decimal(15,2),sum_perv decimal(20,0),
	 kybk decimal(15,2),sum_nack decimal(20,0),per_kk	decimal(15,2),
	 sum_perk decimal(20,0),tip int)
	-- Объявляем курсор
	SET @cur_kot = CURSOR FOR SELECT kodkot FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Данные по населению
		INSERT INTO ras_kot_vk
		SELECT 
			a.nazk,'Население',
			sum(isnull(b.kybv,0)),
			sum(isnull(b.symhs,0)),
			sum(isnull(b.pkybv,0)),
			sum(isnull(b.perh,0)),			
			sum(isnull(b.kybk,0)),
			sum(isnull(b.symks,0)),
			sum(isnull(b.pkybk,0)),
			sum(isnull(b.perk,0)),1
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtv in (3,5,12,15,16,17) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybv,0))+
					SUM(ISNULL(b.symhs,0))+
					SUM(ISNULL(b.pkybv,0))+
					SUM(ISNULL(b.perh,0))+
					SUM(ISNULL(b.kybk,0))+
					SUM(ISNULL(b.symks,0))+
					SUM(ISNULL(b.pkybk,0))+
					SUM(ISNULL(b.perk,0))) !=0
		-- Данные по ЖСК
		INSERT INTO ras_kot_vk
		SELECT 
			a.nazk,'в том числе ЖСК + вед.',
			sum(isnull(b.kybv,0)),
			sum(isnull(b.symhs,0)),
			sum(isnull(b.pkybv,0)),
			sum(isnull(b.perh,0)),			
			sum(isnull(b.kybk,0)),
			sum(isnull(b.symks,0)),
			sum(isnull(b.pkybk,0)),
			sum(isnull(b.perk,0)),2
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtv in (3,12,15,16,17,7,19) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybv,0))+
					SUM(ISNULL(b.symhs,0))+
					SUM(ISNULL(b.pkybv,0))+
					SUM(ISNULL(b.perh,0))+
					SUM(ISNULL(b.kybk,0))+
					SUM(ISNULL(b.symks,0))+
					SUM(ISNULL(b.pkybk,0))+
					SUM(ISNULL(b.perk,0))) !=0
		-- Данные по организациям
		INSERT INTO ras_kot_vk
		SELECT 
			a.nazk,'Организации',
			sum(isnull(b.kybv,0)),
			sum(isnull(b.symhs,0)),
			sum(isnull(b.pkybv,0)),
			sum(isnull(b.perh,0)),			
			sum(isnull(b.kybk,0)),
			sum(isnull(b.symks,0)),
			sum(isnull(b.pkybk,0)),
			sum(isnull(b.perk,0)),3
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.kodtv not in (3,5,12,15,16,17,7,19) and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybv,0))+
					SUM(ISNULL(b.symhs,0))+
					SUM(ISNULL(b.pkybv,0))+
					SUM(ISNULL(b.perh,0))+
					SUM(ISNULL(b.kybk,0))+
					SUM(ISNULL(b.symks,0))+
					SUM(ISNULL(b.pkybk,0))+
					SUM(ISNULL(b.perk,0))) !=0
		-- Итоги по участку
		INSERT INTO ras_kot_vk
		SELECT 
			a.nazk,'ИТОГО',
			sum(isnull(b.kybv,0)),
			sum(isnull(b.symhs,0)),
			sum(isnull(b.pkybv,0)),
			sum(isnull(b.perh,0)),			
			sum(isnull(b.kybk,0)),
			sum(isnull(b.symks,0)),
			sum(isnull(b.pkybk,0)),
			sum(isnull(b.perk,0)),4
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and a.kodkot = @kod
		and b.datan between @data1 and @data2
		GROUP BY a.nazk
		HAVING (SUM(ISNULL(b.kybv,0))+
					SUM(ISNULL(b.symhs,0))+
					SUM(ISNULL(b.pkybv,0))+
					SUM(ISNULL(b.perh,0))+
					SUM(ISNULL(b.kybk,0))+
					SUM(ISNULL(b.symks,0))+
					SUM(ISNULL(b.pkybk,0))+
					SUM(ISNULL(b.perk,0))) !=0
		-- Следующая запись
		FETCH NEXT FROM @cur_kot INTO @kod
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
	-- ИТОГИ по предприятию
	INSERT INTO ras_kot_vk
	SELECT
		'ВСЕГО','Население',sum(kybv),
	 	sum(sum_nacv),sum(per_kv),sum(sum_perv),
		sum(kybk),sum(sum_nack),sum(per_kk),sum(sum_perk),11
	FROM ras_kot_vk	
	WHERE tip = 1
	INSERT INTO ras_kot_vk
	SELECT
		'ВСЕГО','в том числе ЖСК + вед.',sum(kybv),
	 	sum(sum_nacv),sum(per_kv),sum(sum_perv),
		sum(kybk),sum(sum_nack),sum(per_kk),sum(sum_perk),21
	FROM ras_kot_vk	
	WHERE tip = 2
	INSERT INTO ras_kot_vk
	SELECT
		'ВСЕГО','организации',sum(kybv),
	 	sum(sum_nacv),sum(per_kv),sum(sum_perv),
		sum(kybk),sum(sum_nack),sum(per_kk),sum(sum_perk),31
	FROM ras_kot_vk	
	WHERE tip = 3
	INSERT INTO ras_kot_vk
	SELECT
		'ВСЕГО','ИТОГО',sum(kybv),
	 	sum(sum_nacv),sum(per_kv),sum(sum_perv),
		sum(kybk),sum(sum_nack),sum(per_kk),sum(sum_perk),41
	FROM ras_kot_vk	
	WHERE tip = 4
GO