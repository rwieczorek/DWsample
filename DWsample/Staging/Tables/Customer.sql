CREATE TABLE [Staging].[Customer] (
    [FeedBatchKey] INT            NOT NULL,
    [RowNumber]    INT            NOT NULL,
    [Title]        NVARCHAR (MAX) NULL,
    [Forename]     NVARCHAR (MAX) NULL,
    [Initials]     NVARCHAR (MAX) NULL,
    [Surname]      NVARCHAR (MAX) NULL,
    [Gender]       NVARCHAR (MAX) NULL,
    [CompanyName]  NVARCHAR (MAX) NULL,
    [Address1]     NVARCHAR (MAX) NULL,
    [Address2]     NVARCHAR (MAX) NULL,
    [Address3]     NVARCHAR (MAX) NULL,
    [Address4]     NVARCHAR (MAX) NULL,
    [Address5]     NVARCHAR (MAX) NULL,
    [Town]         NVARCHAR (MAX) NULL,
    [County]       NVARCHAR (MAX) NULL,
    [Postcode]     NVARCHAR (MAX) NULL,
    [Country]      NVARCHAR (MAX) NULL,
    [DateOfBirth]  NVARCHAR (MAX) NULL,
    [Email]        NVARCHAR (MAX) NULL,
    [PhoneNumber1] NVARCHAR (MAX) NULL,
    [PhoneNumber2] NVARCHAR (MAX) NULL,
    [PhoneNumber3] NVARCHAR (MAX) NULL,
    [PhoneNumber4] NVARCHAR (MAX) NULL,
    [JobTitle]     NVARCHAR (MAX) NULL,
	SuppliedURN	NVARCHAR (MAX) NULL,
	RecencyDateTime NVARCHAR(MAX) NULL DEFAULT GETDATE(),
	RecencyDateKey INT NULL,
	RecencyTimeKey SMALLINT NULL,
	SourceKey	SMALLINT NULL,
	AuditKey	INT NULL,
	RecordRejected	BIT	DEFAULT(0)	NOT NULL,
	CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([FeedBatchKey] ASC, [RowNumber] ASC) ON [CustomerPS] ([FeedBatchKey])
	--cannot cluster on FeedBatchKey/RowNumber if there will be parallel inserts to the same staging table!
);


GO
ALTER TABLE [Staging].[Customer] SET (LOCK_ESCALATION = AUTO);
