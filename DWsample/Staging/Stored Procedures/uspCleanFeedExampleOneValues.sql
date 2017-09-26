/*============================================================================
Description	Clean Staging.FeedExampleOne.Value to not contain non numeric characters
			Empty strings will be set as 0

Parameters	@FeedBatchKey,
				Current FeedBatchKey
			@StepKey
				StepKey against which to log events
				If null will default to 'Dependent Decodes'

Date			Author				Reason
-------------------------------------------
2017-09-26		Robert Wieczorek	Creation
==================================================================================*/ 
CREATE PROCEDURE [Staging].[uspCleanFeedExampleOneValues]
(
	@FeedBatchKey INT
	,@StepKey TINYINT = NULL
)
AS
SET NOCOUNT ON;

DECLARE 
	@Trace NVARCHAR(1000)
	,@Detail NVARCHAR(1000)
	,@ErrorMessage NVARCHAR(512)
	,@Container NVARCHAR(300) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)	
	,@RowsAffected BIGINT	
	,@FeedBatchLogKey INT;

SELECT @StepKey = StepKey 
FROM Auxiliary.Step 
WHERE 
	StepKey = @StepKey
	OR (@StepKey IS NULL 
		AND Name = N'Dependent Decodes');

IF @StepKey IS NULL
BEGIN	
	SET @ErrorMessage = N'StepKey ' + COALESCE(CAST(@StepKey AS NVARCHAR(10)), N'') + N' not found';
	THROW 50000, @ErrorMessage, 1;
END    		

BEGIN TRY
BEGIN TRANSACTION
	
	SELECT @Trace = N'Update Staging.Charter Sum of Payments', @Detail = N'Strip non numeric characters';
	EXEC Auxiliary.uspAddFeedBatchLog @FeedBatchKey, @StepKey, @Container, @Trace, @Detail, @FeedBatchLogKey OUTPUT;	
	
	UPDATE Staging.FeedExampleOne
	SET [Value] = COALESCE(NULLIF(Auxiliary.fnStripNonNumericChars([Value]), N''), N'0')
	WHERE FeedBatchKey = @FeedBatchKey;
	
	SET @RowsAffected = @@ROWCOUNT;	
	EXEC Auxiliary.uspUpdateFeedBatchLog @FeedBatchLogKey, @Container, @Trace, @Detail, @RowsAffected;

	IF XACT_STATE()	= 1
	BEGIN    
		COMMIT TRANSACTION;									
	END
	ELSE
	BEGIN	
		SET @ErrorMessage = @Trace + N': Uncommitable transaction';
		THROW 50000, @ErrorMessage, 1;
	END   
END TRY
BEGIN CATCH
		
	SET @ErrorMessage = LEFT(ERROR_MESSAGE(), 512);

	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;	
	
	EXEC Auxiliary.uspAddFeedBatchError @FeedBatchKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;

	THROW;
END CATCH
