/*============================================================================
Name:		fnFeedDecodesEnumeratedByTable
Purpose:	Returns FieldDecode.FieldDecodeKeys with a table enumeration from 1 to @DoP 
			(so all decodes for the same table for the same feed will have the same bucket)
			
			NB. Buckets are worked out by mod of row number, ordered by the number of rows across all partitions divided by the number of indexes on the table.
			This tends to leave one bucket slightly larger than than the others as occassional large tables with many indexes skew the distribution

Parameters	
			@FeedBatchKey
				FeedBatchKey to derive Fields to indicate which decodes need to be applied
			@DoP (default 2)
				Tables will be returned numbered from 1 to @DoP
			
Date			Author				Reason
-------------------------------------------
2017-09-10		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE FUNCTION Auxiliary.fnFeedDecodesEnumeratedByTable
(
	@FeedFileKey INT
	,@DoP TINYINT = 2
)
RETURNS TABLE
AS
RETURN
WITH cte_table_bucket AS (
	SELECT 
		schemas.name AS [Schema]
		,tables.name AS [Table]
		,1 + ROW_NUMBER() OVER (PARTITION BY schemas.name 
								ORDER BY SUM(partitions.rows) / COUNT(DISTINCT partitions.index_id) DESC) % @DoP AS Bucket		 
	FROM 
		sys.tables
		INNER JOIN sys.objects
			ON tables.object_id = objects.object_id			
		INNER JOIN sys.schemas
			ON objects.schema_id = schemas.schema_id			
		INNER JOIN sys.partitions
			ON objects.object_id = partitions.object_id
	GROUP BY
		schemas.name
		,tables.name)
SELECT	
	FieldDecode.FieldDecodeKey
	,cte_table_bucket.Bucket
FROM
	Auxiliary.FieldDecode		
	INNER JOIN Auxiliary.Field
		ON FieldDecode.FieldKey = Field.FieldKey
	INNER JOIN Auxiliary.FieldDestination
		ON FieldDestination.FieldKey = Field.FieldKey
	INNER JOIN Auxiliary.Feed
		ON Feed.FeedKey = Field.FeedKey
	INNER JOIN Auxiliary.FeedBatch
		ON Feed.FeedKey = FeedBatch.FeedKey		
		AND FeedBatch.FeedBatchKey = @FeedFileKey	
	INNER JOIN cte_table_bucket
		ON FieldDestination.DestinationSchema = cte_table_bucket.[Schema]
		AND REPLACE(REPLACE(FieldDestination.DestinationTable, N'[', N''), N']', N'') = cte_table_bucket.[Table];
;