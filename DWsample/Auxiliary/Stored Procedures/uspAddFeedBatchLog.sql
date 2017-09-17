
/*============================================================================
Description	Insert Auxiliary.FeedBatchLog: the log of events relating to a data feed batch's load to Staging	

Parameters	@FeedBatchKey
				Unique identifier of the feed batch load instance
			@StepKey
				Unique identifier of the load step
			@Container
				Name of code container being executed
			@Trace
				Name of fine grained audit trace
			@Detail
				Any supporting detail
			@FeedBatchLogKey
				Output parameter, returns the unique identifier of feed batch log instance

Date			Author				Reason
-------------------------------------------
2017-09-12		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspAddFeedBatchLog
	@FeedBatchKey INT
	,@StepKey TINYINT
	,@Container NVARCHAR(300)
	,@Trace NVARCHAR(1000) = NULL
	,@Detail NVARCHAR(1000) = NULL
	,@FeedBatchLogKey INT OUTPUT

AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000);

BEGIN TRY

	DECLARE @OutputT TABLE (FeedBatchLogKey INT);
	
	INSERT INTO	Auxiliary.FeedBatchLog
	        ( FeedBatchKey ,
	          StepKey ,
	          Container ,
	          Trace ,
	          Detail ,
	          RowsAffected ,
	          StartedAt ,
	          CompletedAt
	        )
	OUTPUT Inserted.FeedBatchLogKey INTO @OutputT
	VALUES  ( @FeedBatchKey,
	          @StepKey,
	          @Container,
	          @Trace,
	          @Detail,
	          NULL , -- RowsAffected - bigint
	          SYSDATETIME() , -- StartedAt - datetime2
	          NULL  -- CompletedAt - datetime2
	        )

	SELECT @FeedBatchLogKey = FeedBatchLogKey
	FROM @OutputT

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