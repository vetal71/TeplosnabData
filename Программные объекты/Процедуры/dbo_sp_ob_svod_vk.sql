SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE         PROCEDURE [dbo].[sp_ob_svod_vk]
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'gen_report_vk' 
	  AND 	 type = 'U')
    DROP TABLE gen_report_vk
    print 'Удалили таблу'
	CREATE TABLE gen_report_vk 
	(kod int, nazv char(100),kv decimal(15,2),tarifv decimal(15,2),kod_tarifv int,
	 sum_nacv decimal(20,0),sum_ndsv decimal(20,0),
	 per_kv	decimal(15,2),sum_perv decimal(20,0),raznv decimal(20,0),
	 kk decimal(15,2),tarifk decimal(15,2),kod_tarifk int,
	 sum_nack decimal(20,0),sum_ndsk decimal(20,0),
	 per_kk	decimal(15,2),sum_perk decimal(20,0),raznk decimal(20,0),
	 tip int)
    print 'Создали таблу' 
	-- Собираем сведения
	DECLARE @i integer
	DECLARE @kod int, @nazv varchar(100),@kv decimal(15,2),@tarifv decimal(15,2),
	@kod_tarifv int,@sum_nacv decimal(20,0),@sum_ndsv decimal(20,0),
	@per_kv decimal(15,2),@sum_perv decimal(20,0),@raznv decimal(20,0),
	@cena_v decimal(15,2),
  @kk decimal(15,2),@tarifk decimal(15,2),
	@kod_tarifk int,@sum_nack decimal(20,0),@sum_ndsk decimal(20,0),
	@per_kk decimal(15,2),@sum_perk decimal(20,0),@raznk decimal(20,0),
	@cena_k decimal(15,2)
	DECLARE @cur_org CURSOR
	-- Выбираем тариф №13
	SELECT @cena_v = AVG(cenav),@cena_k = AVG(cenak)  FROM datatarifv
		WHERE kodtv = 8 and datan between @data1 and @data2
    print 'Выбрали тариф'    
	SET @i=0
	WHILE @i<4 
	BEGIN 
		SET @cur_org = CURSOR FOR 
			SELECT a.kodorg,a.nazv,
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
				HAVING sum(ISNULL(b.skybv,0))+sum(ISNULL(b.skybk,0))+sum(ISNULL(b.perho,0))+sum(ISNULL(b.perko,0)) !=0
				ORDER BY a.nazv 				
		OPEN @cur_org		
		FETCH NEXT FROM @cur_org INTO 
		@kod,@nazv,@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,
		@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk
		print 'Заполняем данные по организации '+cast(@kod as varchar(5))
		WHILE (@@FETCH_STATUS=0)
		BEGIN
            print 'Пытаюсь вставить'
			INSERT INTO gen_report_vk (kod, nazv,kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
			kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
			VALUES (@kod, @nazv,@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,
			@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk,@i)
			print 'Заполняем данные по объектам'
			INSERT INTO gen_report_vk (kod, nazv,
									kv,tarifv,kod_tarifv,
									sum_nacv,sum_ndsv,
									per_kv,sum_perv,
									kk,tarifk,kod_tarifk,sum_nack,sum_ndsk,
									per_kk,sum_perk,tip)
			SELECT @kod, a.nazt,
						 SUM(ISNULL(b.kybv,0)),c.cenav,a.kodtv,
						 SUM(ISNULL(b.symhs,0)),SUM(ISNULL(b.symhnds,0)+ISNULL(b.perhnds,0)),
						 SUM(ISNULL(b.pkybv,0)),SUM(ISNULL(b.perh,0)),
						 SUM(ISNULL(b.kybk,0)),c.cenak,a.kodtv,
						 SUM(ISNULL(b.symks,0)),SUM(ISNULL(b.symknds,0)+ISNULL(b.perknds,0)),
						 SUM(ISNULL(b.pkybk,0)),SUM(ISNULL(b.perk,0)),	
						 @i+10						 								 
			FROM tarifv a,dataobekt b,datatarifv c,obekt d
			WHERE a.kodtv = d.kodtv and b.datan = c.datan and
						a.kodtv = c.kodtv and b.kodobk = d.kodobk and d.kodorg = @kod
						and b.datan between @data1 and @data2
			GROUP BY a.nazt,c.cenav,a.kodtv,c.cenak
			ORDER BY a.kodtv
            print 'Заполнили по организации '+cast(@kod as varchar(5))
			-- Обновляем разницу
			/*SELECT @raznv = ROUND(@cena_v*SUM(ISNULL(b.kybv,0))
						 -SUM(ISNULL(b.symhs,0)),0),
						 @raznv = ROUND(@cena_k*SUM(ISNULL(b.kybk,0))
						 -SUM(ISNULL(b.symks,0)),0)
			FROM obekt a,dataobekt b WHERE a.kodobk = b.kodobk and a.kodtv = 7
					 and b.datan between @data1 and @data2 and a.kodorg = @kod*/
			print 'Обновляем по объектам'                     
			UPDATE gen_report_vk 
			SET raznv = round((@cena_v-tarifv)*kv,0), 
			raznk = round((@cena_k-tarifk)*kk,0)
			WHERE kod_tarifv = 7 and tip = @i+10 and kod = @kod
			FETCH NEXT FROM @cur_org INTO 
			@kod,@nazv,@kv,@sum_nacv,@sum_ndsv,@per_kv,@sum_perv,
			@kk,@sum_nack,@sum_ndsk,@per_kk,@sum_perk
			print 'Следующая '+cast(@kod as varchar(5))
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
		INSERT INTO gen_report_vk (nazv,kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
		kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
		SELECT @nazv,SUM(kv),SUM(sum_nacv),SUM(sum_ndsv),SUM(per_kv),SUM(sum_perv),
					 SUM(kk),SUM(sum_nack),SUM(sum_ndsk),SUM(per_kk),SUM(sum_perk),@i+20
		FROM gen_report_vk WHERE tip = @i
	  SELECT @raznv = SUM(raznv),@raznk = SUM(raznk)
		FROM gen_report_vk WHERE tip = @i+10		
		UPDATE gen_report_vk SET raznv = @raznv,raznk = @raznk  WHERE tip = @i+20
		SET @i = @i+1
	END
	SET @nazv = 'ИТОГО ПО ПРЕДПРИЯТИЮ:'
	INSERT INTO gen_report_vk (nazv,kv,sum_nacv,sum_ndsv,per_kv,sum_perv,
		kk,sum_nack,sum_ndsk,per_kk,sum_perk,tip)
		SELECT @nazv,SUM(kv),SUM(sum_nacv),SUM(sum_ndsv),SUM(per_kv),SUM(sum_perv),
					 SUM(kk),SUM(sum_nack),SUM(sum_ndsk),SUM(per_kk),SUM(sum_perk),30
	FROM gen_report_vk
	WHERE (tip < 4)
    
	SELECT @raznv = SUM(raznv),@raznk = SUM(raznk)
	FROM gen_report_vk 
	WHERE (tip > 19) and (tip < 30)
	UPDATE gen_report_vk SET raznv = @raznv,raznk = @raznk WHERE tip = 30
GO