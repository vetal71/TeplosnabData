SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[sp_calc_obk]
	@data datetime
AS
	-- Обновляем все объекы, кроме ЖСК
	UPDATE dataobekt
	SET
    symt=round(b.gkt*a.cena,0),
		symv=round(b.gkv*a.cena,0),
    symtnds=round(b.gkt*a.cena*c.nds/100,0),
		symvnds=round(b.gkv*a.cena*c.nds/100,0),
    symk=round((b.gkt*a.cena)+(b.gkt*a.cena*c.nds/100),0),
		symgv=round((b.gkv*a.cena)+(b.gkv*a.cena*c.nds/100),0),
    pertnds=round((b.pert*c.nds/(100+c.nds)),0),
		pervnds=round((b.perv*c.nds/(100+c.nds)),0),
    rastarift=a.cena
	FROM
    datatarif as a inner join dataobekt as b on (a.datan=b.datan) join
    obekt as c on (a.kodtt=c.kodtt) and (c.kodobk=b.kodobk)
    WHERE (b.datan=@data and c.kodtt<>3) or (b.datan=@data and c.kodtt<>4)
	-- Обновляем ЖСК
	UPDATE dataobekt
		SET symt=round((((b.gkt*a.cena)/(c.spl+c.spll)*c.spl)+((b.gkt*a.cena)/(c.spl+c.spll)*c.spll/2)),0),
    		symv=round((((b.gkv*a.cena)/(c.prj+c.prjl)*c.prj)+((b.gkv*a.cena)/(c.prj+c.prjl)*c.prjl/2)),0),
    		lgkv=round(b.gkv/(c.prj+c.prjl)*c.prjl,2),
				lgkt=round(b.gkt/(c.spl+c.spll)*c.spll,2),
    		lsymt=round(b.gkt*a.cena/(c.spl+c.spll)*c.spll/2,0),
				lsymv=round(b.gkv*a.cena/(c.prj+c.prjl)*c.prjl/2,0),
    		symtnds=0,symvnds=0,
    		symk=round((((b.gkt*a.cena)/(c.spl+c.spll)*c.spl)+((b.gkt*a.cena)/(c.spl+c.spll)*c.spll/2)),0),
    		symgv=round((((b.gkv*a.cena)/(c.prj+c.prjl)*c.prj)+((b.gkv*a.cena)/(c.prj+c.prjl)*c.prjl/2)),0),
    		pertnds=0,pervnds=0,
    		rastarift=a.cena
		FROM 
			datatarif as a inner join dataobekt as b on (a.datan=b.datan) join
    	obekt as c on (a.kodtt=c.kodtt) and (c.kodobk=b.kodobk)
    	WHERE (b.datan=@data and c.kodtt=3) or (b.datan=@data and c.kodtt=4)


GO