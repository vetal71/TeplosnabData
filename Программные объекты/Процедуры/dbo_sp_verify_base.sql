SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[sp_verify_base] 
	@id_object integer
AS
	/*Очищаем таблицу ошибок*/    
  DELETE FROM temp_err
	DECLARE @kod integer -- Объявляем код поиска
	DECLARE @cnt integer -- Объявляем счетчик записей

	IF @id_object = 0 -- Выбрана для проверки таблица Org
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodorg FROM org
			OPEN tables_cursor			
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу org по начислению*/				
				SELECT @cnt = count(*) FROM dataorg WHERE kodorg = @kod
				IF @cnt = 0 -- В таблице данных начисление (dataorg) не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты в таблице dataorg по организации с кодом '+cast(@kod as char),
									'org','Предупреждение',0,'','Проверить начисление по объектам или удалить организацию')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodorg FROM dataorg GROUP BY kodorg
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу org по начислению*/
				SELECT @cnt = count(*) FROM org WHERE kodorg = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленной организации с кодом '+cast(@kod as char),
									'dataorg','Нарушена связь',0,'kodorg='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь по приборам*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodorg FROM pribor GROUP BY kodorg
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM org WHERE kodorg = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены приборы по удаленной организации с кодом '+cast(@kod as char),
									'dataorg','Нарушена связь',0,'kodorg='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем объекты*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodorg FROM org
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt*/
				SELECT @cnt = count(*) FROM obekt WHERE kodorg = @kod
				IF @cnt = 0 -- В таблице obekt не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены объекты по организации с кодом '+cast(@kod as char),
									'org','Предупреждение',0,'','Добавить объекты или удалить организацию')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
			/*Проверяем обратную связь c объектом*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodorg FROM obekt GROUP BY kodorg
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу org по начислению*/
				SELECT @cnt = count(*) FROM org WHERE kodorg = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены объекты по удаленной организации с кодом '+cast(@kod as char),
									'obekt','Нарушена связь',0,'kodorg='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	IF @id_object = 1 -- Выбрана для проверки таблица Obekt
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodobk FROM obekt
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM dataobekt WHERE kodobk = @kod
				IF @cnt = 0 -- В таблице данных начисление (dataobekt) не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты в таблице dataobekt по объекту с кодом '+cast(@kod as char),
									'obekt','Предупреждение',1,'','Проверить начисление по объектам или удалить объекты')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodobk FROM dataobekt GROUP BY kodobk
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM obekt WHERE kodobk = @kod
				IF @cnt = 0 -- В таблице obekt не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленному объекту с кодом '+cast(@kod as char),
									'dataobekt','Нарушена связь',1,'kodobk='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodobk FROM danobk GROUP BY kodobk
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM obekt WHERE kodobk = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены записи с историей по удаленному объекту с кодом '+cast(@kod as char),
									'danobk','Нарушена связь',1,'kodobk='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с квартирами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodobk FROM kvart GROUP BY kodobk
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM obekt WHERE kodobk = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены квартиры по удаленному объекту с кодом '+cast(@kod as char),
									'kvart','Нарушена связь',1,'kodobk='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с топливом*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodobk FROM koltop GROUP BY kodobk
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM obekt WHERE kodobk = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены данные разогрева мазута по удаленному объекту с кодом '+cast(@kod as char),
									'koltop','Нарушена связь',1,'kodobk='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	IF @id_object = 2 -- Выбрана для проверки таблица koteln
	BEGIN
		/*Проверяем историю*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM koteln
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу dankot*/
				SELECT @cnt = count(*) FROM dankot WHERE kodkot = @kod
				IF @cnt = 0 -- В таблице данных начисление (dataobekt) не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены записи с историей по удаленной котельной с кодом '+cast(@kod as char),
									'dankot','Нарушение связи',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с объектами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM obekt GROUP BY kodkot
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM koteln WHERE kodkot = @kod
				IF @cnt = 0 -- В таблице koteln не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены объекты по удаленной котельной с кодом '+cast(@kod as char),
									'obekt','Нарушена связь',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с домами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM doma GROUP BY kodkot
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM koteln WHERE kodkot = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены дома по удаленной котельной с кодом '+cast(@kod as char),
									'doma','Нарушена связь',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с приборами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM pribor GROUP BY kodkot
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM koteln WHERE kodkot = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены приборы по удаленной котельной с кодом '+cast(@kod as char),
									'pribor','Нарушена связь',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем связь с расчетами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM koteln
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datakoteln WHERE kodkot = @kod
				IF @cnt = 0 
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты по котельной с кодом '+cast(@kod as char),
									'koteln','Предупреждение',2,'','Проверить расчеты')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с расчетами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM datakoteln GROUP BY kodkot
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM koteln WHERE kodkot = @kod
				IF @cnt = 0 
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленной котельной с кодом '+cast(@kod as char),
									'datakoteln','Нарушена связь',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем связь с топливом*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM koteln
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datatoplivo WHERE kodkot = @kod
				IF @cnt = 0 
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены списания по котельной с кодом '+cast(@kod as char),
									'koteln','Предупреждение',2,'','Проверить списание')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь со списанием*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkot FROM datatoplivo GROUP BY kodkot
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM koteln WHERE kodkot = @kod
				IF @cnt = 0 
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены списания по удаленной котельной с кодом '+cast(@kod as char),
									'datatoplivo','Нарушена связь',2,'kodkot='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
 	/*Конец проверки котельных*/
	/*Проверяем приборы*/
	IF @id_object = 3 -- Выбрана для проверки таблица pribor
	BEGIN
		/*Проверяем расчеты*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kod FROM pribor
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу dataprib*/
				SELECT @cnt = count(*) FROM dataprib WHERE kodpr = @kod
				IF @cnt = 0 -- В таблице данных начисление (dataobekt) не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты по прибору с кодом '+cast(@kod as char),
									'pribor','Нарушение связи',3,'','Проверить расчеты')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodpr FROM dataprib GROUP BY kodpr
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM pribor WHERE kod = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленному прибору с кодом '+cast(@kod as char),
									'dataprib','Нарушена связь',3,'kodpr='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с домами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodpr FROM doma GROUP BY kodpr
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM pribor WHERE kod = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены дома по удаленному прибору с кодом '+cast(@kod as char),
									'doma','Нарушена связь',3,'kodpr='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с объектами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodpr FROM obekt GROUP BY kodpr
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM pribor WHERE kod = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены объекты по удаленному прибору с кодом '+cast(@kod as char),
									'obekt','Нарушена связь',3,'kodpr='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor		
	END
	/*Конец проверки приборов*/
	IF @id_object = 4 -- Выбрана для проверки таблица Doma
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT koddom FROM doma
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datadoma WHERE koddom = @kod
				IF @cnt = 0 -- В таблице данных начисление (dataobekt) не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты в таблице datadoma по объекту с кодом '+cast(@kod as char),
									'doma','Предупреждение',4,'','Проверить начисление по домам или удалить дома')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT koddom FROM datadoma GROUP BY koddom
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM doma WHERE koddom = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленному дому с кодом '+cast(@kod as char),
									'datadoma','Нарушена связь',4,'koddom='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT koddom FROM dandoma GROUP BY koddom
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM doma WHERE koddom = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены записи с историей по удаленному дому с кодом '+cast(@kod as char),
									'dandoma','Нарушена связь',4,'koddom='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем связь с квартирами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT koddom FROM doma
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM kvart WHERE koddom = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены квартиры по дому с кодом '+cast(@kod as char),
									'doma','Предупреждение',4,'','Добавить квартиры или удалить дом')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь с квартирами*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT koddom FROM kvart GROUP BY koddom
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM doma WHERE koddom = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены квартиры по удаленному дому с кодом '+cast(@kod as char),
									'kvart','Нарушена связь',4,'koddom='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	/*Конец проверки домов*/
	IF @id_object = 5 -- Выбрана для проверки таблица Kvart
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkv FROM kvart
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datakvart WHERE kodkv = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены расчеты по квартире с кодом '+cast(@kod as char),
									'doma','Предупреждение',5,'','Проверить начисление по квартире')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkv FROM datakvart GROUP BY kodkv
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM kvart WHERE kodkv = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены расчеты по удаленной квартире с кодом '+cast(@kod as char),
									'datakvart','Нарушена связь',5,'kodkv='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodkv FROM dankvart GROUP BY kodkv
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM kvart WHERE kodkv = @kod
				IF @cnt = 0 -- В таблице org не найдено записей
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены записи с историей по удаленной квартире с кодом '+cast(@kod as char),
									'dankvart','Нарушена связь',4,'kodkv='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	/*Конец проверки квартир*/
	IF @id_object = 6 -- Выбрана для проверки таблица Tarift
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtt FROM tarift
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datatarif WHERE kodtt = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены данные по тарифу (тепло) с кодом '+cast(@kod as char),
									'tarift','Предупреждение',6,'','Проверить данные по тарифу')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtt FROM datatarif GROUP BY kodtt
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM tarift WHERE kodtt = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены данные по удаленному тарифу (тепло) с кодом '+cast(@kod as char),
									'datatarif','Нарушена связь',6,'kodtt='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtt FROM obekt GROUP BY kodtt
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM tarift WHERE kodtt = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены объекты по удаленному тарифу (тепло) с кодом '+cast(@kod as char),
									'obekt','Нарушена связь',6,'kodtt='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	/*Конец проверки тарифа (тепло)*/
	IF @id_object = 7 -- Выбрана для проверки таблица Tarifv
	BEGIN
		/*Проверяем начисления*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtv FROM tarifv
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM datatarifv WHERE kodtv = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Не найдены данные по тарифу (вода) с кодом '+cast(@kod as char),
									'tarifv','Предупреждение',7,'','Проверить данные по тарифу')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtv FROM datatarifv GROUP BY kodtv
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				/*Проверяем таблицу obekt по начислению*/
				SELECT @cnt = count(*) FROM tarifv WHERE kodtv = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены данные по удаленному тарифу (вода) с кодом '+cast(@kod as char),
									'datatarifv','Нарушена связь',7,'kodtv='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodtv FROM obekt GROUP BY kodtv
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM tarifv WHERE kodtv = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены объекты по удаленному тарифу (вода) с кодом '+cast(@kod as char),
									'obekt','Нарушена связь',7,'kodtv='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor
	END
	/*Конец проверки тарифа (вода)*/
	IF @id_object = 8 -- Выбрана для проверки таблица Ulica
	BEGIN		
		/*Проверяем обратную связь*/
		DECLARE tables_cursor CURSOR
    	FOR
   		SELECT kodul FROM doma GROUP BY kodul
			OPEN tables_cursor
			FETCH NEXT FROM tables_cursor INTO @kod
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				SELECT @cnt = count(*) FROM ulica WHERE kodul = @kod
				IF @cnt = 0
					INSERT INTO temp_err (nazv_err,tablename_err,tip_err,kod_obj,filter_sql,recomendation)
					VALUES ('Найдены дома по удаленной улице с кодом '+cast(@kod as char),
									'doma','Нарушена связь',8,'kodul='+cast(@kod as char),'Исправить ошибки')				
			  FETCH NEXT FROM tables_cursor INTO @kod
			END
		DEALLOCATE tables_cursor		
	END
	/*Конец проверки улиц*/
GO