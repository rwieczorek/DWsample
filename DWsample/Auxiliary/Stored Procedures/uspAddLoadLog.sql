
/*============================================================================
Description	Insert Auxiliary.LoadLog: log current load instance

Parameters	@LoadKey
				Unique identifier of the load instance
			@StepKey
				Unique identifier of the load step
			@Container
				Name of code container being executed
			@Trace
				Name of fine grained audit trace
			@Detail
				Any supporting detail
			@LoadLogKey
				Output parameter, gives back the created LoadLogKey

Date			Author				Reason
-------------------------------------------
2017-09-12		Robert Wieczorek	Creation
==================================================================================*/ 
CREATE PROCEDURE Auxiliary.uspAddLoadLog
	@LoadKey SMALLINT
	,@StepKey TINYINT
	,@Container NVARCHAR(300)
	,@Trace NVARCHAR(1000) = NULL
	,@Detail NVARCHAR(1000) = NULL
	,@LoadLogKey INT OUTPUT

AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000)
	,@DeadlockRetryAttempts TINYINT = 5;

WHILE @DeadlockRetryAttempts > 0
BEGIN
	BEGIN TRY

		DECLARE @OutputT TABLE (LoadLogKey INT);
	
		INSERT INTO Auxiliary.LoadLog
				( LoadKey ,
				  StepKey ,
				  Container ,
				  Trace ,
				  Detail ,
				  RowsAffected ,
				  StartedAt ,
				  CompletedAt
				)
		OUTPUT Inserted.LoadLogKey INTO @OutputT
		VALUES  ( @LoadKey,
				  @StepKey,
				  @Container,
				  @Trace,
				  @Detail,
				  NULL , -- RowsAffected - bigint
				  SYSDATETIME() , -- StartedAt - datetime2
				  NULL  -- CompletedAt - datetime2
				)

		SELECT @LoadLogKey = LoadLogKey
		FROM @OutputT;

		SET @DeadlockRetryAttempts = 0;
	END TRY
	BEGIN CATCH

		IF ERROR_NUMBER() = 1205 AND @DeadlockRetryAttempts > 0
		BEGIN
			
			--	Retry on deadlock
			SET @DeadlockRetryAttempts -= 1;
		END
		ELSE
		BEGIN
			SET @ErrorMessage = ERROR_MESSAGE();

			--	Log error
			EXEC Auxiliary.uspAddLoadError @LoadKey
										,@StepKey
										,@Container
										,@Trace
										,@ErrorMessage;

			--	Rethrow error if desired
			THROW;
		END
	END CATCH
END