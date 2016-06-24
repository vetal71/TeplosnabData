CREATE TABLE [dbo].[koteln] (
  [kodkot] [int] IDENTITY NOT FOR REPLICATION,
  [nazk] [varchar](30) NOT NULL,
  [ntop] [float] NULL,
  [nel] [float] NULL,
  [ps] [float] NULL,
  [mesto] [float] NULL,
  [master] [char](50) NULL,
  [kodpr] [int] NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [koteln UNIQUE _kotid_]
  ON [dbo].[koteln] ([kodkot])
  ON [PRIMARY]
GO