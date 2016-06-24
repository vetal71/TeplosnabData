CREATE TABLE [dbo].[pribor] (
  [kod] [int] IDENTITY NOT FOR REPLICATION,
  [nazp] [varchar](50) NOT NULL,
  [kodorg] [int] NOT NULL,
  [kodkot] [int] NOT NULL,
  [tep] [smallint] NOT NULL,
  [tgv] [smallint] NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE INDEX [kod]
  ON [dbo].[pribor] ([kod])
  ON [PRIMARY]
GO