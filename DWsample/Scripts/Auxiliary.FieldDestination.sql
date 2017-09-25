SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.FieldDestination';

DROP TABLE IF EXISTS #FieldDestination;
	
DROP TABLE IF EXISTS #FieldDestinationMappings;


CREATE TABLE #FieldDestination(
	FieldKey SMALLINT NOT NULL
	,DestinationSchema SYSNAME NOT NULL
	,DestinationTable SYSNAME NOT NULL
	,DestinationColumn SYSNAME NOT NULL
);

CREATE TABLE #FieldDestinationMappings(
	SourceTable SYSNAME NOT NULL, 
	SourceColumn SYSNAME NOT NULL,
	DestinationSchema SYSNAME NOT NULL,
	DestinationTable SYSNAME NOT NULL,
	DestinationColumn SYSNAME NOT NULL
);

INSERT INTO #FieldDestinationMappings (
	SourceTable, 
	SourceColumn,
	DestinationSchema,
	DestinationTable,
	DestinationColumn
)
VALUES
(N'ExampleFeedOne', N'BusinessID', N'Staging', N'FeedExampleOne', N'BusinessID'), 
(N'ExampleFeedOne', N'Date', N'Staging', N'FeedExampleOne', N'Date'), 
(N'ExampleFeedOne', N'Value', N'Staging', N'FeedExampleOne', N'Value');
 
INSERT #FieldDestination(
	FieldKey	
	,DestinationSchema
	,DestinationTable
	,DestinationColumn)
SELECT
	fi.FieldKey,
	m.DestinationSchema,
	m.DestinationTable,
	m.DestinationColumn
FROM #FieldDestinationMappings m
INNER JOIN Auxiliary.Feed f ON m.SourceTable = f.Name
INNER JOIN Auxiliary.Field fi ON m.SourceColumn = fi.Name AND fi.FeedKey = f.FeedKey


INSERT Auxiliary.FieldDestination(
	FieldKey	
	,DestinationSchema
	,DestinationTable
	,DestinationColumn
)
SELECT 
	FieldKey	
	,DestinationSchema
	,DestinationTable
	,DestinationColumn
FROM #FieldDestination
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.FieldDestination
					WHERE FieldDestination.FieldKey = #FieldDestination.FieldKey
					AND FieldDestination.DestinationSchema = #FieldDestination.DestinationSchema
					AND FieldDestination.DestinationTable = #FieldDestination.DestinationTable
					AND FieldDestination.DestinationColumn = #FieldDestination.DestinationColumn
					);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.FieldDestination
WHERE NOT EXISTS(	SELECT 1 
					FROM #FieldDestination
					WHERE FieldDestination.FieldKey = #FieldDestination.FieldKey
					AND FieldDestination.DestinationSchema = #FieldDestination.DestinationSchema
					AND FieldDestination.DestinationTable = #FieldDestination.DestinationTable
					AND FieldDestination.DestinationColumn = #FieldDestination.DestinationColumn
					);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);

--UPDATE FieldDestination
--SET	
--	FieldKey = #FieldDestination.FieldKey,
--	FieldValue = #FieldDestination.FieldValue,
--	DecodeValue = #FieldDestination.DecodeValue
--FROM
--	Auxiliary.FieldDestination
--	INNER JOIN #FieldDestination
--		ON FieldDestination.FieldDestinationKey = #FieldDestination.FieldDestinationKey		
--		AND (FieldDestination.FieldKey <> #FieldDestination.FieldKey
--		OR FieldDestination.FieldValue <> #FieldDestination.FieldValue
--		OR FieldDestination.DecodeValue <> #FieldDestination.DecodeValue);

--PRINT NCHAR(9) +  N'Updates: ' + CAST(@@ROWCOUNT AS NVARCHAR);

