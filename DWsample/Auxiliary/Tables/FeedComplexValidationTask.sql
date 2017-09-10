CREATE TABLE [Auxiliary].[FeedComplexValidationTask] (
    [FeedComplexValidationTaskKey] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [FeedKey]                      TINYINT        NOT NULL,
    [Statement]                    NVARCHAR (100) NULL,
    [ApplyAtStepKey]               TINYINT        NOT NULL,
    CONSTRAINT [PK_Auxiliary_FeedComplexValidationTask] PRIMARY KEY CLUSTERED ([FeedComplexValidationTaskKey] ASC),
    CONSTRAINT [FK_Auxiliary_FeedComplexValidationTask_ApplyAtStepKey] FOREIGN KEY ([ApplyAtStepKey]) REFERENCES [Auxiliary].[Step] ([StepKey]),
    CONSTRAINT [FK_Auxiliary_FeedComplexValidationTask_FeedKey] FOREIGN KEY ([FeedKey]) REFERENCES [Auxiliary].[Feed] ([FeedKey])
);