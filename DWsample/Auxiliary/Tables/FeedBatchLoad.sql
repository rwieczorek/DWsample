CREATE TABLE [Auxiliary].[FeedBatchLoad] (
    [FeedBatchLoadKey] INT      IDENTITY (1, 1) NOT NULL,
    [FeedBatchKey]     INT      NOT NULL,
    [LoadKey]          INT NOT NULL,
    CONSTRAINT [PK_Auxiliary_FeedBatchLoad] PRIMARY KEY CLUSTERED ([FeedBatchLoadKey] ASC),
    CONSTRAINT [FK_Auxiliary_FeedBatchLoad_FeedBatchKey] FOREIGN KEY ([FeedBatchKey]) REFERENCES [Auxiliary].[FeedBatch] ([FeedBatchKey]),
    CONSTRAINT [FK_Auxiliary_FeedBatchLoad_LoadKey] FOREIGN KEY ([LoadKey]) REFERENCES [Auxiliary].[Load] ([LoadKey])
);