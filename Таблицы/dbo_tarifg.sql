CREATE TABLE [dbo].[tarifg] (
  [kodtg] [int] IDENTITY NOT FOR REPLICATION,
  [nazt] [varchar](30) NOT NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [tarifg UNIQUE _kodtg_]
  ON [dbo].[tarifg] ([kodtg])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE TRIGGER [dbo].[ins_tarif_g] ON [tarifg]
FOR INSERT
AS
BEGIN
	INSERT INTO datatarifg (kodtg)
	SELECT ins.kodtg
	FROM inserted ins
END
GO