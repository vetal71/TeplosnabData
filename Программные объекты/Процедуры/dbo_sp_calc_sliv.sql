SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_calc_sliv]
	@kod int, @data datetime
AS
	SET NOCOUNT ON
	INSERT INTO dataobekt (kodobk, kybk, kybv, datan, datak)
			SELECT kodobk, qk, qv, @data, teplosnab.dbo.end_of_month(@data) 
			FROM obekt 
			WHERE kodobk NOT IN (SELECT kodobk FROM dataobekt WHERE
			datan = @data) and kodkot = @kod
GO