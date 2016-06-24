CREATE TABLE [dbo].[gen_report_g] (
  [kod] [int] NULL,
  [nazv] [char](100) NULL,
  [kg] [decimal](15, 2) NULL,
  [tarifg] [decimal](15, 2) NULL,
  [kod_tarifg] [int] NULL,
  [sum_nacg] [decimal](20) NULL,
  [sum_ndsg] [decimal](20) NULL,
  [per_kg] [decimal](15, 2) NULL,
  [sum_perg] [decimal](20) NULL,
  [razng] [decimal](20) NULL,
  [tip] [int] NULL
)
ON [PRIMARY]
GO