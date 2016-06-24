CREATE TABLE [dbo].[schet] (
  [usluga] [varchar](100) NOT NULL,
  [ed_izm] [varchar](6) NOT NULL,
  [kol] [float] NULL,
  [tarif] [float] NULL,
  [sum_b_nds] [float] NULL,
  [stavka_nds] [float] NULL,
  [nds] [float] NULL,
  [sum_s_nds] [float] NULL,
  [kodorg] [int] NULL,
  [data_sf] [datetime] NULL,
  [kodusl] [int] NULL,
  [period] [varchar](30) NULL,
  [nazv_org] [varchar](100) NULL,
  [adres_org] [varchar](100) NULL,
  [unn_org] [varchar](10) NULL,
  [rs_org] [varchar](13) NULL,
  [bank_org] [varchar](255) NULL
)
ON [PRIMARY]
GO