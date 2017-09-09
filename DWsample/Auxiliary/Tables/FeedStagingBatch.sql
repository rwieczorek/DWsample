CREATE TABLE [Auxiliary].[FeedStagingBatch] (
    [FeedStagingBatchKey]         INT            IDENTITY (1, 1) NOT NULL,
    [FeedKey]                     TINYINT        NOT NULL,
    [ExternalBatchID]             VARCHAR(MAX)   NULL,                 
	[ProcessedToStagingBegan]     SMALLDATETIME  NOT NULL,
    [ProcessedToStagingCompleted] SMALLDATETIME  NULL,
    --[FileName]                    NVARCHAR (300) NULL,
    --[SourcePath]                  NVARCHAR (500) NULL,
    --[PausedSince]                 SMALLDATETIME  NULL,
    --[DTVGUID]					  VARCHAR (33)   NULL,
    CONSTRAINT [PK_Auxiliary_FeedStagingBatch] PRIMARY KEY CLUSTERED ([FeedStagingBatchKey] ASC),
    CONSTRAINT [FK_Auxiliary_FeedStagingBatc_FeedKey] FOREIGN KEY ([FeedKey]) REFERENCES [Auxiliary].[Feed] ([FeedKey])
);
