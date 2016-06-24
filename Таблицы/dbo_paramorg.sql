CREATE TABLE [dbo].[paramorg] (
  [nazvorg] [char](50) NULL,
  [kodbank] [int] NULL CONSTRAINT [DF_paramorg_kodbank] DEFAULT (541),
  [adresorg] [char](50) NULL,
  [rshetorg] [char](13) NULL,
  [unnorg] [char](9) NULL,
  [dolgn_chif] [char](20) NULL,
  [fio_chif] [char](20) NULL,
  [tel_org] [char](10) NULL,
  [dolgn_bux] [char](20) NULL,
  [fio_bux] [char](20) NULL,
  [dolgn_isp1] [char](20) NULL,
  [dolgnisp2] [char](20) NULL,
  [fio_isp1] [char](20) NULL,
  [fio_isp2] [char](20) NULL,
  [tel_isp] [char](10) NULL,
  [id_par] [int] IDENTITY NOT FOR REPLICATION,
  [rasch_period] [int] NULL,
  [zak_mes] [int] NULL,
  [new_mes] [int] NULL,
  [period_name] [char](15) NULL,
  [arh_data] [datetime] NULL,
  CONSTRAINT [PK_paramorg] PRIMARY KEY CLUSTERED ([id_par])
)
ON [PRIMARY]
GO