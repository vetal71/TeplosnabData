CREATE TABLE [dbo].[danobk] (
  [kodobk] [int] NOT NULL,
  [v] [float] NULL,
  [q] [float] NULL,
  [prj] [float] NULL,
  [prjl] [float] NULL,
  [spl] [float] NULL,
  [spll] [float] NULL,
  [dataiz] [datetime] NULL CONSTRAINT [DF_danobk_dataiz] DEFAULT (getdate()),
  CONSTRAINT [FK_danobk_obekt] FOREIGN KEY ([kodobk]) REFERENCES [dbo].[obekt] ([kodobk]) ON DELETE CASCADE ON UPDATE CASCADE
)
ON [PRIMARY]
GO