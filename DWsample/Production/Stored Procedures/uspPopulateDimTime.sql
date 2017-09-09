
/*============================================================================
Name:		uspPopulateDimTime

Purpose:	Procedure to populate DimTime

Parameters:	@MorningStart	
				hour representing start of Morning period expressed as a tinyint
			@AfternoonStart	
				hour representing start of Afternoon period expressed as a tinyint
			@EveningStart	
				hour representing start of Evening period expressed as a tinyint
			@NightStart		
				hour representing start of Night period expressed as a tinyint

Notes:		TimeKey is in HHMM format so 0 = midnight 530 = 05:30 and 2359 = 23:59. 
			Unusually for a dimension a TimeKey of 0 has meaning!

Date			Author				Reason
-------------------------------------------
2017-09-09		Robert Wieczorek	Creation

==================================================================================*/ 

CREATE PROCEDURE Production.[uspPopulateDimTime]
				  @MorningStart TINYINT
				 ,@AfternoonStart TINYINT
				 ,@EveningStart TINYINT
				 ,@NightStart TINYINT
AS
SET XACT_ABORT ON;
BEGIN TRANSACTION
BEGIN TRY

DELETE FROM Production.DimTime WHERE TimeKey > -1

INSERT INTO Production.DimTime (TimeKey, TimeString24, TimeString12, HourOfDay24, HourOfDay12, AmPm, MinuteOfHour, HalfOfHour, HalfHourOfDay, QuarterOfHour, QuarterHourOfDay, PeriodOfDay, DateCreated, DateUpdated, RowIsCurrent, RowStartDate, RowEndDate, InsertAuditKey, UpdateAuditKey)
SELECT -1, '', '', NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, '', GETDATE(), GETDATE(), 'Y', GETDATE(), '99991231', -1, -1
WHERE NOT EXISTS (SELECT 1 FROM Production.DimTime WHERE [TimeKey] = -1)

--digits gives you a set of 10 numbers 0-9 
;WITH 
	 Digits (i) AS
	( 
        SELECT 1 AS i 
		UNION ALL SELECT 2 AS i 
		UNION ALL SELECT 3 
		UNION ALL SELECT 4 
		UNION ALL SELECT 5 
		UNION ALL SELECT 6 
		UNION ALL SELECT 7 
        UNION ALL SELECT 8 
        UNION ALL SELECT 9 
        UNION ALL SELECT 0
	) 
--sequence produces a set of integers from 0 - 9999 
	,SEQUENCE (i) AS 
	( 
        SELECT 
			D1.i + (10*D2.i) + (100*D3.i) + (1000*D4.i) 
        FROM 
			Digits D1 CROSS JOIN Digits D2 CROSS JOIN Digits D3 CROSS JOIN Digits D4
	) 

INSERT Production.DimTime
	(
		  TimeKey
		 ,TimeString24 
		 ,TimeString12 
		 ,HourOfDay24 
		 ,HourOfDay12 
		 ,AmPm
		 ,MinuteOfHour 
		 ,HalfOfHour 
		 ,HalfHourOfDay 
		 ,QuarterOfHour 
		 ,QuarterHourOfDay 
		 ,PeriodOfDay
		 ,InsertAuditKey
		 ,UpdateAuditKey
	 ) 

--calculates the different values for the time table 
	SELECT 
		 (DATEPART(hh, dateval) * 100) +  DATEPART(mi, dateval)  AS TimeKey 
		,RIGHT('0' + CAST(DATEPART(hh, dateval) AS VARCHAR(2)),2)+ ':' + RIGHT('0' + CAST(DATEPART(mi, dateval) AS VARCHAR(2)),2) AS TimeString24 
		,RIGHT('0' + CAST(DATEPART(hh, dateval) % 12 + CASE WHEN DATEPART(hh, dateval) % 12 = 0 THEN 12 ELSE 0 END AS VARCHAR(2)),2)+ ':' + RIGHT('0' + CAST(DATEPART(mi, dateval) AS VARCHAR(2)),2) AS TimeString12 
		,DATEPART(hh, dateval) AS HourOfDay24 
		,DATEPART(hh, dateval) % 12 + CASE WHEN DATEPART(hh, dateval) % 12 = 0 THEN 12 ELSE 0 END AS HourOfDay12 
		,CASE WHEN DATEPART(hh, dateval) BETWEEN 0 AND 11 THEN 'AM' ELSE 'PM' END AS AmPm 
		,DATEPART(mi, dateval)+1 AS MinuteOfHour 
		,((i/30) % 2) + 1  AS HalfOfHour --note, I made these next 4 values 1 based, not 0. So the first half hour is 1, the second is 2 
		,(i/30) + 1  AS HalfHourOfDay  --and for the whole day value, they go from 
		,((i/15) % 4) + 1     AS QuarterOfHour 
		,(i/15) + 1  AS QuarterHourOfDay 
		,CASE 
			WHEN DATEPART(hh, dateval) >= @MorningStart AND DATEPART(hh, dateval) < @AfternoonStart THEN 'Morning'
			WHEN DATEPART(hh, dateval) >= @AfternoonStart AND DATEPART(hh, dateval) < @EveningStart THEN 'Afternoon'
			WHEN DATEPART(hh, dateval) >= @EveningStart AND DATEPART(hh, dateval) < @NightStart THEN 'Evening'
			WHEN DATEPART(hh, dateval) >= @NightStart OR DATEPART(hh, dateval) < @MorningStart THEN 'Night'
		 END AS PeriodOfDay
		 ,-1
		 ,-1
	FROM 
		(
			SELECT 
				DATEADD(MINUTE,i,'20000101') AS dateVal, i 
			FROM 
				SEQUENCE 
			WHERE 
				i BETWEEN 0 AND 1439 --number of minutes in a day = 1440  
		) DailyMinutes 


	IF XACT_STATE() = 1
	BEGIN
		COMMIT TRANSACTION;
	END;
END TRY
BEGIN CATCH
	DECLARE 
		@ErrorMessage VARCHAR(4000),
		@ErrorNumber INT,
		@ErrorSeverity INT,
		@ErrorState INT,
		@ErrorLine INT,
		@ErrorProcedure VARCHAR(126);

	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorProcedure = ISNULL(ERROR_PROCEDURE(), 'N/A');

	--Build the error message string
	SELECT @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' +
						   'Message: ' + ERROR_MESSAGE()      
	--Place cleanup and logging code
	IF XACT_STATE() = -1
	BEGIN
		ROLLBACK TRANSACTION;
	END;

	--Rethrow the error
	RAISERROR                                    
	(
		@ErrorMessage,
		@ErrorSeverity,
		1,
		@ErrorNumber,
		@ErrorSeverity,
		@ErrorState,
		@ErrorProcedure,
		@ErrorLine
	);    
END CATCH