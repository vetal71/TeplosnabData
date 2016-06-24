SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE       PROCEDURE [dbo].[up_datatarif]
	@kod int, @cena1 decimal(15,2), @cena2 decimal(15,2), @data datetime, @oper int
AS
	DECLARE @cnt int
	IF @oper = 1 
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarif 
			WHERE kodtt = @kod and datan = @data
		IF @cnt <> 0
			UPDATE datatarif SET cena = @cena1 
			WHERE kodtt = @kod and datan = @data
	END
	IF @oper = 11 -- Режим обновления цены добавленной записи
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarif 
			WHERE cena Is Null and datan Is Null
		IF @cnt <> 0
			UPDATE datatarif 
				SET cena = @cena1, 
				datan = @data, 
				datak = teplosnab.dbo.end_of_month(@data)
			WHERE cena Is Null and datan Is Null
	END
	IF @oper = 2 -- Режим обновления цены (вода)
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarifv
			WHERE kodtv = @kod and datan = @data
		IF @cnt <> 0
			UPDATE datatarifv SET cenav = @cena1, cenak = @cena2
			WHERE kodtv = @kod and datan = @data		
	END
	IF @oper = 22 -- Режим обновления цены добавленной записи (вода)
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarifv
			WHERE cenav Is Null and datan Is Null
		IF @cnt <> 0
			UPDATE datatarifv 
				SET cenav = @cena1,
				cenak = @cena2, 
				datan = @data, 
				datak = teplosnab.dbo.end_of_month(@data)
			WHERE cenav Is Null and datan Is Null					
	END
    -- Обновление записей по мусору
    IF @oper = 3 
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarifg 
			WHERE kodtg = @kod and datan = @data
		IF @cnt <> 0
			UPDATE datatarifg SET cenag = @cena1 
			WHERE kodtg = @kod and datan = @data
	END
	IF @oper = 31 -- Режим обновления цены добавленной записи
	BEGIN
		-- Проверяем наличие записи
		SELECT @cnt = count(*) FROM datatarifg 
			WHERE cenag Is Null and datan Is Null
		IF @cnt <> 0
			UPDATE datatarifg 
				SET cenag = @cena1, 
				datan = @data, 
				datak = teplosnab.dbo.end_of_month(@data)
			WHERE cenag Is Null and datan Is Null
	END
GO