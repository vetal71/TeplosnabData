SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_calc_obk_g]
	@data datetime
AS
	-- Обновляем все объекы, кроме ЖСК
	UPDATE dataobekt
	SET
    symg=round(b.kybg*a.cenag,0),
    symgnds=round(b.kybg*a.cenag*c.nds/100,0),
    symgs=round((b.kybg*a.cenag)+(b.kybg*a.cenag*c.nds/100),0),
    pergnds=round((b.perg*c.nds/(100+c.nds)),0),
    rastarifg=a.cenag
	FROM	
		(datatarifg as a join dataobekt as b on (a.datan=b.datan)) join
    obekt as c on(a.kodtg=c.kodtg) and(c.kodobk=b.kodobk) 
  WHERE b.datan=@data and c.kodtg<>7
  
	-- Обновляем все объекы ЖСК
	UPDATE dataobekt
	SET
    kybg      = round((c.prj+c.prjl) * 0.073, 2),
    symg      = round((c.prj * a.cenag) + (c.prjl * a.cenag / 2),0),
    lsymg     = round((c.prjl * a.cenag / 2),0),
    lkybg     = round(0.073 * c.prjl, 2),
    symgnds   = 0,
    symgs     = round((c.prj * a.cenag) + (c.prjl * a.cenag / 2),0),
    pergnds   = 0,
    rastarifg = a.cenag
	FROM	
		(datatarifg as a join dataobekt as b on (a.datan=b.datan)) join
    obekt as c on(a.kodtg=c.kodtg) and(c.kodobk=b.kodobk)
    WHERE b.datan=@data and c.kodtg=7
GO