SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.DateTimeKeyDestination';

IF OBJECT_ID(N'tempdb..#DateTimeKeyDestination') IS NOT NULL
	DROP TABLE #DateTimeKeyDestination;

CREATE TABLE #DateTimeKeyDestination(
	[SourceSchema] [sysname] NOT NULL
	,[SourceTable] [sysname] NOT NULL
	,[SourceColumn] [sysname] NOT NULL
	,[DestinationSchema] [sysname] NOT NULL
	,[DestinationTable] [sysname] NOT NULL
	,[DestinationColumn] [sysname] NOT NULL
	,[TimeConversion] [BIT] NOT NULL DEFAULT ((0))	
);

CREATE UNIQUE CLUSTERED INDEX [PK_#FieldDateTimeKeyDestination] ON #DateTimeKeyDestination
(
	[SourceSchema] ASC
	,[SourceTable] ASC
	,[SourceColumn] ASC
	,[DestinationSchema] ASC
	,[DestinationTable] ASC
	,[DestinationColumn] ASC);

INSERT #DateTimeKeyDestination(
	SourceSchema
	,SourceTable
	,SourceColumn
	,DestinationSchema
	,DestinationTable
	,DestinationColumn
	,TimeConversion)
VALUES
    (N'Staging', N'FeedExampleOne', N'Date', N'Staging', N'FeedExampleOne', N'DateKey', 0)
	,(N'Staging', N'FeedExampleOne', N'Date', N'Staging', N'FeedExampleOne', N'TimeKey', 1);
	
INSERT Auxiliary.DateTimeKeyDestination(
	SourceSchema
	,SourceTable
	,SourceColumn
	,DestinationSchema
	,DestinationTable
	,DestinationColumn
	,TimeConversion)
SELECT 
	SourceSchema
	,SourceTable
	,SourceColumn
	,DestinationSchema
	,DestinationTable
	,DestinationColumn
	,TimeConversion
FROM #DateTimeKeyDestination
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.DateTimeKeyDestination 
					WHERE 
						#DateTimeKeyDestination.SourceSchema = DateTimeKeyDestination.SourceSchema
						AND #DateTimeKeyDestination.SourceTable = DateTimeKeyDestination.SourceTable
						AND #DateTimeKeyDestination.SourceColumn = DateTimeKeyDestination.SourceColumn
						AND #DateTimeKeyDestination.DestinationSchema = DateTimeKeyDestination.DestinationSchema
						AND #DateTimeKeyDestination.DestinationTable = DateTimeKeyDestination.DestinationTable
						AND #DateTimeKeyDestination.DestinationColumn = DateTimeKeyDestination.DestinationColumn
						AND #DateTimeKeyDestination.TimeConversion = DateTimeKeyDestination.TimeConversion);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.DateTimeKeyDestination
WHERE NOT EXISTS(	SELECT 1 
					FROM #DateTimeKeyDestination
					WHERE
						#DateTimeKeyDestination.SourceSchema = DateTimeKeyDestination.SourceSchema
						AND #DateTimeKeyDestination.SourceTable = DateTimeKeyDestination.SourceTable
						AND #DateTimeKeyDestination.SourceColumn = DateTimeKeyDestination.SourceColumn
						AND #DateTimeKeyDestination.DestinationSchema = DateTimeKeyDestination.DestinationSchema
						AND #DateTimeKeyDestination.DestinationTable = DateTimeKeyDestination.DestinationTable
						AND #DateTimeKeyDestination.DestinationColumn = DateTimeKeyDestination.DestinationColumn
						AND #DateTimeKeyDestination.TimeConversion = DateTimeKeyDestination.TimeConversion);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);