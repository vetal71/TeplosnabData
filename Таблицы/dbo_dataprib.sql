CREATE TABLE [dbo].[dataprib] (
  [KODPR] [int] NULL,
  [KDR] [float] NULL CONSTRAINT [DF_dataprib_KDR] DEFAULT (0),
  [STR] [float] NULL CONSTRAINT [DF_dataprib_STR] DEFAULT (0),
  [GKR] [float] NULL CONSTRAINT [DF_dataprib_GKR] DEFAULT (0),
  [GKT] [float] NULL CONSTRAINT [DF_dataprib_GKT] DEFAULT (0),
  [GKV] [float] NULL CONSTRAINT [DF_dataprib_GKV] DEFAULT (0),
  [DATAN] [datetime] NULL,
  [DATAK] [datetime] NULL,
  [KCR] [int] NULL CONSTRAINT [DF_dataprib_KCR] DEFAULT (0),
  [n_gv] [float] NULL CONSTRAINT [DF_dataprib_n_gv] DEFAULT (0),
  [normativ] [float] NULL CONSTRAINT [DF_dataprib_normativ] DEFAULT (0),
  [pok_kub] [float] NULL CONSTRAINT [DF_dataprib_pok_kub] DEFAULT (0),
  [k_prj] [int] NULL CONSTRAINT [DF_dataprib_k_prj] DEFAULT (0),
  [gkrv] [float] NULL CONSTRAINT [DF_dataprib_gkrv] DEFAULT (0)
)
ON [PRIMARY]
GO