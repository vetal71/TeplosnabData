CREATE TABLE [dbo].[dankvart] (
  [kodkv] [int] NOT NULL,
  [qot] [float] NOT NULL,
  [so] [float] NOT NULL,
  [prj] [float] NOT NULL,
  [dataiz] [datetime] NOT NULL CONSTRAINT [DF_dankvart_dataiz] DEFAULT (getdate())
)
ON [PRIMARY]
GO