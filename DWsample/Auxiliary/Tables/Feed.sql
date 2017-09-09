CREATE TABLE [Auxiliary].[Feed] (
    [FeedKey]           TINYINT        IDENTITY (1, 1) NOT NULL,
    --[ThirdPartyKey]     TINYINT        NOT NULL,
    --[IdentifierTypeKey] TINYINT        NOT NULL,
    [Name]              NVARCHAR (50)  NOT NULL,
	[DataSource]        NVARCHAR (50)  NOT NULL,
    --[Export]            BIT            NULL,
    --[FileMask]          NVARCHAR (100) NULL,
    --[TextQualifier]     VARBINARY (10) NULL,
    --[FieldDelimiter]    VARBINARY (10) NULL,
    --[RowDelimiter]      VARBINARY (10) NULL,
    [LoadToStaging]     BIT NOT NULL DEFAULT 1,
    --[LoadToDTV]			BIT NOT NULL DEFAULT 0,
    --[NeedsXMLFlatten]	BIT NOT NULL DEFAULT 0,
	[HierarchyRank]		TINYINT NULL,
    CONSTRAINT [PK_Auxiliary_Feed] PRIMARY KEY CLUSTERED ([FeedKey] ASC),
	CONSTRAINT [UK_Name] UNIQUE(Name) 
    --CONSTRAINT [FK_Auxiliary_Feed_IdentifierTypeKey] FOREIGN KEY ([IdentifierTypeKey]) REFERENCES [Auxiliary].[IdentifierType] ([IdentifierTypeKey]),
    --CONSTRAINT [FK_Auxiliary_Feed_ThirdPartyKey] FOREIGN KEY ([ThirdPartyKey]) REFERENCES [Auxiliary].[ThirdParty] ([ThirdPartyKey])
);



