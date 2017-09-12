
/*============================================================================
Description	Sets a ProcessedToStagingCompleted = current time for a FeedBatchKey
			
			If update fails, throws error to caller without logging

Parameters	@FeedFileKey
				Unique identifier of the feed file load instance
			@FileName
				Name of the file loaded
			@SourcePath
				Source path of the file loaded

Date			Author				Reason
-------------------------------------------
2017-09-12		Robert Wieczorek	Creation
==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspSetFeedBatchProcessedToStagingCompleted
	@FeedBatchKey INT	

AS
SET NOCOUNT ON;

DECLARE 
	@Trace NVARCHAR(1000)
	,@Detail NVARCHAR(1000)	
	,@ErrorMessage NVARCHAR(512)			
	,@Container NVARCHAR(300) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)	 	
	,@FeedBatchLogKey INT
	,@RowsAffected INT
	,@StepKey TINYINT;

SELECT @StepKey = StepKey 
FROM Auxiliary.Step 
WHERE Name = N'Post Validation';
	
BEGIN TRY

	SELECT @Trace = N'Updating Auxiliary.FeedBatch', @Detail = N'Setting ProcessedToStagingCompleted';
	EXEC Auxiliary.uspAddFeedBatchLog @FeedBatchKey, @StepKey, @Container, @Trace, @Detail, @FeedBatchLogKey OUTPUT;
	
	IF NOT EXISTS (	
		SELECT	1 
		FROM	Auxiliary.FeedBatch
		WHERE	FeedBatchKey = @FeedBatchKey)
	BEGIN
		SET @ErrorMessage =	CAST(@FeedBatchKey AS NVARCHAR(4000)) + N' '
							+ N'FeedBatchKey does not exist';
		THROW 50000, @ErrorMessage, 1;
	END

	IF EXISTS (	
		SELECT	1 
		FROM	Auxiliary.FeedBatch
		WHERE	FeedBatchKey = @FeedBatchKey 
				AND ProcessedToStagingCompleted IS NOT NULL)
	BEGIN
		SET @ErrorMessage =	CAST(@FeedBatchKey AS NVARCHAR(4000)) + N' : ' 							
							+ N'Feed Batch already exists and is completed';
		THROW 50000, @ErrorMessage, 1;
	END

	UPDATE Auxiliary.FeedBatch
	SET ProcessedToStagingCompleted = CURRENT_TIMESTAMP
	WHERE FeedBatchKey = @FeedBatchKey;

	SET @RowsAffected = @@ROWCOUNT;	
	EXEC Auxiliary.uspUpdateFeedFileLog @FeedBatchLogKey = @FeedBatchLogKey, @RowsAffected = @RowsAffected;
	
END TRY
BEGIN CATCH
	
	SET @ErrorMessage = ERROR_MESSAGE();

	--	Rollback any open transactions
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		
	--	Log error
	IF @FeedBatchKey IS NOT NULL
		EXEC Auxiliary.uspAddFeedBatchError	@FeedBatchKey, @StepKey, @Container, @Trace, @ErrorMessage;

	--	Don't rethrow this
	--	THROW;
END CATCH