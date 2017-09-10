CREATE TABLE [Auxiliary].[ValidationFailureAction] (
    [ValidationFailureActionKey] TINYINT       IDENTITY (1, 1) NOT NULL,
    [ActionName]                 NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Auxiliary_ValidationFailureAction] PRIMARY KEY CLUSTERED ([ValidationFailureActionKey] ASC)
);
