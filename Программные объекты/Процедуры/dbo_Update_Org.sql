SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[Update_Org]
@oper Integer,
@kodorg Integer,@nazv varchar(100), @adres varchar(100), @bank varchar(100), @rschet varchar(13),@unn varchar(10),
@tiporg integer, @datadog datetime, @ndog numeric(5,0), @tipbud integer, @kodbank integer 
AS
IF @oper = 1
BEGIN
	INSERT INTO org
                      ( nazv, adres, bank, rschet, unn, tiporg, datadog, ndog, tipbud, kodbank)
	VALUES     (@nazv, @adres, @bank, @rschet,@unn, @tiporg, @datadog, @ndog, @tipbud, @kodbank)
END
ELSE
BEGIN
	UPDATE org SET  nazv=@nazv, adres= @adres, bank=@bank,
	 rschet=@rschet, unn=@unn, tiporg=@tiporg, datadog=@datadog, ndog=@ndog, tipbud=@tipbud, kodbank=@kodbank
	WHERE kodorg=@kodorg
END
GO