CREATE TABLE [dbo].[dannorma] (
  [id_norma] [int] NOT NULL,
  [norma] [decimal](18, 4) NULL,
  [data_iz] [datetime] NULL CONSTRAINT [DF_dannorma_data_iz] DEFAULT (getdate()),
  [kodkot] [int] NOT NULL,
  [kodtop] [int] NOT NULL
)
ON [PRIMARY]
GO