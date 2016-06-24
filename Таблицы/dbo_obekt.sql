CREATE TABLE [dbo].[obekt] (
  [kodorg] [int] NOT NULL,
  [kodobk] [int] IDENTITY NOT FOR REPLICATION,
  [nazv] [varchar](100) NOT NULL,
  [ngvs] [float] NULL,
  [kodkot] [int] NULL,
  [kodtt] [int] NULL,
  [nds] [int] NULL,
  [ecnal] [int] NULL,
  [nalprib] [int] NULL,
  [nalpribgv] [int] NULL,
  [kodpr] [int] NULL,
  [prin] [int] NULL,
  [q] [float] NULL,
  [t] [float] NULL,
  [prj] [float] NULL,
  [prjl] [float] NULL,
  [spl] [float] NULL,
  [spll] [float] NULL,
  [podkl] [int] NULL,
  [v] [float] NULL,
  [rasch] [int] NULL,
  [kodtv] [int] NULL,
  [podklv] [int] NULL,
  [qv] [float] NULL,
  [qk] [float] NULL,
  [podklgv] [int] NULL,
  [data_per] [datetime] NULL,
  [kodtg] [int] NULL,
  [podklg] [int] NULL,
  [qg] [float] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [obekt UNIQUE _kodobk_]
  ON [dbo].[obekt] ([kodobk])
  ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   TRIGGER [dbo].[up_data_obekt]
ON [obekt]
FOR INSERT, UPDATE 
AS
--eg. check if all of column 2, 3, 4 are updated
-- Audit NEW record.
      INSERT INTO danobk
         (kodobk, v, q, prj, prjl, spl, spll)
         SELECT 
            upd.kodobk,upd.v,upd.q,upd.prj,upd.prjl,
						upd.spl,upd.spll
         FROM inserted upd

GO

ALTER TABLE [dbo].[obekt] WITH NOCHECK
  ADD CONSTRAINT [FK_obekt_org] FOREIGN KEY ([kodorg]) REFERENCES [dbo].[org] ([kodorg]) ON DELETE CASCADE ON UPDATE CASCADE
GO