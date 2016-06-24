CREATE TABLE [dbo].[dantop] (
  [kodtop] [int] NOT NULL,
  [k_per] [decimal](18, 4) NULL,
  [data_iz] [datetime] NULL CONSTRAINT [DF_dantop_data_iz] DEFAULT (getdate())
)
ON [PRIMARY]
GO