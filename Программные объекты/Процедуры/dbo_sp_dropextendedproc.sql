SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
create procedure [dbo].[sp_dropextendedproc] 
@functname nvarchar(517) -- name of function 
as 
-- If we're in a transaction, disallow the dropping of the 
-- extended stored procedure. 
set implicit_transactions off 
if @@trancount > 0 
begin 
raiserror(15002,-1,-1,'sys.sp_dropextendedproc') 
return (1) 
end 

-- Drop the extended procedure mapping. 
dbcc dropextendedproc( @functname ) 
return (0) -- sp_dropextendedproc
GO