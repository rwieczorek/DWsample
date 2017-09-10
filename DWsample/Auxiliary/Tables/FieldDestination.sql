CREATE TABLE [Auxiliary].[FieldDestination] (
    [FieldKey]          SMALLINT  NOT NULL,
    [DestinationSchema] [sysname] NOT NULL,
    [DestinationTable]  [sysname] NOT NULL,
    [DestinationColumn] [sysname] NOT NULL,
    CONSTRAINT [PK_Auxiliary_FieldDestination] PRIMARY KEY CLUSTERED ([FieldKey] ASC, [DestinationSchema] ASC, [DestinationTable] ASC, [DestinationColumn] ASC) ,
    CONSTRAINT [FK_Auxiliary_FieldDestination_FieldKey] FOREIGN KEY ([FieldKey]) REFERENCES [Auxiliary].[Field] ([FieldKey])
);
