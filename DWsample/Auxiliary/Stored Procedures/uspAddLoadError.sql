
/*============================================================================
Description	Insert Auxiliary.LoadError: log load error
			Closes off any open Auxiliary.AuditLog records for this Load, Step, Container and Trace combination
			
			If insert fails, throws error to caller without logging

Parameters	@LoadKey
				Unique identifier of the load instance
			@StepKey
				Unique identifier of the load step
			@Container
				Name of code container being executed
			@Trace
				Name of fine grained audit trace
			@Message
				Source error message
			@Detail
				Any supporting detail

Date			Author				Reason
-------------------------------------------
2017-09-12		Robert Wieczorek    Creation

==================================================================================*/ 
CREATE PROCEDURE [Auxiliary].[uspAddLoadError]
	@LoadKey SMALLINT
	,@StepKey TINYINT
	,@Container NVARCHAR(300)
	,@Trace NVARCHAR(1000) = NULL
	,@Message NVARCHAR(1000) = NULL
	,@Detail NVARCHAR(1000) = NULL

AS
SET NOCOUNT ON;

DECLARE @DeadlockRetryAttempts TINYINT = 5;

BEGIN TRY

	INSERT INTO Auxiliary.LoadError
	        ( LoadKey,
	          StepKey,
	          LoggedAt,
	          Container,
	          Trace,
	          Message,
	          Detail
	        )
	VALUES  ( @LoadKey,
	          @StepKey,
	          SYSDATETIME(),
	          @Container, 
	          @Trace,
	          @Message,
	          @Detail
	        )

END TRY
BEGIN CATCH
	
	THROW;

END CATCH

WHILE @DeadlockRetryAttempts > 0
BEGIN
	BEGIN TRY
	
		--	Close off open audit log entries for this combination of Load, Step, Container and Trace
		UPDATE Auxiliary.LoadLog
		SET CompletedAt = SYSDATETIME()
		WHERE	
			LoadKey = @LoadKey
			AND StepKey = @StepKey
			AND Container = @Container
			AND Trace = @Trace
			AND CompletedAt IS NULL;

		SET @DeadlockRetryAttempts = 0;
	END TRY
	BEGIN CATCH
		
		IF ERROR_NUMBER() = 1205 AND @DeadlockRetryAttempts > 0			
			--	Retry on deadlock
			SET @DeadlockRetryAttempts -= 1;		
		ELSE			
			THROW;		
	END CATCH
END