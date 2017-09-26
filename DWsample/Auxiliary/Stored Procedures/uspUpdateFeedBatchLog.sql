
/*============================================================================
Purpose:	Update Auxiliary.FeedBatchLog: update feed batch log instance

Parameters	@FeedBatchLogKey
				Unique identifier of feed batch log instance
			@Container
				Name of code container (e.g. SSIS packgage or Stored Proc) being executed
			@Trace
				Name of fine grained audit trace
			@Detail
				Any supporting detail
			@RowsAffected
				Number of rows affected

Date			Author				Reason
-------------------------------------------
2017-09-10		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE PROCEDURE [Auxiliary].[uspUpdateFeedBatchLog]
	@FeedBatchLogKey INT 
	,@Container NVARCHAR(300) = NULL
	,@Trace NVARCHAR(1000) = NULL
	,@Detail NVARCHAR(1000) = NULL
	,@RowsAffected BIGINT = NULL

AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000)
	,@FeedBatchKey INT
	,@StepKey TINYINT;

BEGIN TRY

	IF NOT EXISTS (	
		SELECT	1 
		FROM	Auxiliary.FeedBatchLog
		WHERE	FeedBatchLogKey = @FeedBatchLogKey)
	BEGIN
		SET @ErrorMessage =	CAST(@FeedBatchLogKey AS NVARCHAR(4000)) + N' '
							+ N'FeedBatchLogKey does not exist';
		THROW 50000, @ErrorMessage, 1;
	END

	SELECT @FeedBatchKey = FeedBatchKey, @StepKey = StepKey
	FROM Auxiliary.FeedBatchLog
	WHERE FeedBatchLogKey = @FeedBatchLogKey


	IF EXISTS (	
		SELECT	1 
		FROM	Auxiliary.FeedBatchLog
		WHERE	FeedBatchLogKey = @FeedBatchLogKey
				AND CompletedAt IS NOT NULL)
	BEGIN
		SET @ErrorMessage =	CAST(@FeedBatchLogKey AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Container AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Trace AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Detail AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@RowsAffected AS NVARCHAR(4000)) + N' '
							+ N'FeedFileLog already exists and is completed';
		THROW 50000, @ErrorMessage, 1;
	END
	
	UPDATE fl
	SET 
		Container = ISNULL(@Container, fl.Container),
		Trace = ISNULL(@Trace, fl.Trace),
		Detail = ISNULL(@Detail, fl.Detail),
		RowsAffected = @RowsAffected,
		CompletedAt = SYSDATETIME()
	FROM Auxiliary.FeedBatchLog fl
	WHERE FeedBatchLogKey = @FeedBatchLogKey

END TRY
BEGIN CATCH
	SET @ErrorMessage = ERROR_MESSAGE();

	--	Log error
	EXEC Auxiliary.uspAddFeedBatchError	@FeedBatchKey
										,@StepKey
										,@Container
										,@Trace
										,@ErrorMessage;

	--	Rethrow error if desired
	THROW;
END CATCH