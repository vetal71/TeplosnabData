SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[sp_ras_nac]
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_nac_ot' 
	  AND 	 type = 'U')
    DROP TABLE ras_nac_ot
	CREATE TABLE ras_nac_ot
	(nazv char(50),tarif decimal(15,2),kod_tarif int,gk decimal(15,2),
	 sum_nac decimal(20,0),per_gk	decimal(15,2),sum_per decimal(20,0))
	INSERT INTO ras_nac_ot
	SELECT
		a.nazt,AVG(b.cena),a.kodtt,
		SUM(ISNULL(c.gkt,0)+ISNULL(c.gkv,0)),
		SUM(ISNULL(c.symk,0)+ISNULL(c.symgv,0)),
		SUM(ISNULL(c.pgkt,0)+ISNULL(c.pgkv,0)),
		SUM(ISNULL(c.pert,0)+ISNULL(c.perv,0))
	FROM tarift a, datatarif b, dataobekt c, obekt d
	WHERE a.kodtt = b.kodtt and a.kodtt = d.kodtt and
				b.datan = c.datan and c.kodobk = d.kodobk
				and b.datan between @data1 and @data2
	GROUP BY a.nazt, a.kodtt
	HAVING (SUM(ISNULL(c.gkt,0)+ISNULL(c.gkv,0))+
				 SUM(ISNULL(c.symk,0)+ISNULL(c.symgv,0))+
				 SUM(ISNULL(c.pgkt,0)+ISNULL(c.pgkv,0))+
				 SUM(ISNULL(c.pert,0)+ISNULL(c.perv,0))) !=0
	ORDER BY a.kodtt
	-- Добавляем итог по населению
	INSERT INTO ras_nac_ot
	SELECT
		'ИТОГО население',Null,Null,
		SUM(gk),SUM(sum_nac),SUM(per_gk),SUM(sum_per)
	FROM ras_nac_ot
	WHERE kod_tarif IN (8,9)
	-- Добавляем итог по ЖСК
	INSERT INTO ras_nac_ot
	SELECT
		'ИТОГО ЖСК + вед.',Null,Null,
		SUM(gk),SUM(sum_nac),SUM(per_gk),SUM(sum_per)
	FROM ras_nac_ot
	WHERE kod_tarif IN (3,4,10)
	-- Добавляем итог по организациям
	INSERT INTO ras_nac_ot
	SELECT
		'ИТОГО организации',Null,Null,
		SUM(gk),SUM(sum_nac),SUM(per_gk),SUM(sum_per)
	FROM ras_nac_ot
	WHERE kod_tarif NOT IN (3,4,8,9,10)
	-- Добавляем итог
	INSERT INTO ras_nac_ot
	SELECT
		'ВСЕГО:',Null,Null,
		SUM(gk),SUM(sum_nac),SUM(per_gk),SUM(sum_per)
	FROM ras_nac_ot
	WHERE kod_tarif Is Not Null
GO