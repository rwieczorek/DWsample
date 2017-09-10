CREATE TABLE [Auxiliary].[FeedBatchError] (
    [FeedBatchErrorKey] INT             IDENTITY (1, 1) NOT NULL,
    [FeedBatchKey]      INT             NOT NULL,
    [StepKey]          TINYINT         NOT NULL,
    [LoggedAt]         DATETIME2 (7)   DEFAULT (sysdatetime()) NOT NULL,
    [Container]        NVARCHAR (300)  NOT NULL,
    [Trace]            NVARCHAR (1000) NULL,
    [Message]          NVARCHAR (4000) NULL,
    [Detail]           NVARCHAR (1000) NULL,
    CONSTRAINT [PK_Auxiliary_FeedBatchError] PRIMARY KEY CLUSTERED ([FeedBatchErrorKey] ASC) ,
    CONSTRAINT [FK_Auxiliary_FeedBatchError_FeedBatchKey] FOREIGN KEY ([FeedBatchKey]) REFERENCES [Auxiliary].[FeedBatch] ([FeedBatchKey]),
    CONSTRAINT [FK_Auxiliary_FeedBatchError_StepKey] FOREIGN KEY ([StepKey]) REFERENCES [Auxiliary].[Step] ([StepKey])
);
GO

CREATE NONCLUSTERED INDEX IX_Auxiliary_FeedBatchError_LoggedAt_Include_All
ON Auxiliary.FeedBatchError (LoggedAt DESC)
INCLUDE([FeedBatchKey], [StepKey], [Container], [Trace], [Message], [Detail]);
GO