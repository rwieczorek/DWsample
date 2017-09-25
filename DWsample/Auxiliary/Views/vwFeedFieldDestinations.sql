
/*============================================================================
Description	Returns mappings of Feed Fields to staging table columns

Date			Author				Reason
-------------------------------------------
2017-09-25 		Robert Wieczorek	Creation

==================================================================================*/
CREATE VIEW Auxiliary.vwFeedFieldDestinations

AS

SELECT 
	Feed.FeedKey
	--,Feed.ThirdPartyKey
	--,Feed.IdentifierTypeKey
	,Feed.Name AS FeedName
	--,Feed.Export
	--,Feed.FileMask	
	,Feed.HierarchyRank
	,Field.FieldKey	
	,Field.Ordinal
	,Field.Name AS FieldName
	,Field.Mandatory	
	,FieldDestination.DestinationSchema
	,FieldDestination.DestinationTable
	,FieldDestination.DestinationColumn 
FROM 
	Auxiliary.Feed
	INNER JOIN Auxiliary.Field
		ON Field.FeedKey = Feed.FeedKey
	INNER JOIN Auxiliary.FieldDestination
		ON FieldDestination.FieldKey = Field.FieldKey;