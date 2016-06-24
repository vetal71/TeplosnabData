CREATE TABLE [dbo].[doma] (
  [koddom] [int] IDENTITY NOT FOR REPLICATION,
  [kodkot] [int] NOT NULL,
  [kodul] [int] NOT NULL,
  [ndom] [varchar](4) NOT NULL,
  [so] [float] NOT NULL CONSTRAINT [DF_doma_so] DEFAULT (0),
  [prj] [float] NOT NULL CONSTRAINT [DF_doma_prj] DEFAULT (0),
  [qot] [float] NOT NULL CONSTRAINT [DF_doma_qot] DEFAULT (0),
  [qgv] [float] NOT NULL CONSTRAINT [DF_doma_qgv] DEFAULT (0),
  [lot] [int] NOT NULL,
  [lgv] [int] NOT NULL,
  [kodpr] [int] NOT NULL,
  [ngv] [float] NULL,
  [vd] [float] NULL,
  [podkl] [int] NULL,
  [podklgv] [int] NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [doma UNIQUE _n_domid_]
  ON [dbo].[doma] ([koddom])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[up_data_doma]
ON [doma]
FOR INSERT, UPDATE 
AS 
	INSERT INTO dandoma
         (koddom, vd, qot, prj, so)
         SELECT 
            upd.koddom,upd.vd,upd.qot,upd.prj,
						upd.so
         FROM inserted upd
GO