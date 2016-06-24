SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO







CREATE       PROCEDURE [dbo].[sp_calc_org]
	@data datetime
AS
	DECLARE @id_org int,@sym decimal(15),
	@symgv decimal(15),@symnds decimal(15),
  @symgvnds decimal(15),@symtv decimal(15),
	@symgvs decimal(15),@pert decimal(15),
	@pergv decimal(15),@pgkt decimal(15,2),
  @pgkv decimal(15,2),@pertnds decimal(15),
	@pergvnds decimal(15),@gkot decimal(15,2),
	@gkgv decimal(15,2),@lsymot decimal(15),
	@lgkot decimal(15,2),@lsymgv decimal(15),
	@lgkgv decimal(15,2)
	-- Объявляем курсор
	DECLARE cur_org CURSOR FOR
	SELECT b.kodorg,
		isnull(SUM(symt),0),
		isnull(SUM(symv),0),
		isnull(SUM(symtnds),0),
		isnull(SUM(symvnds),0),
		isnull(SUM(gkt),0),
		isnull(SUM(gkv),0),
		isnull(SUM(symk),0),
		isnull(SUM(symgv),0),
    		isnull(SUM(pert),0),
		isnull(SUM(perv),0),
		isnull(SUM(pgkt),0),
		isnull(SUM(pgkv),0),
		isnull(SUM(pertnds),0),
		isnull(SUM(pervnds),0),
		isnull(SUM(lsymt),0),
		isnull(SUM(lgkt),0),
		isnull(SUM(lsymv),0),
		isnull(SUM(lgkv),0)
    FROM dataobekt as a join obekt as b on a.kodobk=b.kodobk
    WHERE a.datan=@data
    GROUP BY b.kodorg
	OPEN cur_org	
	FETCH NEXT FROM cur_org INTO @id_org, 
	@sym,@symgv,@symnds,
	@symgvnds,@gkot,@gkgv,@symtv,@symgvs,
	@pert,@pergv,@pgkt,@pgkv,@pertnds,
	@pergvnds,@lsymot,@lgkot,@lsymgv,@lgkgv
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		-- Анализ данных
		print 'Считаю '+Cast(@id_org as varchar(4))
		IF (SELECT count(*) FROM dataorg WHERE kodorg = @id_org and datan = @data)=0
			INSERT INTO dataorg (kodorg,datan,datak)
				SELECT kodorg,@data,teplosnab.dbo.end_of_month(@data) FROM org
					WHERE kodorg = @id_org
		UPDATE dataorg 
		SET sym=@sym,sumgv=@symgv,symnds=@symnds,symgvnds=@symgvnds,symtv=@symtv,
    symgvs=@symgvs,perto=@pert,pergv=@pergv,pgkto=@pgkt,pgkvo=@pgkv,
		pertonds=@pertnds,pergvnds=@pergvnds,gkot=@gkot,gkgv=@gkgv,
		lsymot=@lsymot,lgkot=@lgkot,lsymgv=@lsymgv,lgkgv=@lgkgv,
		itog=@symtv+@symgvs+@pert+@pergv
    WHERE kodorg=@id_org and datan=@data 
		FETCH NEXT FROM cur_org INTO @id_org, 
		@sym,@symgv,@symnds,
		@symgvnds,@gkot,@gkgv,@symtv,@symgvs,
		@pert,@pergv,@pgkt,@pgkv,@pertnds,
		@pergvnds,@lsymot,@lgkot,@lsymgv,@lgkgv
	END
	DEALLOCATE cur_org






GO