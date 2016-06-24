SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_calc_org_vk]
	@data datetime
AS
	DECLARE @id_org integer,@symh decimal(15),
	@symhnds decimal(15),@symhs decimal(15),@perh decimal(15),
	@perk decimal(15),@pkybv decimal(15,2),@pkybk decimal(15,2),
	@perhnds decimal(15),@symkk decimal(15),@symknds decimal(15),
	@symks decimal(15),@perknds decimal(15),@skybv decimal(15,2),
	@skybk decimal(15,2),@lsumv decimal(15),@lskybv decimal(15,2),
	@lsumk decimal(15),@lskybk decimal(15,2)
	DECLARE cur_org CURSOR FOR
	SELECT a.kodorg,
		SUM(symh),SUM(symhnds),
    SUM(symhs),SUM(symkk),
    SUM(symknds),SUM(symks),
    SUM(perh),SUM(perk),
    SUM(kybv),SUM(kybk),
    SUM(pkybv),SUM(perhnds),
    SUM(pkybk),SUM(perknds),
    SUM(lkybv),SUM(lsymh),
    SUM(lkybk),SUM(lsymkk)
    FROM obekt as a join dataobekt as b on a.kodobk=b.kodobk
    WHERE b.datan=@data
    GROUP BY a.kodorg
	OPEN cur_org
	FETCH NEXT FROM cur_org INTO @id_org,
		@symh,@symhnds,
		@symhs,@symkk,
		@symknds,@symks,
		@perh,@perk,
		@skybv,@skybk,
		@pkybv,@perhnds,
		@pkybk,@perknds,
		@lsumv,@lskybv,@lsumk,@lskybk
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		UPDATE dataorg SET sumv=@symh,sumvnds=@symhnds,sumvv=@symhs,
    perho=@perh,perko=@perk,pkybvo=@pkybv,pkybko=@pkybk,perhonds=@perhnds,
		itogv=@symhs+@perh,
    sumk=@symkk,sumknds=@symknds,sumkk=@symks,perkonds=@perknds,
		itogk=@symks+@perk,
    skybv=@skybv,skybk=@skybk,lsumv=@lsumv,lskybv=@lskybv,lsumk=@lsumk,
		lskybk=@lskybk
    WHERE kodorg=@id_org and datan=@data
		FETCH NEXT FROM cur_org INTO @id_org,
		@symh,@symhnds,
		@symhs,@symkk,
		@symknds,@symks,
		@perh,@perk,
		@skybv,@skybk,
		@pkybv,@perhnds,
		@pkybk,@perknds,
		@lsumv,@lskybv,@lsumk,@lskybk
	END
	DEALLOCATE cur_org

GO