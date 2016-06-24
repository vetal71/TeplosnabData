CREATE TABLE [dbo].[tarift] (
  [kodtt] [int] IDENTITY NOT FOR REPLICATION,
  [nazt] [varchar](30) NOT NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tarift UNIQUE _kodtt_]
  ON [dbo].[tarift] ([kodtt])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[ins_tarif_t]
ON [tarift]
FOR INSERT
AS 
BEGIN
	INSERT INTO datatarif (kodtt)
	SELECT ins.kodtt
	FROM inserted ins
END
GO