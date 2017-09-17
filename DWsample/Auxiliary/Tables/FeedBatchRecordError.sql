CREATE TABLE [Auxiliary].[FeedBatchRecordError] (
    [FeedBatchRecordErrorKey] BIGINT          IDENTITY (1, 1) NOT NULL,
    [FeedBatchKey]            INT             NOT NULL,
    [RecordNumber]           INT             NOT NULL,
    [StepKey]                TINYINT         NOT NULL,
    [LoggedAt]               DATETIME2 (7)   DEFAULT (sysdatetime()) NOT NULL,
    [Container]              NVARCHAR (300)  NOT NULL,
    [Trace]                  NVARCHAR (1000) NULL,
    [Message]                NVARCHAR (4000) NULL,
    [Detail]                 NVARCHAR (1000) NULL,
	Record					 NVARCHAR (MAX)	 NULL,
    CONSTRAINT [PK_Auxiliary_FeedBatchRecordError] PRIMARY KEY CLUSTERED ([FeedBatchRecordErrorKey] ASC) ON [Secondary],
    CONSTRAINT [FK_Auxiliary_FeedBatchRecordError_FeedFileKey] FOREIGN KEY ([FeedBatchKey]) REFERENCES [Auxiliary].[FeedBatch] ([FeedBatchKey]),
    CONSTRAINT [FK_Auxiliary_FeedBatchRecordError_StepKey] FOREIGN KEY ([StepKey]) REFERENCES [Auxiliary].[Step] ([StepKey])
);
