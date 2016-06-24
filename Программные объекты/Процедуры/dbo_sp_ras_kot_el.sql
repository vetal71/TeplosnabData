SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE  PROCEDURE [dbo].[sp_ras_kot_el]
@data1 datetime, @data2 datetime
AS
	DECLARE @cur_org CURSOR
	DECLARE @kod int
        DECLARE @nazvorg varchar(50)
        DECLARE @tip int
	-- Создаем таблицу
	IF EXISTS(SELECT name 
	  FROM 	 sysobjects 
	  WHERE  name = N'ras_kot_el' 
	  AND 	 type = 'U')
    DROP TABLE ras_kot_el
	CREATE TABLE ras_kot_el 
	(kod int, nazv varchar(50),tiporg int,
	 kybv decimal(15,2),kybvs decimal(15,2),
         kybk decimal(15,2),kybks decimal(15,2))
	-- Объявляем курсор
	SET @cur_org = CURSOR FOR 
		SELECT kodorg,nazv,tiporg FROM org ORDER BY kodorg
	OPEN @cur_org
	FETCH NEXT FROM @cur_org INTO @kod, @nazvorg, @tip
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Данные по льготе
		INSERT INTO ras_kot_el
		SELECT 
			@kod,@nazvorg,@tip,
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0)),0,
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0)),0			
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.ecnal = 0 and c.kodorg = @kod
		and b.datan between @data1 and @data2
                and a.mesto = 1
		HAVING (sum(isnull(b.kybv,0)+isnull(b.pkybv,0))+
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0))) !=0
		-- Обновляем
		UPDATE ras_kot_el
                SET kybvs = 
                (SELECT 
			sum(isnull(b.kybv,0)+isnull(b.pkybv,0))
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.ecnal = 0 and c.kodorg = @kod
		and b.datan between @data1 and @data2
                and a.mesto = 2
		HAVING (sum(isnull(b.kybv,0)+isnull(b.pkybv,0))) !=0
		),
                kybks = 
                (SELECT 
			sum(isnull(b.kybk,0)+isnull(b.pkybk,0))
		FROM koteln a, dataobekt b, obekt c
		WHERE a.kodkot = c.kodkot and b.kodobk = c.kodobk
		and c.ecnal = 0 and c.kodorg = @kod
		and b.datan between @data1 and @data2
                and a.mesto = 2
		HAVING (sum(isnull(b.kybk,0)+isnull(b.pkybk,0))) !=0
		)
                WHERE kod = @kod
		-- Следующая запись
		FETCH NEXT FROM @cur_org INTO @kod, @nazvorg, @tip
	END
	CLOSE @cur_org
	DEALLOCATE @cur_org


GO