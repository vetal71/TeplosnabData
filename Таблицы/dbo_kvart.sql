CREATE TABLE [dbo].[kvart] (
  [schet] [float] NULL,
  [kodkv] [int] IDENTITY NOT FOR REPLICATION,
  [koddom] [int] NOT NULL,
  [kv] [varchar](4) NOT NULL,
  [so] [float] NOT NULL,
  [prj] [float] NOT NULL,
  [qot] [float] NOT NULL,
  [qgv] [float] NULL,
  [prin] [int] NOT NULL,
  [ngv] [float] NULL,
  [priv] [int] NULL,
  [kodobk] [int] NULL,
  [podkl] [int] NULL,
  [podklgv] [int] NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [kvart UNIQUE _kvid_]
  ON [dbo].[kvart] ([kodkv])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [up_data_kvart]
ON [dbo].[kvart]
FOR INSERT, UPDATE 
AS 
	INSERT INTO dankvart
         (kodkv, qot, prj, so)
         SELECT 
            upd.kodkv,upd.qot,upd.prj,
						upd.so
         FROM inserted upd
GO