
--/*============================================================================
--Description	Wrapper for procedures that write dimension keys from Production back to Staging.RedEye Clicks

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------

--==================================================================================*/
--CREATE PROCEDURE PreLoad.uspSetRedEyeClicksDimensionKeys
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

----	DimCampaign
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksCampaignKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksCampaignKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailDelivery
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksEmailDeliveryKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksEmailDeliveryKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailEventType
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksEmailEventTypeKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksEmailEventTypeKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmail
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksEmailKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksEmailKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimCustomer - attempt DBGID infer from EmailKey
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeDBGID @LoadKey, @StepKey, N'RedEye Clicks';
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeDBGID Clicks';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimCustomer
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksCustomerKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksCustomerKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimURL
--BEGIN TRY
--	EXEC PreLoad.uspSetRedEyeClicksURLKey @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspSetRedEyeClicksURLKey';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH