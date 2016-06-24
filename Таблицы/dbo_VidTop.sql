CREATE TABLE [dbo].[VidTop] (
  [kodtop] [int] IDENTITY,
  [naztop] [char](30) NULL,
  [k_per] [decimal](18, 4) NULL,
  CONSTRAINT [PK_VidTop] PRIMARY KEY CLUSTERED ([kodtop])
)
ON [PRIMARY]
GO