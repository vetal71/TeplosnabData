CREATE TABLE [dbo].[arh_datadoma] (
  [koddom] [int] NOT NULL,
  [gkt] [float] NULL CONSTRAINT [DF_arhdatadoma_gkt] DEFAULT (0),
  [gkv] [float] NULL CONSTRAINT [DF_arhdatadoma_gkv] DEFAULT (0),
  [st] [int] NULL,
  [sv] [int] NULL,
  [datan] [datetime] NULL,
  [datak] [datetime] NULL,
  [pt] [int] NULL,
  [pv] [int] NULL,
  [normativ] [decimal](18, 5) NULL,
  [normativgv] [decimal](18, 5) NULL
)
ON [PRIMARY]
GO