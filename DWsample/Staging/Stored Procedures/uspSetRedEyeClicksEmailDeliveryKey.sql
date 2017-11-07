--/*============================================================================
--Description	Writes DimEmailDelivery.EmailDeliveryKey to Staging.RedEye Clicks 

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------

--==================================================================================*/
--CREATE PROCEDURE PreLoad.uspSetRedEyeClicksEmailDeliveryKey
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
		
--	SET @Trace = N'Set Staging.RedEye Clicks.EmailDeliveryKey';	
--	EXEC Auxiliary.uspAddLoadLog @LoadKey, @StepKey, @Container, @Trace, @Detail, @LoadLogKey OUTPUT
    	
	
--	UPDATE [RedEye Clicks]
--	SET EmailDeliveryKey = DimEmailDelivery.EmailDeliveryKey
--	FROM 
--		Staging.[RedEye Clicks]
--		INNER JOIN Production.DimEmailDelivery
--			ON DimEmailDelivery.DeliveryId = [RedEye Clicks].[Schedule ID]
--			AND DimEmailDelivery.DeliveryName = [RedEye Clicks].Schedule
--			AND DimEmailDelivery.DeliveryListId = [RedEye Clicks].[Mail ID]
--			AND DimEmailDelivery.DeliveryList = [RedEye Clicks].[Target List]
--			AND [RedEye Clicks].RecordRejected = 0;

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