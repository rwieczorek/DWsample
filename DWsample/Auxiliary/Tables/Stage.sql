CREATE TABLE [Auxiliary].[Stage] (
    [StageKey] TINYINT       IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (50) NOT NULL,
    [Order]    TINYINT       NOT NULL,
    CONSTRAINT [PK_Auxiliary_Stage] PRIMARY KEY CLUSTERED ([StageKey] ASC)
);