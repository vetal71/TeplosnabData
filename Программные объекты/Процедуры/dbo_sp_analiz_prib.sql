SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_analiz_prib]
	@data1 datetime, @data2 datetime
AS
	IF EXISTS (SELECT name 
			FROM sysobjects
			WHERE name = N'tAnalisPrib'		
			AND type = 'U')
		DROP TABLE tAnalisPrib
	CREATE TABLE tAnalisPrib
		(kod int, nazv varchar(100), gk decimal(15,2), 
		gkr decimal(15,2), pecent decimal(6,2))
	-- Объявление переменных
	DECLARE @cur_pr CURSOR, @kod int, @gko decimal(15,2), @gkd decimal(15,2)
	SET @cur_pr = CURSOR FOR
		SELECT kod FROM pribor ORDER BY kod
	OPEN @cur_pr
	FETCH NEXT FROM @cur_pr INTO @kod
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO tAnalisPrib (kod, nazv, gk)
			SELECT a.kod, a.nazp,
			SUM(ISNULL(b.gkt,0))
		FROM pribor a, dataprib b
		WHERE a.kod = b.kodpr AND b.datan between @data1 and @data2
		and a.kod = @kod
		GROUP BY a.kod, a.nazp 
		HAVING SUM(ISNULL(b.gkt,0)) != 0
		-- Обновляем
		SELECT 
			@gko = ROUND(SUM(a.q)*AVG(c.kdo)*AVG(c.kco)*
						(AVG(a.t)-AVG(c.srt))/(AVG(a.t)+27)/1000000,2)
			FROM obekt a, datakoteln c
			WHERE a.kodkot = c.kodkot and c.datan between @data1 and @data2
			and a.kodpr = @kod
		SELECT 
			@gkd = ROUND(SUM(a.qot)*AVG(c.kdo)*AVG(c.kco)*
						(18-AVG(c.srt))/45000000,2)
			FROM doma a, datakoteln c
			WHERE a.kodkot = c.kodkot and c.datan between @data1 and @data2
			and a.kodpr = @kod
		UPDATE tAnalisPrib
			SET gkr = (ISNULL(@gko,0) + ISNULL(@gkd,0)), 
			pecent = ROUND(gk/(ISNULL(@gko,1) + ISNULL(@gkd,1))*100,2)
		WHERE kod = @kod
		FETCH NEXT FROM @cur_pr INTO @kod
	END	
	CLOSE @cur_pr
  DEALLOCATE @cur_pr



GO