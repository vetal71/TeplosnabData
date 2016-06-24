CREATE TABLE [dbo].[gen_report_vk] (
  [kod] [int] NULL,
  [nazv] [char](100) NULL,
  [kv] [decimal](15, 2) NULL,
  [tarifv] [decimal](15, 2) NULL,
  [kod_tarifv] [int] NULL,
  [sum_nacv] [decimal](20) NULL,
  [sum_ndsv] [decimal](20) NULL,
  [per_kv] [decimal](15, 2) NULL,
  [sum_perv] [decimal](20) NULL,
  [raznv] [decimal](20) NULL,
  [kk] [decimal](15, 2) NULL,
  [tarifk] [decimal](15, 2) NULL,
  [kod_tarifk] [int] NULL,
  [sum_nack] [decimal](20) NULL,
  [sum_ndsk] [decimal](20) NULL,
  [per_kk] [decimal](15, 2) NULL,
  [sum_perk] [decimal](20) NULL,
  [raznk] [decimal](20) NULL,
  [tip] [int] NULL
)
ON [PRIMARY]
GO