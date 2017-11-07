--/*============================================================================
--Description	Loads DimEmail from RedEye Opens data

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------


--==================================================================================*/
--CREATE PROCEDURE Staging.uspLoadRedEyeOpensDimEmail
--	@LoadKey SMALLINT
--	,@StepKey TINYINT NULL	
--AS

--DECLARE 
--	@Trace NVARCHAR(1000)
--	,@Detail NVARCHAR(1000)
--	,@ErrorMessage NVARCHAR(512)
--	,@Container NVARCHAR(300) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)	
--	,@RowsAffected BIGINT	
--	,@LoadLogKey INT;

--SELECT @StepKey = StepKey 
--FROM Auxiliary.Step 
--WHERE 
--	StepKey = @StepKey
--	OR (@StepKey IS NULL 
--		AND Name = N'Email Events');

--IF @StepKey IS NULL
--BEGIN	
--	SET @ErrorMessage = N'StepKey ' + COALESCE(CAST(@StepKey AS NVARCHAR(10)), N'') + N' not found';
--	THROW 50000, @ErrorMessage, 1;
--END    		

--BEGIN TRANSACTION
--BEGIN TRY

--	SET @Trace = N'Load PreLoad.DimEmail';	
--	EXEC Auxiliary.uspAddLoadLog @LoadKey, @StepKey, @Container, @Trace, @Detail, @LoadLogKey OUTPUT;

--	TRUNCATE TABLE PreLoad.DimEmail;

--	INSERT PreLoad.DimEmail(
--		EmailAddress
--		,DTVEmailStatus
--		,Emailable
--		,HeartBeatDateKey
--		,HeartBeatTimeKey
--		,InsertSourceKey
--		,UpdateSourceKey
--		,InsertAuditKey
--		,UpdateAuditKey
--		,Inferred)
--	SELECT
--		[Email Address]
--		,NULL AS DTVEmailStatus
--		,0 AS Emailable
--		,-1 AS HeartBeatDateKey
--		,-1 AS HeartBeatTimeKey
--		,MIN(SourceKey) AS InsertSourceKey
--		,MIN(SourceKey) AS UpdateSourceKey
--		,MIN(AuditKey) AS InsertAuditKey
--		,MAX(AuditKey) AS UpdateAuditKey
--		,1 AS Inferred
--	FROM Staging.[RedEye Opens]		
--	WHERE 
--		RecordRejected = 0
--		AND NOT EXISTS (SELECT 1 
--						FROM Production.DimEmail AS DimEmailProduction 
--						WHERE DimEmailProduction.EmailAddress = [RedEye Opens].[Email Address])
--	GROUP BY [Email Address];

--	SET @RowsAffected = @@ROWCOUNT;
--	EXEC Auxiliary.uspUpdateLoadLog @LoadLogKey, @Container, @Trace, @Detail, @RowsAffected;

--	IF XACT_STATE()	= 1
--	BEGIN    
--		COMMIT TRANSACTION;									
--	END
--	ELSE
--	BEGIN	
--		SET @ErrorMessage = @Trace + N': Uncommitable transaction';
--		THROW 50000, @ErrorMessage, 1;
--	END   
--END TRY
--BEGIN CATCH
		
--	SET @ErrorMessage = LEFT(ERROR_MESSAGE(), 512);

--	IF @@TRANCOUNT > 0
--		ROLLBACK TRANSACTION;	
	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;

--	THROW;
--END CATCH