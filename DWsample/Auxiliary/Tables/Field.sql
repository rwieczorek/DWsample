CREATE TABLE [Auxiliary].[Field] (
    [FieldKey]  SMALLINT      IDENTITY (1, 1) NOT NULL,
    [FeedKey]   TINYINT       NOT NULL,
    [Ordinal]   TINYINT       NOT NULL,
    [Name]      NVARCHAR (50) NOT NULL,
    [Mandatory] BIT           NULL,
    CONSTRAINT [PK_Auxiliary_Field] PRIMARY KEY CLUSTERED ([FieldKey] ASC),
    CONSTRAINT [FK_Auxiliary_Field_FeedKey] FOREIGN KEY ([FeedKey]) REFERENCES [Auxiliary].[Feed] ([FeedKey])
);