SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE    PROCEDURE [dbo].[sp_create_plan]
	@tip1 int, @tip2 int, @tip3 int, @tip4 int,
	@v1 int, @v2 int, @v3 int, @v4 int,
	@k1 decimal(15,2), @k2 decimal(15,2), @k3 decimal(15,2), @k4 decimal(15,2),
	@data datetime
AS
	
	
	IF (@tip1 >= 0 and @k1 > 0)
	BEGIN
		-- Формируем данные по теплу
		IF @v1 = 0 
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanTeplo'
				AND type = 'U')
				DROP TABLE tPlanTeplo
			SELECT c.nazv,
				avg(a.rastarift) as tarif,
				sum(ISNULL(a.gkt,0)+ISNULL(a.gkv,0))*@k1 as gk,
				sum(ISNULL(a.symk,0)+ISNULL(a.symgv,0))*@k1 as summa
			INTO TPlanTeplo
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip1-1 and a.datan = @data and b.kodtt = 1
			group by c.nazv
			order by c.nazv
		END
		IF @v1 = 1 
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanTeplo'
				AND type = 'U')
				DROP TABLE tPlanTeplo
			SELECT c.nazv,
				@k1 as tarif,
				sum(ISNULL(a.gkt,0)+ISNULL(a.gkv,0)) as gk,
				sum(ISNULL(a.gkt,0)+ISNULL(a.gkv,0))*@k1 as summa
			INTO TPlanTeplo
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip1-1 and a.datan = @data and b.kodtt = 1
			group by c.nazv
			order by c.nazv
		END
	END
	IF @tip2 >= 0 and @k2 > 0
	BEGIN
		-- Формируем данные по воде
		IF @v2 = 0 
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanVoda'
				AND type = 'U')
				DROP TABLE tPlanVoda
			SELECT c.nazv,
				avg(a.rastarifv)  as tarif,
				sum(ISNULL(a.kybv,0))*@k2 as gk,
				sum(ISNULL(a.symhs,0))*@k2 as summa
			INTO TPlanVoda
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip2-1 and a.datan = @data and b.kodtv = 1
			group by c.nazv
			order by c.nazv
		END
		IF @v2 = 1 
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanVoda'
				AND type = 'U')
				DROP TABLE tPlanVoda
			SELECT c.nazv,
				@k2  as tarif,
				sum(ISNULL(a.kybv,0)) as gk,
				sum(ISNULL(a.symhs,0))*@k2 as summa
			INTO TPlanVoda
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip2-1 and a.datan = @data and b.kodtv= 1 
			group by c.nazv
			order by c.nazv
		END
	END
	IF @tip3 >= 0 and @k3 > 0
	BEGIN
		-- Формируем данные по стокам	
		IF @v3 = 0
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanStok'
				AND type = 'U')
				DROP TABLE tPlanStok	
			SELECT c.nazv,
				avg(a.rastarifk) as tarif,
				sum(ISNULL(a.kybk,0))*@k3 as gk,
				sum(ISNULL(a.symkk,0))*@k3 as summa
			INTO TPlanStok
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip3-1 and a.datan = @data and b.kodtv = 1
			group by c.nazv
			order by c.nazv
		END
		IF @v3 = 1
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanStok'
				AND type = 'U')
				DROP TABLE tPlanStok	
			SELECT c.nazv,
				@k3 as tarif,
				sum(ISNULL(a.kybk,0)) as gk,
				sum(ISNULL(a.symkk,0))*@k3 as summa
			INTO TPlanStok
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip3-1 and a.datan = @data and b.kodtv = 1
			group by c.nazv
			order by c.nazv
		END
	END
    -- Формируем данные по мусору
    IF @tip4 >= 0 and @k4 > 0
	BEGIN			
		IF @v4 = 0
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanG'
				AND type = 'U')
				DROP TABLE tPlanG	
			SELECT c.nazv,
				avg(a.rastarifg) as tarif,
				sum(ISNULL(a.kybg,0))*@k3 as gk,
				sum(ISNULL(a.symgs,0))*@k3 as summa
			INTO TPlanG
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip4-1 and a.datan = @data and b.kodtg = 1
			group by c.nazv
			order by c.nazv
		END
		IF @v4 = 1
		BEGIN
			IF EXISTS (SELECT name FROM sysobjects
				WHERE name = 'tPlanG'
				AND type = 'U')
				DROP TABLE tPlanG	
			SELECT c.nazv,
				@k4 as tarif,
				sum(ISNULL(a.kybg,0)) as gk,
				sum(ISNULL(a.symgs,0))*@k3 as summa
			INTO TPlanStok
			FROM dataobekt a, obekt b, org c
			WHERE a.kodobk = b.kodobk and b.kodorg = c.kodorg
			and c.tipbud = @tip4-1 and a.datan = @data and b.kodtg = 1
			group by c.nazv
			order by c.nazv
		END
	END
GO