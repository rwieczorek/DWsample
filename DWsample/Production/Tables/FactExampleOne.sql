CREATE TABLE [Production].[FactExampleOne]
(
	[FactExampleOneID] INT IDENTITY(1,1) NOT NULL,
	[SourceKey] TINYINT NOT NULL,
	[BusinessID] INT NOT NULL,
	[DateKey] INT NOT NULL,
    [Value]  DECIMAL (18,2) NULL,
    [InsertAuditKey] INT            NOT NULL,
    [UpdateAuditKey] INT            NOT NULL,
    CONSTRAINT [PK_Production_FactExampleOne] PRIMARY KEY CLUSTERED ([FactExampleOneID] ASC),
	CONSTRAINT [FK_Production_FactExampleOne_InsertAuditKey] FOREIGN KEY ([InsertAuditKey]) REFERENCES [Production].[DimAudit] ([AuditKey]),
    CONSTRAINT [FK_Production_FactExampleOne_UpdateAuditKey] FOREIGN KEY ([UpdateAuditKey]) REFERENCES [Production].[DimAudit] ([AuditKey]), 
);

GO

CREATE UNIQUE NONCLUSTERED INDEX UX_FactExampleOne_SourceKey_BusinessID   
   ON Production.[FactExampleOne] (SourceKey, BusinessID); 

GO
CREATE NONCLUSTERED INDEX IX_FactExampleOne_BusinessID   
   ON Production.[FactExampleOne] (BusinessID); 
