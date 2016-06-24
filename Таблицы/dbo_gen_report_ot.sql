CREATE TABLE [dbo].[gen_report_ot] (
  [kod] [int] NULL,
  [nazv] [varchar](100) NULL,
  [gk] [decimal](15, 2) NULL,
  [tarif] [decimal](15, 2) NULL,
  [kod_tarif] [int] NULL,
  [sum_nac] [decimal](20) NULL,
  [sum_nds] [decimal](20) NULL,
  [per_gk] [decimal](15, 2) NULL,
  [sum_per] [decimal](20) NULL,
  [razn] [decimal](20) NULL,
  [tip] [int] NULL
)
ON [PRIMARY]
GO