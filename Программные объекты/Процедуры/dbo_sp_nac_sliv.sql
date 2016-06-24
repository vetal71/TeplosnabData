SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE    PROCEDURE [dbo].[sp_nac_sliv]
	@kodobk int, @koltop decimal(10,1), @kolch decimal(10,4), @gkt decimal(15,2), 
	@data datetime
AS
	IF EXISTS (SELECT kodobk FROM koltop WHERE kodobk = @kodobk and
		datan = @data)
		UPDATE koltop SET koltop = @koltop, kolch = @kolch
			WHERE datan = @data and datan = @data
	ELSE
		INSERT INTO koltop (kodobk,koltop,kolch,datan,datak)
			VALUES(@kodobk, @koltop, @kolch, @data, teplosnab.dbo.end_of_month(@data))
	-- Обновляем данные по объекту
	UPDATE dataobekt SET gkt = @gkt, st = 1 WHERE kodobk = @kodobk and datan = @data


GO