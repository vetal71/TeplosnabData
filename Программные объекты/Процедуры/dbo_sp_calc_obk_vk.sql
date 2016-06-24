SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_calc_obk_vk]
	@data datetime
AS
	-- Обновляем все объекы, кроме ЖСК
	UPDATE dataobekt
	SET
    symh=round(b.kybv*a.cenav,0),
		symkk=round(b.kybk*a.cenak,0),
    symhnds=round(b.kybv*a.cenav*c.nds/100,0),
		symknds=round(b.kybk*a.cenak*c.nds/100,0),
    symhs=round((b.kybv*a.cenav)+(b.kybv*a.cenav*c.nds/100),0),
		symks=round((b.kybk*a.cenak)+(b.kybk*a.cenak*c.nds/100),0),
    perhnds=round((b.perh*c.nds/(100+c.nds)),0),
		perknds=round((b.perk*c.nds/(100+c.nds)),0),
    rastarifv=a.cenav,
		rastarifk=a.cenak
	FROM	
		(datatarifv as a join dataobekt as b on (a.datan=b.datan)) join
    obekt as c on(a.kodtv=c.kodtv) and(c.kodobk=b.kodobk) 
  WHERE b.datan=@data and c.kodtv<>3
  
	-- Обновляем все объекы ЖСК
    
    UPDATE dataobekt
	SET    
    symhnds=0, symknds=0, symhs = symh, symks = symkk,
    perhnds=0, perknds=0, rastarifv=a.cenav, rastarifk=a.cenak
	FROM	
		(datatarifv as a join dataobekt as b on (a.datan=b.datan)) join
    obekt as c on(a.kodtv=c.kodtv) and(c.kodobk=b.kodobk)
    WHERE b.datan=@data and c.kodtv=3
GO