SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_ras_nac_g]
@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_nac_g' 
	  AND 	 type = 'U')
    DROP TABLE ras_nac_g
    
	CREATE TABLE ras_nac_g
	(nazv char(50),tarifg decimal(15,2),kod_tarif int,kybg decimal(15,2),
	 sum_nacg decimal(20,0),per_kg	decimal(15,2),sum_perg decimal(20,0))
	
    INSERT INTO ras_nac_g
	SELECT
		a.nazt,AVG(b.cenag),a.kodtg,
		SUM(ISNULL(c.kybg,0)),
		SUM(ISNULL(c.symgs,0)),
		SUM(ISNULL(c.pkybg,0)),
		SUM(ISNULL(c.perg,0))
	FROM tarifg a, datatarifg b, dataobekt c, obekt d
	WHERE a.kodtg = b.kodtg and a.kodtg = d.kodtg and
				b.datan = c.datan and c.kodobk = d.kodobk
				and b.datan between @data1 and @data2
	GROUP BY a.nazt, a.kodtg
	HAVING (SUM(ISNULL(c.kybg,0))+
					SUM(ISNULL(c.symgs,0))+
					SUM(ISNULL(c.pkybg,0))+
					SUM(ISNULL(c.perg,0))) !=0
	ORDER BY a.kodtg
	
    -- Добавляем итог по населению
	INSERT INTO ras_nac_g
	SELECT
		'ИТОГО население',Null,Null,
		SUM(kybg),SUM(sum_nacg),SUM(per_kg),SUM(sum_perg)
	FROM ras_nac_g
	WHERE kod_tarif = 8
    
	-- Добавляем итог по ЖСК
	INSERT INTO ras_nac_g
	SELECT
		'ИТОГО ЖСК + вед.',Null,Null,
		SUM(kybg),SUM(sum_nacg),SUM(per_kg),SUM(sum_perg)
	FROM ras_nac_g
	WHERE kod_tarif in (3,6,7)
    
	-- Добавляем итог по организациям
	INSERT INTO ras_nac_g
	SELECT
		'ИТОГО организации',Null,Null,
		SUM(kybg),SUM(sum_nacg),SUM(per_kg),SUM(sum_perg)
	FROM ras_nac_g
	WHERE kod_tarif NOT IN (3,6,7,8)
	-- Добавляем итог
	INSERT INTO ras_nac_g
	SELECT
		'ВСЕГО:',Null,Null,
		SUM(kybg),SUM(sum_nacg),SUM(per_kg),SUM(sum_perg)
	FROM ras_nac_g
	WHERE kod_tarif Is Not Null
GO