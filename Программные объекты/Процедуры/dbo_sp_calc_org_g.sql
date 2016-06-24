SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_calc_org_g]
	@data datetime
AS
	DECLARE @id_org integer,
            @symg decimal(15),
			@symgnds decimal(15),
            @symgs decimal(15),
            @perg decimal(15),
		    @pkybg decimal(15,2),
			@pergnds decimal(15),
			@skybg decimal(15,2),
			@lsumg decimal(15),
            @lskybg decimal(15,2)
-- Декларируем курсор            
	DECLARE cur_org CURSOR FOR
	SELECT a.kodorg,
		SUM(symg),
        SUM(symgnds),
    	SUM(symgs),
	    SUM(perg),
    	SUM(kybg),
    	SUM(pkybg),
        SUM(pergnds),
	    SUM(lkybg),
        SUM(lsymg)
    FROM obekt as a join dataobekt as b on a.kodobk=b.kodobk
    WHERE b.datan=@data
    GROUP BY a.kodorg
	OPEN cur_org
	FETCH NEXT FROM cur_org INTO @id_org,
		@symg,
        @symgnds,
		@symgs,
		@perg,
		@skybg,
		@pkybg,
        @pergnds,
        @lskybg,
		@lsumg
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		UPDATE dataorg SET sumg=@symg,sumgnds=@symgnds,sumgg=@symgs,
    pergo=@perg,pkybgo=@pkybg,pergonds=@pergnds,
		itogg=@symgs+@perg,
    skybg=@skybg,lsumg=@lsumg,lskybg=@lskybg
    WHERE kodorg=@id_org and datan=@data
		FETCH NEXT FROM cur_org INTO @id_org,
		@symg,
        @symgnds,
		@symgs,
		@perg,
		@skybg,
		@pkybg,
        @pergnds,
        @lskybg,
		@lsumg
	END
	DEALLOCATE cur_org
GO