CREATE TABLE [dbo].[ngvs] (
  [nazn] [varchar](50) NOT NULL,
  [norma] [float] NOT NULL,
  [kod] [int] NOT NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [ngvs UNIQUE _kod_]
  ON [dbo].[ngvs] ([kod])
  ON [PRIMARY]
GO