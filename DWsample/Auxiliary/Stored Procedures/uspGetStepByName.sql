/*============================================================================
Description	Gets a Step record by Step.Name
			Throws error if @Name is not a valid Step.Name

Parameters	@Name
				Step.Name of the Step to retrieve	
			
Date			Author				Reason
-------------------------------------------
2017-09-26		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE PROCEDURE [Auxiliary].[uspGetStepByName]
	@Name NVARCHAR(50)
	
AS
SET NOCOUNT ON;

DECLARE 
	@ErrorMessage NVARCHAR(4000);

BEGIN TRY
		
	IF NOT EXISTS (SELECT 1 FROM Auxiliary.Step WHERE Name = @Name)
	BEGIN
    	SET @ErrorMessage = N'No Step with the name ' + CAST(@Name AS NVARCHAR);
		THROW 50000, @ErrorMessage, 1;
	END

	SELECT 
		StepKey
		,StageKey
		,Name
		,[Order]
	FROM Auxiliary.Step
	WHERE Name = @Name;
	
END TRY
BEGIN CATCH
	
	--	Rollback any open transactions
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

	--	Rethrow error if desired
	THROW;
END CATCH