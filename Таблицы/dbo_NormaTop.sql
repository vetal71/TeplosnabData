CREATE TABLE [dbo].[NormaTop] (
  [id_norma] [int] IDENTITY,
  [kodkot] [int] NOT NULL,
  [kodtop] [int] NOT NULL,
  [norma] [decimal](18, 4) NULL,
  CONSTRAINT [PK_NormaTop] PRIMARY KEY CLUSTERED ([id_norma])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[up_norma]
ON [NormaTop]
FOR INSERT, UPDATE 
AS 
	INSERT INTO dannorma
         (id_norma, norma, kodkot, kodtop)
         SELECT 
            upd.id_norma,upd.norma,upd.kodkot,upd.kodtop
         FROM inserted upd

GO