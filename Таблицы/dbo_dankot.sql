CREATE TABLE [dbo].[dankot] (
  [kodkot] [int] NOT NULL,
  [ntop] [float] NULL,
  [nel] [float] NULL,
  [ps] [float] NULL,
  [dataiz] [datetime] NOT NULL CONSTRAINT [DF_dankot_dataiz] DEFAULT (getdate())
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[up_data_kot]
ON [dankot]
FOR INSERT, UPDATE
AS 
	INSERT INTO dankot
         (kodkot, ntop, nel, ps)
         SELECT 
            upd.kodkot,upd.ntop,upd.nel,upd.ps
         FROM inserted upd
GO