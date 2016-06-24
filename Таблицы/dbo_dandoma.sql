CREATE TABLE [dbo].[dandoma] (
  [koddom] [int] NOT NULL,
  [vd] [float] NOT NULL,
  [qot] [float] NOT NULL,
  [so] [float] NOT NULL,
  [prj] [float] NOT NULL,
  [dataiz] [datetime] NOT NULL CONSTRAINT [DF_dandoma_dataiz] DEFAULT (getdate())
)
ON [PRIMARY]
GO