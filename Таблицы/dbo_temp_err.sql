CREATE TABLE [dbo].[temp_err] (
  [id_err] [int] IDENTITY NOT FOR REPLICATION,
  [nazv_err] [varchar](250) NOT NULL,
  [tablename_err] [varchar](20) NOT NULL,
  [tip_err] [char](20) NOT NULL,
  [kod_obj] [int] NULL,
  [filter_sql] [char](30) NULL,
  [recomendation] [char](250) NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [temp_err UNIQUE _id_err_]
  ON [dbo].[temp_err] ([id_err])
  ON [PRIMARY]
GO