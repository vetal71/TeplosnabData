SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_predoplata]
	@kod int, @data datetime
AS
	IF EXISTS (SELECT name
			FROM sysobjects
			WHERE name = N'tPredoplata'
			AND type = 'U')
		DROP TABLE tPredoplata
	CREATE TABLE tPredoplata
		(kodorg int, 
		 sum_t decimal(20,0), sum_v decimal(20,0), sum_k decimal(20,0), sum_g decimal(20,0),
		 fsum_t decimal(20,0), fsum_v decimal(20,0), fsum_k decimal(20,0), fsum_g decimal(20,0),
		 psum_t decimal(6,2), psum_v decimal(6,2), psum_k decimal(6,2), psum_g decimal(6,2))
	-- Выбираем данные по начислениям
	INSERT INTO tPredoplata (kodorg, sum_t, sum_v, sum_k, sum_g)
		SELECT kodorg, isnull(symtv+symgvs,0), isnull(sumvv,0), isnull(sumkk,0), isnull(sumgg,0)
		FROM dataorg
		WHERE datan = @data and kodorg = @kod
GO