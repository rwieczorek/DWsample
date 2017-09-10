
/*============================================================================
Description	Insert Auxiliary.FeedBatchError: log error in feed file load
			
			If insert fails, throws error to caller without logging

Date			Author				Reason
-------------------------------------------
2017-09-10		Robert Wieczorek    Creation

==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspAddFeedBatchError
	@FeedBatchKey INT
	,@StepKey TINYINT
	,@Container NVARCHAR(300)
	,@Trace NVARCHAR(1000)
	,@Message NVARCHAR(4000) = NULL
	,@Detail NVARCHAR(1000) = NULL	

AS
SET NOCOUNT ON;

BEGIN TRY
	
	INSERT Auxiliary.FeedBatchError(	
		 FeedBatchKey
		,StepKey
		,Container
		,Trace
		,Message
		,Detail)
	VALUES( 
		 @FeedBatchKey
		,@StepKey
		,@Container
		,@Trace
		,@Message
		,@Detail);

END TRY

BEGIN CATCH

	THROW;
END CATCH