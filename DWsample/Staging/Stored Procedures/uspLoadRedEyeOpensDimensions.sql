
--/*============================================================================
--Description	Wrapper for procedures that load RedEyeOpens data to relevant dimensions

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------


--==================================================================================*/
--CREATE PROCEDURE Staging.uspLoadRedEyeOpensDimensions
--	@LoadKey SMALLINT
--	,@StepKey TINYINT NULL	
--AS

--DECLARE 
--	@Trace NVARCHAR(1000)
--	,@Detail NVARCHAR(1000)
--	,@ErrorMessage NVARCHAR(512)
--	,@Container NVARCHAR(300) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)	
--	,@RowsAffected BIGINT	
--	,@LoadLogKey INT
--	,@Rows INT
--	,@LoopLimit SMALLINT = 10000
--	,@LoopCounter SMALLINT = 0;

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

--/***************************
--	Load to PreLoad
--****************************/

----	DimCampaign
--BEGIN TRY
--	EXEC PreLoad.uspLoadRedEyeOpensDimCampaign @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadRedEyeOpensDimCampaign';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailDelivery
--BEGIN TRY
--	EXEC PreLoad.uspLoadRedEyeOpensDimEmailDelivery @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadRedEyeOpensDimEmailDelivery';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailEventType
--BEGIN TRY
--	EXEC PreLoad.uspLoadRedEyeOpensDimEmailEventType @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadRedEyeOpensDimEmailEventType';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmail
--BEGIN TRY
--	EXEC PreLoad.uspLoadRedEyeOpensDimEmail @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadRedEyeOpensDimEmail';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

--/***************************
--	Load to Production
--****************************/
----	DimCampaign
--BEGIN TRY
--	EXEC PreLoad.uspLoadTable PreLoad, DimCampaign, Production, DimCampaign, 0, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadTable DimCampaign';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailDelivery
--BEGIN TRY
--	EXEC PreLoad.uspLoadTable PreLoad, DimEmailDelivery, Production, DimEmailDelivery, 0, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadTable DimEmailDelivery';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmailEventType
--BEGIN TRY
--	EXEC PreLoad.uspLoadTable PreLoad, DimEmailEventType, Production, DimEmailEventType, 0, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadTable DimEmailEventType';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	DimEmail
--BEGIN TRY
--	EXEC PreLoad.uspLoadTable PreLoad, DimEmail, Production, DimEmail, 0, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadTable DimEmail';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH