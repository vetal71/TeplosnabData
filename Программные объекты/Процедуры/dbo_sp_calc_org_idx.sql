SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE       PROCEDURE [dbo].[sp_calc_org_idx]
	@kod  int,
	@data datetime
AS	
    
    UPDATE dataorg 
    SET 
    	ndsidx  = round((symidx*20/(120)),0),
        ndsidxv = round((symidxv*20/(120)),0),
        ndsidxk = round((symidxk*20/(120)),0),
        itog    = symtv + perto, 
        itogv   = sumvv + perho, 
        itogk   = sumkk + perko
	WHERE kodorg=@kod and datan=@data
GO