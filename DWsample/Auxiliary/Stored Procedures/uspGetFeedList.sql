
/*============================================================================
Description	Return a list of Auxiliary.Feed records


Date			Author				Reason
-------------------------------------------
2017-09-17		Robert Wieczorek	Creation

==================================================================================*/
CREATE PROCEDURE [Auxiliary].uspGetFeedList
AS
SET NOCOUNT ON;

BEGIN TRY

    SELECT [FeedKey],
           [Name],
           [DataSource],
           [HierarchyRank]
    FROM Auxiliary.Feed
    WHERE LoadToStaging = 1
          AND IsActive = 1;


END TRY
BEGIN CATCH

    --	Rethrow error 
    THROW;
END CATCH;