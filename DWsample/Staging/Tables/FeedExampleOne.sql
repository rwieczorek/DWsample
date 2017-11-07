CREATE TABLE [Staging].[FeedExampleOne] (
    [FeedBatchKey] INT            NOT NULL,
    [RowNumber]    INT            NOT NULL,
    [BusinessID]   NVARCHAR (MAX) NULL,
    [Date]         NVARCHAR (MAX) NULL,
    [Value]        NVARCHAR (MAX) NULL,
	DateKey        INT            NULL,
	TimeKey        SMALLINT       NULL,
    SourceKey	   TINYINT        NULL,
	AuditKey	   INT            NULL,
	RecordRejected	BIT	DEFAULT(0)	NOT NULL
	CONSTRAINT [PK_FeedExampleOne] PRIMARY KEY CLUSTERED ([FeedBatchKey] ASC, [RowNumber] ASC) ON [FeedExampleOnePS] ([FeedBatchKey])
	--cannot cluster on FeedBatchKey/RowNumber if there will be parallel inserts to the same staging table!
);

GO
--ALTER TABLE [Staging].[Customer] SET (LOCK_ESCALATION = AUTO);