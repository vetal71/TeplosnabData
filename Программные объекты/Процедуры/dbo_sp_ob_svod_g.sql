SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_ob_svod_g]
	@data1 datetime, @data2 datetime
AS
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'gen_report_g' 
	  AND 	 type = 'U')
    DROP TABLE gen_report_g
    print 'Удалили таблу'
	CREATE TABLE gen_report_g 
	(kod int, nazv char(100), kg decimal(15,2),tarifg decimal(15,2),kod_tarifg int,
	 sum_nacg decimal(20,0),sum_ndsg decimal(20,0),
	 per_kg	decimal(15,2),sum_perg decimal(20,0),razng decimal(20,0),
	 tip int)
    print 'Создали таблу' 
	-- Собираем сведения
	DECLARE @i integer
	DECLARE @kod int, @nazv varchar(100),@kg decimal(15,2),@tarifg decimal(15,2),
	@kod_tarifg int,@sum_nacg decimal(20,0),@sum_ndsg decimal(20,0),
	@per_kg decimal(15,2),@sum_perg decimal(20,0),@razng decimal(20,0),
	@cena_g decimal(15,2)
	DECLARE @cur_org CURSOR
	-- Выбираем тариф по вед. жилью
	SELECT @cena_g = AVG(cenag) FROM datatarifg
		WHERE kodtg = 3 and datan between @data1 and @data2
    print 'Выбрали тариф'    
	SET @i=0
	WHILE @i<4 -- цикл по типам организаций
	BEGIN 
		SET @cur_org = CURSOR FOR 
			SELECT a.kodorg,a.nazv,
				sum(ISNULL(b.skybg,0)),				
				sum(b.itogg),
				sum(ISNULL(b.sumgnds,0)+ISNULL(b.PERGONDS,0)),
				sum(ISNULL(b.PKYBGO,0)),
				sum(ISNULL(b.pergo,0))
				FROM org a,dataorg b 
				WHERE a.kodorg=b.kodorg and a.tiporg = @i 
				and b.datan between @data1 and @data2
				GROUP BY a.kodorg, a.nazv
				HAVING sum(ISNULL(b.skybg,0))+sum(ISNULL(b.pergo,0)) !=0
				ORDER BY a.nazv 				
		OPEN @cur_org		
		FETCH NEXT FROM @cur_org INTO 
		@kod,@nazv,@kg,@sum_nacg,@sum_ndsg,@per_kg,@sum_perg
        
		print 'Заполняем данные по организации '+cast(@kod as varchar(5))
		
        WHILE (@@FETCH_STATUS=0)
		BEGIN
            print 'Пытаюсь вставить'
			INSERT INTO gen_report_g (kod, nazv, kg, sum_nacg, sum_ndsg, per_kg, sum_perg, tip)
			VALUES (@kod, @nazv, @kg, @sum_nacg, @sum_ndsg, @per_kg, @sum_perg, @i)
			print 'Заполняем данные по объектам'
			INSERT INTO gen_report_g (kod, nazv,
									kg,tarifg,kod_tarifg,
									sum_nacg,sum_ndsg,
									per_kg,sum_perg,
									tip)
			SELECT @kod, a.nazt,
						 SUM(ISNULL(b.kybg,0)),c.cenag, a.kodtg,
						 SUM(ISNULL(b.symgs,0)),SUM(ISNULL(b.symgnds,0)+ISNULL(b.pergnds,0)),
						 SUM(ISNULL(b.pkybg,0)),SUM(ISNULL(b.perg,0)),	
						 @i+10						 								 
			FROM tarifg a, dataobekt b, datatarifg c, obekt d
			WHERE a.kodtg = d.kodtg and b.datan = c.datan and
						a.kodtg = c.kodtg and b.kodobk = d.kodobk and d.kodorg = @kod
						and b.datan between @data1 and @data2
			GROUP BY a.nazt,c.cenag, a.kodtg
			ORDER BY a.kodtg
            print 'Заполнили по организации '+cast(@kod as varchar(5))
			-- Обновляем разницу
			/*SELECT @raznv = ROUND(@cena_v*SUM(ISNULL(b.kybv,0))
						 -SUM(ISNULL(b.symhs,0)),0),
						 @raznv = ROUND(@cena_k*SUM(ISNULL(b.kybk,0))
						 -SUM(ISNULL(b.symks,0)),0)
			FROM obekt a,dataobekt b WHERE a.kodobk = b.kodobk and a.kodtv = 7
					 and b.datan between @data1 and @data2 and a.kodorg = @kod*/
			print 'Обновляем по объектам'                     
			UPDATE gen_report_g 
			SET razng = round((@cena_g-tarifg)*kg,0)
			WHERE kod_tarifg = 3 and tip = @i+10 and kod = @kod
			
            FETCH NEXT FROM @cur_org INTO 
			@kod,@nazv,@kg,@sum_nacg,@sum_ndsg,@per_kg,@sum_perg
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
		INSERT INTO gen_report_g (nazv,kg,sum_nacg,sum_ndsg,per_kg,sum_perg,tip)
		SELECT @nazv,SUM(kg),SUM(sum_nacg),SUM(sum_ndsg),SUM(per_kg),SUM(sum_perg),@i+20
		FROM gen_report_g WHERE tip = @i
	  SELECT @razng = SUM(razng)
		FROM gen_report_g WHERE tip = @i+10		
		UPDATE gen_report_g SET razng = @razng WHERE tip = @i+20
		SET @i = @i+1
	END
	SET @nazv = 'ИТОГО ПО ПРЕДПРИЯТИЮ:'
	INSERT INTO gen_report_g (nazv,kg,sum_nacg,sum_ndsg,per_kg,sum_perg,tip)
		SELECT @nazv,SUM(kg),SUM(sum_nacg),SUM(sum_ndsg),SUM(per_kg),SUM(sum_perg),30
	FROM gen_report_g
	WHERE (tip < 4)
    
	SELECT @razng = SUM(razng)
	FROM gen_report_g 
	WHERE (tip > 19) and (tip < 30)
	UPDATE gen_report_g SET razng = @razng WHERE tip = 30
GO