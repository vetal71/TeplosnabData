SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE    PROCEDURE [dbo].[sp_verify_vyr]
	@data datetime, @rez varchar(1000) output
AS
	DECLARE @cur_kot CURSOR, @kod int, @r1 decimal(15,2), @r2 decimal(15,2),
	@err varchar(1000), @nazv varchar(100), @cnt int
	SET @cnt = 0
	SET @err = 'Сделайте пересписание топлива по участку '
	SET @rez = ''
	SET @cur_kot = CURSOR FOR 
		SELECT kodkot, nazk FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod, @nazv
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SELECT @r1 = ROUND(SUM(b.gkt+b.gkv+b.pgkt+b.pgkv),2)
			FROM obekt a, dataobekt b
			WHERE a.kodobk = b.kodobk and b.datan = @data and a.kodkot = @kod
		SELECT @r2 = ISNULL(SUM(r_ot+r_gv),-1)
			FROM datatop 
			WHERE datan = @data	and kodkot = @kod
		IF @r1 <> @r2 
		BEGIN
			IF @cnt >= 0 
				SET @rez = @rez + @nazv + ','			
			SET @cnt = @cnt + 1
			PRINT @rez
		END
		FETCH NEXT FROM @cur_kot INTO @kod, @nazv
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
	IF (@cnt>0)
		SET @rez = @err + @rez
		PRINT @rez


GO