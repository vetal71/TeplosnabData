CREATE TABLE [dbo].[tarifv] (
  [kodtv] [int] IDENTITY NOT FOR REPLICATION,
  [nazt] [varchar](30) NOT NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tarifv UNIQUE _kodtt_]
  ON [dbo].[tarifv] ([kodtv])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [ins_tarif_v]
ON [dbo].[tarifv]
FOR INSERT
AS 
BEGIN
	INSERT INTO datatarifv (kodtv)
	SELECT ins.kodtv
	FROM inserted ins
END
GO