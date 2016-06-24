CREATE TABLE [dbo].[org] (
  [kodorg] [int] IDENTITY NOT FOR REPLICATION,
  [nazv] [varchar](100) NOT NULL,
  [adres] [varchar](100) NOT NULL,
  [bank] [varchar](100) NOT NULL,
  [rschet] [varchar](13) NOT NULL,
  [unn] [varchar](10) NOT NULL,
  [tiporg] [float] NOT NULL,
  [datadog] [datetime] NULL,
  [ndog] [float] NULL,
  [_min] [varchar](40) NULL,
  [tipbud] [int] NULL,
  [kodbank] [int] NULL,
  [data_per] [datetime] NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [org UNIQUE _kodorg_]
  ON [dbo].[org] ([kodorg])
  ON [PRIMARY]
GO