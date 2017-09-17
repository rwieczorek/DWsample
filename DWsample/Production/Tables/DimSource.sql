CREATE TABLE [dbo].[DimSource]
(
	[SourceKey] TINYINT IDENTITY(1,1) NOT NULL,
	[SourceName] VARCHAR(50) NOT NULL,
	[InsertAuditKey] INT            NOT NULL,
    [UpdateAuditKey] INT            NOT NULL,
	CONSTRAINT [PK_Production_DimSource] PRIMARY KEY CLUSTERED ([SourceKey] ASC),
	CONSTRAINT [FK_Production_DimSource_InsertAuditKey] FOREIGN KEY ([InsertAuditKey]) REFERENCES [Production].[DimAudit] ([AuditKey]),
    CONSTRAINT [FK_Production_DimSource_UpdateAuditKey] FOREIGN KEY ([UpdateAuditKey]) REFERENCES [Production].[DimAudit] ([AuditKey]), 
)
