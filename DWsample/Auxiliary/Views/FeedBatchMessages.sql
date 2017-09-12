
/*============================================================================
Description	Returns contents of FeedBatchLog and FeedBatchError

Date			Author				Reason
-------------------------------------------
201709-12 		Robert Wieczorek	Creation
==================================================================================*/
CREATE VIEW Auxiliary.FeedBatchMessages

AS
SELECT
	FeedBatchKey
	,StageKey
	,StepKey
	,FeedBatchLogKey
	,FeedBatchErrorKey
	,LogType
	,Feed
	,ExternalBatchID	
	,Stage
	,Step
	,Container
	,Trace
	,Detail
	,ErrorMessage
	,RowsAffected
	,LoggedAt
	,CompletedAt	
FROM (
		SELECT 	
			N'Feed Step' AS LogType	
			,Feed.Name AS Feed
			,FeedBatch.ExternalBatchID
			,FeedBatchLog.FeedBatchKey
			,Stage.StageKey
			,Step.StepKey
			,Stage.Name AS Stage			
			,Step.Name AS Step
			,FeedBatchLog.Container
			,FeedBatchLog.Trace
			,FeedBatchLog.Detail
			,NULL AS ErrorMessage	
			,FeedBatchLog.RowsAffected
			,FeedBatchLog.StartedAt AS LoggedAt
			,FeedBatchLog.CompletedAt 
			,FeedBatchLog.FeedBatchLogKey
			,NULL AS FeedBatchErrorKey
		FROM 
			Auxiliary.FeedBatchLog 			
			INNER JOIN Auxiliary.Step
				ON FeedBatchLog.StepKey = Step.StepKey
			INNER JOIN Auxiliary.Stage
				ON Step.StageKey = Stage.StageKey
			INNER JOIN Auxiliary.FeedBatch
				ON FeedBatchLog.FeedBatchKey = FeedBatch.FeedBatchKey
			INNER JOIN Auxiliary.Feed
				ON FeedBatch.FeedKey = Feed.FeedKey
		UNION ALL
		SELECT  
			N'Error' AS LogType	
			,Feed.Name AS Feed
			,FeedBatch.ExternalBatchID
			,FeedBatchError.FeedBatchKey
			,Stage.StageKey
			,Step.StepKey
			,Stage.Name AS Stage			
			,Step.Name AS Step
			,FeedBatchError.Container		
			,FeedBatchError.Trace
			,FeedBatchError.Detail
			,FeedBatchError.Message AS ErrorMessage
			,NULL AS RowsAffected	
			,FeedBatchError.LoggedAt
			,NULL AS CompletedAt
			,NULL AS FeedBatchLogKey
			,FeedBatchError.FeedBatchErrorKey
		FROM 
			Auxiliary.FeedBatchError
			INNER JOIN Auxiliary.Step
				ON FeedBatchError.StepKey = Step.StepKey
			INNER JOIN Auxiliary.Stage
				ON Step.StageKey = Stage.StageKey
			INNER JOIN Auxiliary.FeedBatch
				ON FeedBatchError.FeedBatchKey = FeedBatch.FeedBatchKey
			INNER JOIN Auxiliary.Feed
				ON FeedBatch.FeedKey = Feed.FeedKey
	) AS LogMessages;