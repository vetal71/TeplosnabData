CREATE TABLE [dbo].[ulica] (
  [kodul] [int] IDENTITY NOT FOR REPLICATION,
  [nazvul] [varchar](18) NOT NULL,
  [kodkot] [int] NOT NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ulica UNIQUE _kodul_]
  ON [dbo].[ulica] ([kodul])
  ON [PRIMARY]
GO