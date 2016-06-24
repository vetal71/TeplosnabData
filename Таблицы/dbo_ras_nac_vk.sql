CREATE TABLE [dbo].[ras_nac_vk] (
  [nazv] [char](50) NULL,
  [tarifv] [decimal](15, 2) NULL,
  [kod_tarif] [int] NULL,
  [kybv] [decimal](15, 2) NULL,
  [sum_nacv] [decimal](20) NULL,
  [per_kv] [decimal](15, 2) NULL,
  [sum_perv] [decimal](20) NULL,
  [tarifk] [decimal](15, 2) NULL,
  [kybk] [decimal](15, 2) NULL,
  [sum_nack] [decimal](20) NULL,
  [per_kk] [decimal](15, 2) NULL,
  [sum_perk] [decimal](20) NULL
)
ON [PRIMARY]
GO