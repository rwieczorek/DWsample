CREATE TABLE [Auxiliary].[LoadLog] (
    [LoadLogKey]   INT             IDENTITY (1, 1) NOT NULL,
    [LoadKey]      INT             NOT NULL,
    [StepKey]      TINYINT         NOT NULL,
    [Container]    NVARCHAR (300)  NOT NULL,
    [Trace]        NVARCHAR (1000) NULL,
    [Detail]       NVARCHAR (1000) NULL,
    [RowsAffected] BIGINT          NULL,
    [StartedAt]    DATETIME2 (7)   NOT NULL,
    [CompletedAt]  DATETIME2 (7)   NULL,
    CONSTRAINT [PK_Auxiliary_LoadLog] PRIMARY KEY CLUSTERED ([LoadLogKey] ASC) ON [Secondary],
    CONSTRAINT [FK_Auxiliary_LoadLog_LoadKey] FOREIGN KEY ([LoadKey]) REFERENCES [Auxiliary].[Load] ([LoadKey]),
    CONSTRAINT [FK_Auxiliary_LoadLog_StepKey] FOREIGN KEY ([StepKey]) REFERENCES [Auxiliary].[Step] ([StepKey])
);

GO

CREATE NONCLUSTERED INDEX IX_Auxiliary_LoadLog_LoadKey_StepKey_Container_Include
ON Auxiliary.LoadLog (LoadKey, StepKey, Container)
INCLUDE (StartedAt, Trace, CompletedAt, RowsAffected, Detail)
ON [SecondaryIndex];
GO

CREATE NONCLUSTERED INDEX IX_Auxiliary_LoadLog_StartedAt_Include_All
ON Auxiliary.LoadLog (StartedAt DESC)
INCLUDE ([LoadKey], [StepKey], [Container], [Trace], [Detail], [RowsAffected], [CompletedAt])
ON [SecondaryIndex];
GO
