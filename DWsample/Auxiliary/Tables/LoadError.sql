CREATE TABLE [Auxiliary].[LoadError] (
    [LoadErrorKey] INT             IDENTITY (1, 1) NOT NULL,
    [LoadKey]      INT        NOT NULL,
    [StepKey]      TINYINT         NOT NULL,
    [LoggedAt]     DATETIME2 (7)   NOT NULL,
    [Container]    NVARCHAR (300)  NOT NULL,
    [Trace]        NVARCHAR (1000) NULL,
    [Message]      NVARCHAR (1000) NULL,
    [Detail]       NVARCHAR (1000) NULL,
    CONSTRAINT [PK_Auxiliary_LoadError] PRIMARY KEY CLUSTERED ([LoadErrorKey] ASC) ,
    CONSTRAINT [FK_Auxiliary_LoadError_LoadKey] FOREIGN KEY ([LoadKey]) REFERENCES [Auxiliary].[Load] ([LoadKey]),
    CONSTRAINT [FK_Auxiliary_LoadError_StepKey] FOREIGN KEY ([StepKey]) REFERENCES [Auxiliary].[Step] ([StepKey])
);

GO
CREATE NONCLUSTERED INDEX IX_Auxiliary_LoadError_LoggeedAt_Include_All
ON Auxiliary.LoadError (LoggedAt DESC)
INCLUDE([LoadKey], [StepKey], [Container], [Trace], [Message], [Detail]);
GO
