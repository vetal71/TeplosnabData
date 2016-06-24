SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_Analiz_Org] 
	@data datetime -- Дата окончания периода
AS
	IF EXISTS (SELECT name 
			FROM sysobjects
			WHERE name = N'tAnalisOrg1'		
			AND type = 'U')
		DROP TABLE tAnalisOrg1
	CREATE TABLE tAnalisOrg1
		(kod int, nazv varchar(100), 
		 qot1 decimal(20,0), val1 decimal(15,2))
	IF EXISTS (SELECT name 
			FROM sysobjects
			WHERE name = N'tAnalisOrg2'		
			AND type = 'U')
		DROP TABLE tAnalisOrg2
	CREATE TABLE tAnalisOrg2
		(kod int, nazv varchar(100), 
		 qot11 decimal(20,0), val11 decimal(15,2))	
	DECLARE @qot1 decimal(20,0),@qot2 decimal(20,0),
	@data_s datetime, -- Начало текущего года
	@data_s1 datetime, -- Начало прошлого года
	@data1 datetime -- Конец прошлого периода
	-- Начало текущего года
	set @data_s = 
	convert(datetime,'1/1/'+convert(char(4),year(@data)),101)
	-- Конец прошлого периода
	set @data1 = dateadd(year,-1,@data)
	-- Начало прошлого года
	set @data_s1 = 
	convert(datetime,'1/1/'+convert(char(4),year(@data1)),101)	
	-- Добавляем в таблицу 1
	SELECT @qot1 = SUM(q) FROM obekt
		WHERE kodobk IN 
			(SELECT kodobk FROM dataobekt
				WHERE datan between @data_s and @data
				GROUP BY kodobk)
	SELECT @qot2 = SUM(qot) FROM doma
		WHERE koddom IN 
			(SELECT koddom FROM datadoma
				WHERE datan between @data_s and @data
				GROUP BY koddom)
	INSERT INTO tAnalisOrg1
	SELECT 1, 'Отопление',@qot1+@qot2, 
		(SELECT SUM(gkt) FROM dataobekt
			WHERE datan between @data_s and @data)
	INSERT INTO tAnalisOrg1
	SELECT 2, 'ГВС',Null, 
		(SELECT SUM(gkv) FROM dataobekt
			WHERE datan between @data_s and @data)
	INSERT INTO tAnalisOrg1
	SELECT 3, 'Водоснабжение',NULL, 
		(SELECT SUM(kybv) FROM dataobekt
			WHERE datan between @data_s and @data)
	INSERT INTO tAnalisOrg1
	SELECT 4, 'Водоотведение',NULL, 
		(SELECT SUM(kybk) FROM dataobekt
			WHERE datan between @data_s and @data)
	
	-- Добавляем в таблицу 2
	SELECT @qot1 = SUM(q) FROM obekt
		WHERE kodobk IN 
			(SELECT kodobk FROM arh_dataobekt
				WHERE datan between @data_s1 and @data1
				GROUP BY kodobk)
	SELECT @qot2 = SUM(qot) FROM doma
		WHERE koddom IN 
			(SELECT koddom FROM arh_datadoma
				WHERE datan between @data_s1 and @data1
				GROUP BY koddom)
	INSERT INTO tAnalisOrg2
	SELECT 1, 'Отопление',@qot1+@qot2, 
		(SELECT SUM(gkt) FROM arh_dataobekt
			WHERE datan between @data_s1 and @data1)
	INSERT INTO tAnalisOrg2
	SELECT 2, 'ГВС',Null, 
		(SELECT SUM(gkv) FROM arh_dataobekt
			WHERE datan between @data_s1 and @data1)
	INSERT INTO tAnalisOrg2
	SELECT 3, 'Водоснабжение',NULL, 
		(SELECT SUM(kybv) FROM arh_dataobekt
			WHERE datan between @data_s1 and @data1)
	INSERT INTO tAnalisOrg2
	SELECT 4, 'Водоотведение',NULL, 
		(SELECT SUM(kybk) FROM arh_dataobekt
			WHERE datan between @data_s1 and @data1)

GO