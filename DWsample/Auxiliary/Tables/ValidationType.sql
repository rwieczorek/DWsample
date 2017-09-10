CREATE TABLE [Auxiliary].[ValidationType] (
    [ValidationTypeKey] TINYINT       IDENTITY (1, 1) NOT NULL,
    [Name]              NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Auxiliary_ValidationType] PRIMARY KEY CLUSTERED ([ValidationTypeKey] ASC)
);
