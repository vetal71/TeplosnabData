SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_general_report_all] 
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'gen_report_all' 
	  AND 	 type = 'U')
    DROP TABLE gen_report_all
	CREATE TABLE gen_report_all 
	(kod int, nazv char(50),gk decimal(15,2),tarif decimal(15,2),kod_tarif int,
	 sum_nac decimal(20,0),sum_nds decimal(20,0),
	 per_gk	decimal(15,2),sum_per decimal(20,0),razn decimal(20,0),
	 kv decimal(15,2),tarifv decimal(15,2),kod_tarifv int,
	 sum_nacv decimal(20,0),sum_ndsv decimal(20,0),
	 per_kv	decimal(15,2),sum_perv decimal(20,0),raznv decimal(20,0),
	 kk decimal(15,2),tarifk decimal(15,2),kod_tarifk int,
	 sum_nack decimal(20,0),sum_ndsk decimal(20,0),
	 per_kk	decimal(15,2),sum_perk decimal(20,0),raznk decimal(20,0),
	 tip int)
	print 'Создали таблицу'
	-- Собираем сведения
	DECLARE @i integer
	DECLARE @kod int, @nazv varchar(100),@gk decimal(15,2),@tarif decimal(15,2),
	@kod_tarif int,@sum_nac decimal(20,0),@sum_nds decimal(20,0),
	@per_gk decimal(15,2),@sum_per decimal(20,0),@razn decimal(20,0),
	@cena_t decimal(15,2),
	@kv decimal(15,2),@tarifv decimal(15,2),
	@kod_tarifv int,@sum_nacv decimal(20,0),@sum_ndsv decimal(20,0),
	@per_kv decimal(15,2),@sum_perv decimal(20,0),@raznv decimal(20,0),
	@cena_v decimal(15,2),
  @kk decimal(15,2),@tarifk decimal(15,2),
	@kod_tarifk int,@sum_nack decimal(20,0),@sum_ndsk decimal(20,0),
	@per_kk decimal(15,2),@sum_perk decimal(20,0),@raznk decimal(20,0),
	@cena_k decimal(15,2)
	DECLARE @cur_org CURSOR
	-- Выбираем тариф №13
	/*SELECT @cena_t = AVG(cena) FROM datatarif
		WHERE kodtt = 13 and datan between @data1 and @data2
	print @cena_t*/
	SET @i=0
	WHILE @i<4 
	BEGIN 
		SET @cur_org = CURSOR FOR 
			SELECT a.kodorg,a.nazv,
				sum(ISNULL(b.gkot,0)+ISNULL(b.gkgv,0)),				
				sum(b.itog),
				sum(ISNULL(b.symnds,0)+ISNULL(b.symgvnds,0)+ISNULL(b.pertonds,0)+ISNULL(b.pergvnds,0)),
				sum(ISNULL(b.pgkto,0)+ISNULL(b.pgkvo,0)),
				sum(ISNULL(b.perto,0)+ISNULL(b.pergv,0)),
				sum(ISNULL(b.skybv,0)),				
				sum(b.itogv),
				sum(ISNULL(b.sumvnds,0)+ISNULL(b.perhonds,0)),
				sum(ISNULL(b.pkybvo,0)),
				sum(ISNULL(b.perho,0)),
				sum(ISNULL(b.skybk,0)),				
				sum(b.itogk),
				sum(ISNULL(b.sumknds,0)+ISNULL(b.perkonds,0)),
				sum(ISNULL(b.pkybko,0)),
				sum(ISNULL(b.perko,0))
				FROM org a,dataorg b 
				WHERE a.kodorg=b.kodorg and a.tiporg = @i 
				and b.datan between @data1 and @data2
				GROUP BY a.kodorg, a.nazv
				HAVING sum(b.itog+ISNULL(b.perto,0)+ISNULL(b.pergv,0)+ISNULL(b.gkot,0)+ISNULL(b.gkgv,0))+
        sum(ISNULL(b.skybv,0))+sum(ISNULL(b.skybk,0))+sum(ISNULL(b.perho,0))+sum(ISNULL(b.perko,0))!=0
				ORDER BY a.nazv 				
		OPEN @cur_org		
		FETCH NEXT FROM @cur_org INTO @kod,@nazv,@gk,@sum_nac,@sum_nds,@per_gk,@sum_per,
		@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk
		-- Заполняем данные по организации
		WHILE (@@FETCH_STATUS=0)
		BEGIN
			INSERT INTO gen_report_all (kod, nazv,gk,sum_nac,sum_nds,per_gk,sum_per,
			kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
			kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
			VALUES (@kod, @nazv,@gk,@sum_nac,@sum_nds,@per_gk,@sum_per,
			@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,
			@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk,@i)				
			FETCH NEXT FROM @cur_org INTO @kod,@nazv,@gk,@sum_nac,@sum_nds,@per_gk,@sum_per,
			@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk
		END
		CLOSE @cur_org
		DEALLOCATE @cur_org		
		-- Заполняем итоги
		IF @i = 0
			SET @nazv = 'ИТОГО ПО БЮДЖЕТУ:'
		IF @i = 1
			SET @nazv = 'ИТОГО ПО ХОЗРАСЧЕТУ:'
		IF @i = 2
			SET @nazv = 'ИТОГО ПО ЖСК:'
		IF @i = 3
			SET @nazv = 'ИТОГО ПО ЖСК - БСХА:'

		INSERT INTO gen_report_all (nazv,gk,sum_nac,sum_nds,per_gk,sum_per,
		kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
		kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
		SELECT @nazv,SUM(gk),SUM(sum_nac),SUM(sum_nds),SUM(per_gk),
  	SUM(sum_per),SUM(kv),SUM(sum_nacv),SUM(sum_ndsv),SUM(per_kv),SUM(sum_perv),
		SUM(kk),SUM(sum_nack),SUM(sum_ndsk),SUM(per_kk),SUM(sum_perk),@i+20
		FROM gen_report_all WHERE tip = @i	  
		SET @i = @i+1
	END
	SET @nazv = 'ИТОГО ПО ПРЕДПРИЯТИЮ:'
	INSERT INTO gen_report_all (nazv,gk,sum_nac,sum_nds,per_gk,sum_per,
	kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
	kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
	SELECT @nazv,SUM(gk),SUM(sum_nac),SUM(sum_nds),SUM(per_gk),
				 SUM(sum_per),SUM(kv),SUM(sum_nacv),SUM(sum_ndsv),SUM(per_kv),SUM(sum_perv),
		SUM(kk),SUM(sum_nack),SUM(sum_ndsk),SUM(per_kk),SUM(sum_perk),30
	FROM gen_report_all
	WHERE (tip < 4)	













GO