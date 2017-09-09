
/*============================================================================
Description	Return an Auxiliary.Feed record by Feed.Name				

Parameters	@Name
				Unique Name of the Feed to return 
			
Date			Author				Reason
-------------------------------------------
2017-09-09		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE PROCEDURE [Auxiliary].[uspGetFeedByName]
	@Name NVARCHAR(50)
AS
SET NOCOUNT ON;

BEGIN TRY

	SELECT 
		FeedKey
		--,ThirdPartyKey
		--,IdentifierTypeKey
		,Name
		,DataSource
		--,Export
		--,FileMask
		--,TextQualifier
		--,FieldDelimiter
		--,RowDelimiter
	FROM Auxiliary.Feed
	WHERE Name = @Name;

END TRY
BEGIN CATCH
	--	Rethrow error 
	THROW;
END CATCH