
/*============================================================================
Description	Insert Auxiliary.FeedBatch
			
			If insert fails, throws error to caller without logging

Parameters	@FeedKey
				Unique identifier of the Data Feed for which we are loading a batch of data
			@ExternalBatchID 
				External identifier for the batch of the data, allowing this batch to be tied to the original source
			@FileName
				Name of the file loaded
			@SourcePath
				Source path of the file loaded
			@FeedBatchKey
				Output parameter, gives back the created FeedBatchKey

Date			Author				Reason
-------------------------------------------
2017-09-09		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspAddFeedBatch
	@FeedKey TINYINT,
	@ExternalBatchID VARCHAR(MAX),
	--,@FileName NVARCHAR(300) = NULL
	--,@SourcePath NVARCHAR(500) = NULL
	@FeedBatchKey INT OUTPUT

AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000);

BEGIN TRY

	DECLARE @OutputT TABLE (FeedBatchKey INT);
	
	INSERT INTO Auxiliary.FeedBatch
	        ( FeedKey ,
	          ExternalBatchID ,
			  ProcessedToStagingBegan ,
	          ProcessedToStagingCompleted 
	          --FileName ,
	          --SourcePath ,
	          --PausedSince
	        )
	OUTPUT Inserted.FeedBatchKey INTO @OutputT
	VALUES  ( @FeedKey,
	          @ExternalBatchID,
	          SYSDATETIME(),
	          NULL  -- ProcessedToStagingCompleted - smalldatetime
	          --@FileName,
	          --@SourcePath,
	          --NULL  -- PausedSince - smalldatetime
	        )

	SELECT @FeedBatchKey = FeedBatchKey
	FROM @OutputT

END TRY
BEGIN CATCH
	--	Rethrow error if desired
	THROW;
END CATCH