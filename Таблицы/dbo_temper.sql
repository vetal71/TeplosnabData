CREATE TABLE [dbo].[temper] (
  [data] [datetime] NOT NULL,
  [srt] [float] NULL,
  [kod_rec] [int] IDENTITY NOT FOR REPLICATION
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [temper UNIQUE _d_dat_]
  ON [dbo].[temper] ([data])
  ON [PRIMARY]
GO