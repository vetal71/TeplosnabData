SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_normativ]
	@data datetime
AS
	IF EXISTS (SELECT name 
			FROM sysobjects
			WHERE name = N'tFactNormativ'		
			AND type = 'U')
		DROP TABLE tFactNormativ
	CREATE TABLE tFactNormativ
		(kod int, nazv varchar(100), adres varchar(100),
		 gkt decimal(15,2), so decimal(15,2), n_ot decimal(15,5))
	DECLARE @cur_kot CURSOR, @kod int
	SET @cur_kot = CURSOR FOR 
		SELECT kodkot FROM koteln ORDER BY kodkot
	OPEN @cur_kot
	FETCH NEXT FROM @cur_kot INTO @kod
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		INSERT INTO tFactNormativ
		SELECT TOP 5 a.kodkot, a.nazk, (d.nazvul+','+c.ndom),
					 b.gkt, c.so, round(b.gkt/c.so,5)
		FROM koteln a,datadoma b,
		 doma c, ulica d, pribor e, dataprib f
		WHERE a.kodkot = c.kodkot and b.koddom=c.koddom and c.kodul=d.kodul
			and c.kodpr = e.kod and e.kod = f.kodpr and b.datan=f.datan
			and b.datan=@data and c.so>1 and f.gkt!=0 and b.gkt!=0 and f.kodpr>1
			and a.kodkot = @kod
	  ORDER BY cast(round(b.gkt/c.so,5) as varchar(100)) desc
		INSERT INTO tFactNormativ
		SELECT kod,'ИТОГО',NULL,sum(gkt),sum(so), sum(gkt)/sum(so)
			FROM tFactNormativ
			WHERE kod = @kod
			GROUP BY kod			
		FETCH NEXT FROM @cur_kot INTO @kod
	END
	CLOSE @cur_kot
	DEALLOCATE @cur_kot
GO