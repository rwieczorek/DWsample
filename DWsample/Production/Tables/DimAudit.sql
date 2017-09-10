CREATE TABLE [Production].[DimAudit] (
    [AuditKey]         INT            IDENTITY (1, 1) NOT NULL,
    [FeedBatchLoadKey] INT            NOT NULL,
    [FeedName]         NVARCHAR (50)  NOT NULL,
    [LoadDateKey]      INT            NOT NULL,
    CONSTRAINT [PK_Production_DimAudit] PRIMARY KEY CLUSTERED ([AuditKey] ASC) ON [PRIMARY],
    CONSTRAINT [FK_Production_DimAudit_FeedBatchLoadKey] FOREIGN KEY ([FeedBatchLoadKey]) REFERENCES [Auxiliary].[FeedBatchLoad] ([FeedBatchLoadKey]),
    CONSTRAINT [FK_Production_DimAudit_LoadDateKey] FOREIGN KEY ([LoadDateKey]) REFERENCES [Production].[DimDate] ([DateKey])
);
