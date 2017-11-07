
--/*============================================================================
--Description	Wrapper for procedures that load RedEyeOpens data to relevant Facts

--Parameters	@LoadKey SMALLINT
--				LoadKey against which to log events
--			@StepKey TINYINT NULL	
--				StepKey against which to log events. If null, defaults to 'Email Events' StepKey.
							
--Date			Author				Reason
---------------------------------------------

--==================================================================================*/
--CREATE PROCEDURE PreLoad.uspLoadRedEyeOpensFacts
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
----	FactEmailEvent
--BEGIN TRY
--	EXEC PreLoad.uspLoadRedEyeOpensFactEmailEvent @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadRedEyeOpensFactEmailEvent';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

----	FactEmailEvent already existing Facts
--BEGIN TRY
--	EXEC PreLoad.uspLoadDuplicateFact PreLoad, FactEmailEvent, Production, FactEmailEvent, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadDuplicateFact FactEmailEvent';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

--/***************************
--	Load to Production
--****************************/
----	FactEmailEvent
--BEGIN TRY
--	EXEC PreLoad.uspLoadTable PreLoad, FactEmailEvent, Production, FactEmailEvent, 1, @LoadKey, @StepKey;
--END TRY
--BEGIN CATCH	
--	SELECT @ErrorMessage = LEFT(ERROR_MESSAGE(), 512), @Trace = N'PreLoad.uspLoadTable FactEmailEvent';	
--	EXEC Auxiliary.uspAddLoadError @LoadKey, @StepKey, @Container, @Trace, @ErrorMessage, @Detail;
--	THROW;
--END CATCH

