CREATE TABLE [Auxiliary].[FeedBatchLog] (
    [FeedBatchLogKey] INT             IDENTITY (1, 1) NOT NULL,
    [FeedBatchKey]    INT             NOT NULL,
    [StepKey]        TINYINT         NOT NULL,
    [Container]      NVARCHAR (300)  NOT NULL,
    [Trace]          NVARCHAR (1000) NULL,
    [Detail]         NVARCHAR (1000) NULL,
    [RowsAffected]   BIGINT          NULL,
    [StartedAt]      DATETIME2 (7)   NOT NULL,
    [CompletedAt]    DATETIME2 (7)   NULL,
    CONSTRAINT [PK_Auxiliary_FeedFileLog] PRIMARY KEY CLUSTERED ([FeedBatchLogKey] ASC) ,
    CONSTRAINT [FK_Auxiliary_FeedFileLog_FeedFileKey] FOREIGN KEY ([FeedBatchKey]) REFERENCES [Auxiliary].[FeedBatch] ([FeedBatchKey]),
    CONSTRAINT [FK_Auxiliary_FeedFileLog_StepKey] FOREIGN KEY ([StepKey]) REFERENCES [Auxiliary].[Step] ([StepKey])
);

GO

CREATE NONCLUSTERED INDEX IX_Auxiliary_FeedBatchLog_FeedBatchKey_StepKey_Container_Include
ON Auxiliary.FeedBatchLog (FeedBatchKey, StepKey, Container)
INCLUDE(Trace, Detail, RowsAffected, StartedAt, CompletedAt);

GO

CREATE NONCLUSTERED INDEX IX_Auxiliary_FeedBatchLog_StartedAt_Include_All
ON Auxiliary.FeedBatchLog (StartedAt DESC)
INCLUDE(FeedBatchKey, StepKey, Container, Trace, Detail, RowsAffected, CompletedAt);

GO