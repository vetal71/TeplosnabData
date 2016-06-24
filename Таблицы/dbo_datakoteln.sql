CREATE TABLE [dbo].[datakoteln] (
  [KODKOT] [int] NOT NULL,
  [KDO] [float] NULL CONSTRAINT [DF_datakoteln_KDO] DEFAULT (0),
  [KCO] [float] NULL CONSTRAINT [DF_datakoteln_KCO] DEFAULT (0),
  [SRT] [float] NULL CONSTRAINT [DF_datakoteln_SRT] DEFAULT (0),
  [KDG] [float] NULL CONSTRAINT [DF_datakoteln_KDG] DEFAULT (0),
  [KCG] [float] NULL CONSTRAINT [DF_datakoteln_KCG] DEFAULT (0),
  [DATAN] [datetime] NULL,
  [DATAK] [datetime] NULL,
  [NORMATIV_OT] [decimal](15, 5) NULL CONSTRAINT [DF_datakoteln_NORMATIV_OT] DEFAULT (0),
  [NORMATIV_GV] [decimal](15, 5) NULL CONSTRAINT [DF_datakoteln_NORMATIV_GV] DEFAULT (0),
  [N_GV] [int] NULL CONSTRAINT [DF_datakoteln_N_GV] DEFAULT (0),
  [datas] [datetime] NULL,
  [datapo] [datetime] NULL,
  [ps] [decimal](15, 2) NULL,
  [kodtop] [int] NULL,
  [koltop] [decimal](18, 1) NULL,
  [tut] [decimal](18, 1) NULL,
  [r_ot] [decimal](18, 2) NULL,
  [r_gv] [decimal](18, 2) NULL,
  [vyr] [decimal](18, 2) NULL,
  [kper] [decimal](18, 4) NULL,
  [ntop] [decimal](18, 4) NULL,
  CONSTRAINT [IX_datakoteln] UNIQUE ([KODKOT], [DATAN])
)
ON [PRIMARY]
GO