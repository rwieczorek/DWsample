
--/*============================================================================
--Description	Wrapper for procedures that load RedEye Opens data to relevant dimensions and fact tables in PreLoad and Production

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------


--==================================================================================*/
--CREATE PROCEDURE Staging.uspLoadRedEyeOpens
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

----	Set AuditKeys 
--BEGIN TRY
--	EXEC PreLoad.uspSetAuditKeys Staging, N'RedEye Opens', AuditKey, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetAuditKeys RedEyeOpens';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	Set SourceKeys
--BEGIN TRY
--	EXEC PreLoad.uspSetSourceKeys Staging, N'RedEye Opens', NULL, SourceKey, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetSourceKeys RedEyeOpens';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	Load Dimensions to PreLoad and Production
--EXEC PreLoad.uspLoadRedEyeOpensDimensions @LoadKey, @StepKey;

----	Write Dimension keys back to Staging table
--EXEC PreLoad.uspSetRedEyeOpensDimensionKeys @LoadKey, @StepKey;

----	Load Facts to PreLoad and Production
--EXEC PreLoad.uspLoadRedEyeOpensFacts @LoadKey, @StepKey;
