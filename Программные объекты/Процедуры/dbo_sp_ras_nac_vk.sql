SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[sp_ras_nac_vk]
@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_nac_vk' 
	  AND 	 type = 'U')
    DROP TABLE ras_nac_vk
	CREATE TABLE ras_nac_vk
	(nazv char(50),tarifv decimal(15,2),kod_tarif int,kybv decimal(15,2),
	 sum_nacv decimal(20,0),per_kv	decimal(15,2),sum_perv decimal(20,0),
	 tarifk decimal(15,2),kybk decimal(15,2),
	 sum_nack decimal(20,0),per_kk	decimal(15,2),sum_perk decimal(20,0))
	INSERT INTO ras_nac_vk
	SELECT
		a.nazt,AVG(b.cenav),a.kodtv,
		SUM(ISNULL(c.kybv,0)),
		SUM(ISNULL(c.symhs,0)),
		SUM(ISNULL(c.pkybv,0)),
		SUM(ISNULL(c.perh,0)),
		AVG(b.cenak),
		SUM(ISNULL(c.kybk,0)),
		SUM(ISNULL(c.symks,0)),
		SUM(ISNULL(c.pkybk,0)),
		SUM(ISNULL(c.perk,0))
	FROM tarifv a, datatarifv b, dataobekt c, obekt d
	WHERE a.kodtv = b.kodtv and a.kodtv = d.kodtv and
				b.datan = c.datan and c.kodobk = d.kodobk
				and b.datan between @data1 and @data2
	GROUP BY a.nazt, a.kodtv
	HAVING (SUM(ISNULL(c.kybv,0))+
					SUM(ISNULL(c.symhs,0))+
					SUM(ISNULL(c.pkybv,0))+
					SUM(ISNULL(c.perh,0))+
					SUM(ISNULL(c.kybk,0))+
					SUM(ISNULL(c.symks,0))+
					SUM(ISNULL(c.pkybk,0))+
					SUM(ISNULL(c.perk,0))) !=0
	ORDER BY a.kodtv
	-- Добавляем итог по населению
	INSERT INTO ras_nac_vk
	SELECT
		'ИТОГО население',Null,Null,
		SUM(kybv),SUM(sum_nacv),SUM(per_kv),SUM(sum_perv),
		Null,SUM(kybk),SUM(sum_nack),SUM(per_kk),SUM(sum_perk)
	FROM ras_nac_vk
	WHERE kod_tarif = 5
	-- Добавляем итог по ЖСК
	INSERT INTO ras_nac_vk
	SELECT
		'ИТОГО ЖСК + вед.',Null,Null,
		SUM(kybv),SUM(sum_nacv),SUM(per_kv),SUM(sum_perv),
		Null,SUM(kybk),SUM(sum_nack),SUM(per_kk),SUM(sum_perk)
	FROM ras_nac_vk
	WHERE kod_tarif in (3,12,15,16,17,7,19)
	-- Добавляем итог по организациям
	INSERT INTO ras_nac_vk
	SELECT
		'ИТОГО организации',Null,Null,
		SUM(kybv),SUM(sum_nacv),SUM(per_kv),SUM(sum_perv),
		Null,SUM(kybk),SUM(sum_nack),SUM(per_kk),SUM(sum_perk)
	FROM ras_nac_vk
	WHERE kod_tarif NOT IN (3,5,12,15,16,17,7,19)
	-- Добавляем итог
	INSERT INTO ras_nac_vk
	SELECT
		'ВСЕГО:',Null,Null,
		SUM(kybv),SUM(sum_nacv),SUM(per_kv),SUM(sum_perv),
		Null,SUM(kybk),SUM(sum_nack),SUM(per_kk),SUM(sum_perk)
	FROM ras_nac_vk
	WHERE kod_tarif Is Not Null
GO