SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.Field';

DROP TABLE IF EXISTS #Field;

CREATE TABLE #Field(	
	FeedKey TINYINT NOT NULL,
	Ordinal TINYINT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	Mandatory BIT NOT NULL	
)

CREATE UNIQUE CLUSTERED INDEX IX_Tmp_Field ON #Field(FeedKey, Name);

INSERT #Field(
	FeedKey
	,Ordinal
	,Name
	,Mandatory
)
SELECT FeedKey, 1 AS Ordinal, 'BusinessID' AS Name, 0 AS Mandatory FROM Auxiliary.Feed WHERE Name = N'ExampleFeedOne' 
UNION ALL SELECT FeedKey, 2 AS Ordinal, 'Date' AS Name, 0 AS Mandatory FROM Auxiliary.Feed WHERE Name = N'ExampleFeedOne' 
UNION ALL SELECT FeedKey, 3 AS Ordinal, 'Value' AS Name, 0 AS Mandatory FROM Auxiliary.Feed WHERE Name = N'ExampleFeedOne' 


INSERT Auxiliary.Field(
	FeedKey
	,Ordinal
	,Name
	,Mandatory
)
SELECT 
	FeedKey
	,Ordinal
	,Name
	,Mandatory
FROM #Field
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.Field 
					WHERE 
						Field.FeedKey = #Field.FeedKey
						AND Field.Name = #Field.Name);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.Field
WHERE NOT EXISTS(	SELECT 1 
					FROM #Field
					WHERE 
						Field.FeedKey = #Field.FeedKey
						AND Field.Name = #Field.Name);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);

UPDATE Field
SET	
	Ordinal = #Field.Ordinal	
	,Mandatory = #Field.Mandatory
FROM
	Auxiliary.Field
	INNER JOIN #Field
		ON Field.FeedKey = #Field.FeedKey
		AND Field.Name = #Field.Name
		AND (Field.Ordinal <> #Field.Ordinal	
			OR Field.Mandatory <> #Field.Mandatory);

PRINT NCHAR(9) +  N'Updates: ' + CAST(@@ROWCOUNT AS NVARCHAR);

