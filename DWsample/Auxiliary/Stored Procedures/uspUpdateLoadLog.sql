
/*============================================================================
Description	Update Auxiliary.LoadLog: change current load instance

Parameters	@LoadLogKey
				Unique identifier of the load log instance
			@Container
				Name of code container being executed
			@Trace
				Name of fine grained audit trace
			@Detail
				Any supporting detail
			@RowsAffected
				Number of rows affected by the load

Date			Author				Reason
-------------------------------------------
2017-09-12		Robert Wieczorek	Creation
==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspUpdateLoadLog
	@LoadLogKey INT
	,@Container NVARCHAR(300)
	,@Trace NVARCHAR(1000) = NULL
	,@Detail NVARCHAR(1000) = NULL
	,@RowsAffected BIGINT = NULL

AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000)
	,@LoadKey SMALLINT
	,@StepKey TINYINT;

BEGIN TRY

	IF NOT EXISTS (	
		SELECT	1 
		FROM	Auxiliary.LoadLog
		WHERE	LoadLogKey = @LoadLogKey)
	BEGIN
		SET @ErrorMessage =	CAST(@LoadLogKey AS NVARCHAR(4000)) + N' '
							+ N'LoadLogKey does not exist';
		THROW 50000, @ErrorMessage, 1;
	END

	SELECT @LoadKey = LoadKey, @StepKey = StepKey
	FROM Auxiliary.LoadLog
	WHERE LoadLogKey = @LoadLogKey

	

	IF EXISTS (	
		SELECT	1 
		FROM	Auxiliary.LoadLog
		WHERE	LoadLogKey = @LoadLogKey
				AND CompletedAt IS NOT NULL)
	BEGIN
		SET @ErrorMessage =	CAST(@LoadLogKey AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Container AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Trace AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@Detail AS NVARCHAR(4000)) + N' : ' 
							+ CAST(@RowsAffected AS NVARCHAR(4000)) + N' '
							+ N'LoadLog already exists and is completed';
		THROW 50000, @ErrorMessage, 1;
	END

	UPDATE Auxiliary.LoadLog
	SET 
		Container = @Container,
		Trace = @Trace,
		Detail = @Detail,
		RowsAffected = @RowsAffected,
		CompletedAt = SYSDATETIME()
	WHERE LoadLogKey = @LoadLogKey

END TRY
BEGIN CATCH
	SET @ErrorMessage = ERROR_MESSAGE();

	--	Log error
	EXEC Auxiliary.uspAddLoadError @LoadKey
								,@StepKey
								,@Container
								,@Trace
								,@ErrorMessage;

	--	Rethrow error if desired
	THROW;
END CATCH