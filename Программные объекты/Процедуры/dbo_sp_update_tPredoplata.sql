SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_update_tPredoplata]
AS
	DECLARE @p_t decimal(20,0), 
    		@p_v decimal(20,0), 
            @p_k decimal(20,0),
            @p_g decimal(20,0),
            @s_t decimal(20,0), 
    		@s_v decimal(20,0), 
            @s_k decimal(20,0),
            @s_g decimal(20,0)
	SELECT 
    	@p_t = fsum_t, @p_v = fsum_v, @p_k = fsum_k, @p_g = fsum_g,
        @s_t = sum_t, @s_v = sum_v, @s_k = sum_k, @s_g = sum_g
	FROM tPredoplata

    if (@s_t=0) set @s_t=1;
    if (@s_v=0) set @s_v=1;
    if (@s_k=0) set @s_k=1;
    if (@s_g=0) set @s_g=1;
    
	IF (ISNULL(@p_t,0)+ISNULL(@p_v,0)+ISNULL(@p_k,0)+ISNULL(@p_g,0)) != 0
		UPDATE tPredoplata
        SET psum_t = round(fsum_t/@s_t,2),
          	psum_v = round(fsum_v/@s_v,2),
          	psum_k = round(fsum_k/@s_k,2),
          	psum_g = round(fsum_g/@s_g,2)
GO