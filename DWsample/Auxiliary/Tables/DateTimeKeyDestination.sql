CREATE TABLE [Auxiliary].[DateTimeKeyDestination] (
    [SourceSchema] [sysname] NOT NULL,
    [SourceTable]  [sysname] NOT NULL,
    [SourceColumn] [sysname] NOT NULL,
    [DestinationSchema] [sysname] NOT NULL,
    [DestinationTable]  [sysname] NOT NULL,
    [DestinationColumn] [sysname] NOT NULL,
	TimeConversion	BIT	NOT NULL DEFAULT(0),
    CONSTRAINT [PK_Auxiliary_FieldDateTimeKeyDestination] PRIMARY KEY CLUSTERED ([SourceSchema] ASC, [SourceTable] ASC, [SourceColumn] ASC, [DestinationSchema] ASC, [DestinationTable] ASC, [DestinationColumn] ASC)     
);
