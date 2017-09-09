
/*============================================================================
Description	Procedure to populate DimDate

Parameters	

Date			Author				Reason
-------------------------------------------
2017-09-09		Robert Wieczorek	Creation

==================================================================================*/ 

CREATE PROCEDURE Production.[uspPopulateDimDate]  (
      @StartDate DATETIME
    , @EndDate DATETIME
    --, @IncludeFiscal bit = 0
	, @RetainExistingDates bit = 0
      
)
AS BEGIN

SET NOCOUNT ON
SET DATEFIRST 1 -- Forces first day of week to be Monday, just in case user's language is US English.

INSERT INTO Production.DimDate (DateKey, TheDate, DateISO, DateText, DateAbbrev, DayOfWeekNumber, DayOfWeekName, DayOfWeekNameShort, FirstDateOfWeek, LastDateOfWeek, DayOfMonth, DayOfMonthNumber, MonthName, MonthNameWithYear, MonthShortName, MonthShortNameWithYear, DayOfMonthName, FirstDateOfMonth, LastDateOfMonth, CalendarWeekNumber, CalendarWeekName, CalendarWeekNameWithYear, CalendarWeekShortName, CalendarWeekShortNameWithYear, CalendarWeek_YY_WK, CalendarMonthNumber, CalendarMonth_YY_MM, CalendarYearMonth, CalendarYearMonth_YY_MMM, CalendarQuarterNumber, CalendarQuarterName, CalendarQuarterNameWithYear, CalendarQuarterShortName, CalendarQuarterShortNameWithYear, CalendarQuarter_YY_QQ, CalendarYearQuarter, CalendarDayOfQuarter, CalendarDayOfQuarterName, CalendarFirstDateOfQuarter, CalendarLastDateOfQuarter, CalendarHalfNumber, CalendarHalfName, CalendarHalfNameWithYear, CalendarHalfShortName, CalendarHalfShortNameWithYear, CalendarDayOfHalf, CalendarDayOfHalfName, CalendarFirstDateOfHalf, CalendarLastDateOfHalf, CalendarYearNumber, CalendarYearName, CalendarYearShortName, CalendarDayOfYear, CalendarDayOfYearName, CalendarFirstDateOfYear, CalendarLastDateOfYear, FiscalWeekNumber, FiscalWeekName, FiscalWeekNameWithYear, FiscalWeekShortName, FiscalWeekShortNameWithYear, FiscalWeek_YY_WK, FiscalMonthNumber, FiscalMonth_YY_MM, FiscalYearMonth, FiscalYearMonth_YY_MMM, FiscalQuarterNumber, FiscalQuarterName, FiscalQuarterNameWithYear, FiscalQuarterShortName, FiscalQuarterShortNameWithYear, FiscalQuarter_YY_QQ, FiscalYearQuarter, FiscalDayOfQuarter, FiscalDayOfQuarterName, FiscalFirstDateOfQuarter, FiscalLastDateOfQuarter, FiscalHalfNumber, FiscalHalfName, FiscalHalfNameWithYear, FiscalHalfShortName, FiscalHalfShortNameWithYear, FiscalDayOfHalf, FiscalDayOfHalfName, FiscalFirstDateOfHalf, FiscalLastDateOfHalf, FiscalYearNumber, FiscalYearName, FiscalYearShortName, FiscalDayOfYear, FiscalDayOfYearName, FiscalFirstDateOfYear, FiscalLastDateOfYear, WeekdayIndicator, HolidayIndicator, MajorEvent, SeasonFull, SeasonShort)
SELECT -1, '', '', 'Date not supplied', '', NULL, '', '', '', '', NULL, NULL, '', '', '', '', '', '', '', NULL, '', '', '', '', '', NULL, '', '', '', NULL, '', '', '', '', '', '', NULL, '', '', '', NULL, '', '', '', '', NULL, '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', '', '', '', '', NULL, '', '', '', NULL, '', '', '', '', '', '', NULL, '', '', '', NULL, '', '', '', '', NULL, '', '', '', NULL, '', '', NULL, '', '', '', '', '', '', '', ''
WHERE NOT EXISTS (SELECT 1 FROM Production.DimDate WHERE [DateKey] = -1)

--Create temp table with dates
CREATE TABLE #dates (datevalue datetime)

DECLARE @Date datetime
set @date = @StartDate
WHILE DATEDIFF(day, @Date, @EndDate) >= 0
BEGIN
	INSERT INTO #dates (datevalue) VALUES (@Date)
	SET @Date = DATEADD(day, 1, @Date)
END
 
--Ensure all the dates exist in DimDate
PRINT 'Checking all dates exist in DimDate between:'

INSERT INTO Production.DimDate (TheDate, dateKey)
SELECT datevalue, CONVERT(CHAR(8), datevalue, 112) FROM #dates d
WHERE NOT EXISTS (SELECT * FROM DimDate dd where dd.TheDate=d.datevalue)

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' new dates added'

--Remove dates in DimDate outside specifed date range
DELETE FROM Production.DimDate
WHERE NOT EXISTS (SELECT * FROM #dates d where Production.DimDate.TheDate=d.datevalue)
AND DateKey <> -1
AND @RetainExistingDates = 0

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' dates removed'

--Now Update Date Column Values
UPDATE Production.DimDate SET DateKey = CONVERT(CHAR(8), TheDate, 112) WHERE ISNULL(DateKey,0) <> -1 
UPDATE Production.DimDate SET DateISO = CONVERT(CHAR(10), TheDate, 126)
UPDATE Production.DimDate SET DateText = LEFT(CONVERT(CHAR(20), TheDate, 113),3) + DATENAME(month, TheDate) + ' ' + DATENAME(YY, TheDate)
UPDATE Production.DimDate SET DateAbbrev = CONVERT(CHAR(11), TheDate, 113)

--Calendar Columns
UPDATE Production.DimDate SET CalendarYearNumber = DATEPART(yy, TheDate)
UPDATE Production.DimDate SET CalendarYearName = RIGHT('0000' + CAST(CalendarYearNumber AS NVARCHAR(4)), 4)
UPDATE Production.DimDate SET CalendarYearShortName = RIGHT('0000' + CAST(CalendarYearNumber AS NVARCHAR(4)), 2)
UPDATE Production.DimDate SET CalendarFirstDateOfYear = CONVERT(DATETIME,CalendarYearName + '-01-01',120)
UPDATE Production.DimDate SET CalendarLastDateOfYear = CONVERT(DATETIME,CalendarYearName + '-12-31',120)
UPDATE Production.DimDate SET CalendarDayOfYear = DATEPART(dy, TheDate)
UPDATE Production.DimDate SET CalendarQuarterNumber = DATEPART(q, TheDate)
UPDATE Production.DimDate SET CalendarQuarterName = 'Quarter ' + CAST(CalendarQuarterNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarQuarterNameWithYear = CalendarQuarterName + ', ' + CalendarYearName
UPDATE Production.DimDate SET CalendarQuarterShortName = 'Q' + CAST(CalendarQuarterNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarQuarterShortNameWithYear = CalendarQuarterShortName + ' ' + CalendarYearName
UPDATE Production.DimDate SET CalendarYearQuarter = 'C' + CalendarYearName + '-'
                + RIGHT('00' + CAST(CalendarQuarterNumber AS NVARCHAR(2)), 2)
UPDATE Production.DimDate SET CalendarFirstDateOfQuarter = CASE CalendarQuarterNumber
                                                WHEN 1 THEN CONVERT(DATETIME,CalendarYearName + '-01-01',120)
                                                WHEN 2 THEN CONVERT(DATETIME,CalendarYearName + '-04-01',120)
                                                WHEN 3 THEN CONVERT(DATETIME,CalendarYearName + '-07-01',120)
                                                WHEN 4 THEN CONVERT(DATETIME,CalendarYearName + '-10-01',120)
                                              END
UPDATE Production.DimDate SET CalendarLastDateOfQuarter = DATEADD(day, -1, DATEADD(q, 1, CalendarFirstDateOfQuarter))
UPDATE Production.DimDate SET CalendarDayOfQuarter = DATEDIFF(day, CalendarFirstDateOfQuarter, TheDate) + 1
UPDATE Production.DimDate SET CalendarDayOfQuarterName = 'Day '
                + CAST(DATEDIFF(day, CalendarFirstDateOfQuarter, TheDate) + 1 AS NVARCHAR(2))
                + ' of Q' + CAST(CalendarQuarterNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarHalfNumber = CASE WHEN DATEPART(q, TheDate) <= 2 THEN 1 ELSE 2 END
UPDATE Production.DimDate SET CalendarHalfName = 'Half ' + CAST(CalendarHalfNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarHalfShortName = 'H' + CAST(CalendarHalfNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarHalfNameWithYear = CalendarHalfName + ', ' + CalendarYearName
UPDATE Production.DimDate SET CalendarHalfShortNameWithYear = CalendarHalfShortName + ' ' + CalendarYearName
UPDATE Production.DimDate SET CalendarFirstDateOfHalf = CASE CalendarHalfNumber
                                             WHEN 1 THEN CONVERT(DATETIME,CalendarYearName + '-01-01',120)
                                             WHEN 2 THEN CONVERT(DATETIME,CalendarYearName + '-07-01',120)
                                           END
UPDATE Production.DimDate SET CalendarLastDateOfHalf = CASE CalendarHalfNumber
                                            WHEN 1 THEN CONVERT(DATETIME,CalendarYearName+ '-06-30',120)
                                            WHEN 2 THEN CONVERT(DATETIME,CalendarYearName + '-12-31',120)
                                          END                
UPDATE Production.DimDate SET CalendarDayOfHalf = DATEDIFF(day, CalendarFirstDateOfHalf, TheDate) + 1
UPDATE Production.DimDate SET CalendarDayOfHalfName = 'Day '
                + CAST(DATEDIFF(day, CalendarFirstDateOfHalf, TheDate) + 1 AS NVARCHAR(3))
                + ' of H' + CAST(CalendarHalfNumber AS CHAR(1))
UPDATE Production.DimDate SET CalendarMonthNumber = LEFT(DATEPART(m, TheDate),3)
UPDATE Production.DimDate SET CalendarYearMonth = 'C' + CalendarYearName + '-' + RIGHT('00' + CAST(CalendarMonthNumber AS NVARCHAR(2)), 2)


--Month dimensions
UPDATE Production.DimDate SET [MonthName] = DATENAME(mm, TheDate)
UPDATE Production.DimDate SET MonthNameWithYear = MonthName + ', ' + CalendarYearName
UPDATE Production.DimDate SET MonthShortName = LEFT(DATENAME(m, TheDate),3)
UPDATE Production.DimDate SET MonthShortNameWithYear = MonthShortName + ' ' + CalendarYearName
UPDATE Production.DimDate SET FirstDateOfMonth = CONVERT(DATETIME,CalendarYearName + '-'+ MonthShortName + '-01',120)
UPDATE Production.DimDate SET LastDateOfMonth = DATEADD(day, -1,DATEADD(m, 1, FirstDateOfMonth))
UPDATE Production.DimDate SET [DayOfMonth] = DATEPART(d, TheDate)
UPDATE Production.DimDate SET DayOfMonthName = DATENAME(m, TheDate) + ' '
                + CAST(DATEPART(d, TheDate) AS NVARCHAR(2))
                + CASE LEFT(RIGHT('00' + CAST(DATEPART(d, TheDate) AS NVARCHAR(2)), 2), 1)
                    WHEN '1' THEN 'th'
                    ELSE CASE RIGHT(RIGHT('00' + CAST(DATEPART(d, TheDate) AS NVARCHAR(2)), 2), 1)
                           WHEN '1' THEN 'st'
                           WHEN '2' THEN 'nd'
                           WHEN '3' THEN 'rd'
                           ELSE 'th'
                         END
                  END


UPDATE Production.DimDate SET CalendarDayOfYearName = DayOfMonthName + ', ' + CalendarYearName

--Week Dimensions
UPDATE Production.DimDate SET CalendarWeekNumber = DATEPART(isowk, TheDate)
UPDATE Production.DimDate SET CalendarWeekName = 'Week ' + CAST(CalendarWeekNumber as varchar(2))
UPDATE Production.DimDate SET CalendarWeekNameWithYear = 
	CalendarWeekName + ', ' + 
	case when calendarmonthnumber=1 and CalendarWeekNumber>50
		  then cast(CalendarYearNumber-1 as varchar(5)) 
		 when calendarmonthnumber=12 and CalendarWeekNumber=1 
		  then cast(CalendarYearNumber+1 as varchar(5)) 
		 else CalendarYearName end
UPDATE Production.DimDate SET CalendarWeekShortName = 'WK' + RIGHT('00' + CalendarWeekName,2)
UPDATE Production.DimDate SET CalendarWeekShortNameWithYear = CalendarWeekShortName + ' ' 
	+ 	case when calendarmonthnumber=1 and CalendarWeekNumber>50
		  then cast(CalendarYearNumber-1 as varchar(5)) 
		 when calendarmonthnumber=12 and CalendarWeekNumber=1 
		  then cast(CalendarYearNumber+1 as varchar(5)) 
		 else CalendarYearName end

UPDATE Production.DimDate SET FirstDateOfWeek = DATEADD(day, ( DATEPART(dw, TheDate) - 1 ) * -1, TheDate)
UPDATE Production.DimDate SET LastDateOfWeek = DATEADD(day, -1, DATEADD(wk, 1, FirstDateOfWeek))
UPDATE Production.DimDate SET DayOfWeekNumber = DATEPART(dw, TheDate)
UPDATE Production.DimDate SET DayOfWeekName = DATENAME(dw, TheDate)
UPDATE Production.DimDate SET WeekdayIndicator = CASE WHEN DATEPART(dw, TheDate) IN (6,7) THEN 'Weekend'
                                       ELSE 'Weekday'
                                      END -- Note, SET DATEFIRST must be 1 (Monday)
UPDATE Production.DimDate SET HolidayIndicator = 'Non-Holiday'
UPDATE Production.DimDate SET MajorEvent = 'None'

--20100115 New Columns Added By Colin Thomas
UPDATE Production.DimDate SET DayOfWeekNameShort = LEFT(DayOfWeekName,3)
UPDATE Production.DimDate SET DayOfMonthNumber=Calendarmonthnumber*100+DayOfMonth

--Additional calendar columns
UPDATE Production.DimDate SET CalendarWeek_YY_WK=RIGHT(CalendarWeekNameWithYear,2)+'-'+
						 ISNULL(REPLICATE('0', 2 - LEN(ISNULL(CAST(calendarWeekNumber as varchar(2)) ,0))), '') + CAST(calendarWeekNumber as varchar(2))
UPDATE Production.DimDate SET CalendarMonth_YY_MM=RIGHT(YEAR([TheDate]),2)+'-'+
						 ISNULL(REPLICATE('0', 2 - len(ISNULL(CAST(calendarMonthNumber as varchar(2)) ,0))), '') + CAST(calendarMonthNumber as varchar(2))
UPDATE Production.DimDate SET CalendarQuarter_YY_QQ=RIGHT(YEAR([TheDate]),2) + '-Q' + CAST(calendarQuarterNumber as char(1))
UPDATE Production.DimDate SET CalendarYearMonth_YY_MMM=RIGHT(YEAR([TheDate]),2) + '-' + monthshortname


--Populate Seasons
UPDATE Production.DimDate SET
	  SeasonFull = case 
					when DayOfMonthNumber < 0321 then 'Winter'
					when DayOfMonthNumber between 321 and 620 then 'Spring'
					when DayOfMonthNumber between 621 and 920 then 'Summer'
					when DayOfMonthNumber between 921 and 1220 then 'Autumn'
					when DayOfMonthNumber > 1220 then 'Winter' end
UPDATE Production.DimDate SET
	  SeasonShort = case 
					when DayOfMonthNumber < 0321 then 'Win'
					when DayOfMonthNumber between 321 and 620 then 'Spr'
					when DayOfMonthNumber between 621 and 920 then 'Sum'
					when DayOfMonthNumber between 921 and 1220 then 'Aut'
					when DayOfMonthNumber > 1220 then 'Win' end
END


-- *****************************************************************
-- Fiscal Dates: run with param @IncludeFiscal=1
-- *****************************************************************
--IF @IncludeFiscal=1
--BEGIN
--    PRINT 'Updating Fiscal dates...'
	
--	--20160726 Changes for EMT: fiscal dates based on source table [EMT Fiscal Periods]

--	UPDATE Production.DimDate
--	SET FiscalYearNumber = NULL, 
--	FiscalYearName = NULL, 
--	FiscalYearShortName = NULL, 
--	FiscalFirstDateOfYear = NULL, 
--	FiscalLastDateOfYear = NULL, 
--	FiscalDayOfYear = NULL, 
--	FiscalQuarterNumber = NULL, 
--	FiscalQuarterName = NULL, 
--	FiscalQuarterNameWithYear = NULL, 
--	FiscalQuarterShortName = NULL, 
--	FiscalQuarterShortNameWithYear = NULL, 
--	FiscalYearQuarter = NULL, 
--	FiscalFirstDateOfQuarter = NULL, 
--	FiscalLastDateOfQuarter = NULL, 
--	FiscalDayOfQuarter = NULL, 
--	FiscalDayOfQuarterName = NULL, 
--	FiscalHalfNumber = NULL, 
--	FiscalHalfName = NULL, 
--	FiscalHalfShortName = NULL, 
--	FiscalHalfNameWithYear = NULL, 
--	FiscalHalfShortNameWithYear = NULL, 
--	FiscalFirstDateOfHalf = NULL, 
--	FiscalLastDateOfHalf = NULL, 
--	FiscalDayOfHalf = NULL, 
--	FiscalDayOfHalfName = NULL, 
--	FiscalMonthNumber = NULL, 
--	FiscalYearMonth = NULL, 
--	FiscalWeekNumber = NULL, 
--	FiscalWeekName = NULL, 
--	FiscalWeekNameWithYear = NULL, 
--	FiscalWeekShortName = NULL, 
--	FiscalWeekShortNameWithYear = NULL, 
--	FiscalPeriodNumber = NULL, 
--	FiscalYearPeriod = NULL, 
--	FiscalWeek_YY_WK = NULL, 
--	FiscalMonth_YY_MM = NULL, 
--	FiscalQuarter_YY_QQ = NULL, 
--	FiscalYearMonth_YY_MMM = NULL, 
--	FiscalPeriod_YY_PP = NULL, 
--	FiscalYearPeriod_YY_PPP = NULL
--	WHERE TheDate >= ISNULL(@StartDate, '01/01/0001') 
--	AND TheDate <= ISNULL(@EndDate, '31/12/9999')

	/*	Easy fix to avoid conversion errors as the reference data has been generated as dd/mm/yyyy*/
	--SET DATEFORMAT dmy;

	--SELECT 
	--	[Year] AS Year#, 
	--	(((CONVERT(INT, SUBSTRING(Period, 2, 2))-1) / 3)+1)
	--	- (CONVERT(INT, SUBSTRING(Period, 2, 2))-1) / 12 AS Quarter#,
	--	SUBSTRING(Period, 2, 2) AS Period#, 
	--	SUBSTRING([Week], 2, 2) AS Week#, 
	--	DayOfWeek, 
	--	CAST(DateSK AS DATE) AS DateSK
	--INTO #EMTFiscalCalendar
	--FROM 
	--	(SELECT 
	--		Year, Period, Week,
	--		Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
	--	FROM Reference.EMTFiscalPeriod) p
	--UNPIVOT
	--	(DateSK FOR DayOfWeek IN (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday)
	--) AS daysOfWeek;

	--SET DATEFORMAT ymd;

	--UPDATE d SET FiscalYearNumber = p.Year#
	--FROM Production.DimDate d
	--INNER JOIN #EMTFiscalCalendar p ON p.DateSK = d.TheDate

	--UPDATE Production.DimDate SET FiscalYearName = RIGHT('0000' + CAST(FiscalYearNumber AS NVARCHAR(4)), 4)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalYearShortName = RIGHT('0000' + CAST(FiscalYearNumber AS NVARCHAR(4)), 2)
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE d 
	--SET FiscalFirstDateOfYear = dd.FiscalFirstDateOfYear
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber ORDER BY TheDate) AS FiscalFirstDateOfYear  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate

	--UPDATE d 
	--SET FiscalLastDateOfYear = dd.FiscalLastDateOfYear
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber ORDER BY TheDate DESC) AS FiscalLastDateOfYear  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate
	
	--UPDATE Production.DimDate SET FiscalDayOfYear = DATEDIFF(day, FiscalFirstDateOfYear, TheDate) + 1
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE d SET FiscalQuarterNumber = p.Quarter#
	--FROM Production.DimDate d
	--INNER JOIN #EMTFiscalCalendar p ON p.DateSK = d.TheDate

	--UPDATE Production.DimDate SET FiscalQuarterName = 'Quarter ' + CAST(FiscalQuarterNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalQuarterNameWithYear = FiscalQuarterName + ', ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalQuarterShortName = 'Q' + CAST(FiscalQuarterNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalQuarterShortNameWithYear = FiscalQuarterShortName + ' ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalYearQuarter = 'F' + FiscalYearName + '-' + RIGHT('00' + CAST(FiscalQuarterNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE d 
	--SET FiscalFirstDateOfQuarter = dd.FiscalFirstDateOfQuarter
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber, FiscalQuarterNumber ORDER BY TheDate) AS FiscalFirstDateOfQuarter  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate

	--UPDATE d 
	--SET FiscalLastDateOfQuarter = dd.FiscalLastDateOfQuarter
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber, FiscalQuarterNumber ORDER BY TheDate DESC) AS FiscalLastDateOfQuarter  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate

	--UPDATE Production.DimDate SET FiscalDayOfQuarter = DATEDIFF(day, FiscalFirstDateOfQuarter, TheDate) + 1
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE Production.DimDate SET FiscalDayOfQuarterName = 'Day '
	--				+ CAST(DATEDIFF(day, FiscalFirstDateOfQuarter, TheDate) + 1 AS NVARCHAR(3)) --quarter can be > 100 for 53 week years
	--				+ ' of Q' + CAST(FiscalQuarterNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE Production.DimDate SET FiscalHalfNumber = CASE WHEN FiscalQuarterNumber <= 2 THEN 1 ELSE 2 END
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalHalfName = 'Half ' + CAST(FiscalHalfNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalHalfShortName = 'H' + CAST(FiscalHalfNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalHalfNameWithYear = FiscalHalfName + ', ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalHalfShortNameWithYear = FiscalHalfShortName + ' ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE d 
	--SET FiscalFirstDateOfHalf = dd.FiscalFirstDateOfHalf
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber, FiscalHalfNumber ORDER BY TheDate) AS FiscalFirstDateOfHalf  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate

	--UPDATE d 
	--SET FiscalLastDateOfHalf = dd.FiscalLastDateOfHalf
	--FROM Production.DimDate d
	--INNER JOIN (
	--	SELECT TheDate, FIRST_VALUE(TheDate) OVER(PARTITION BY FiscalYearNumber, FiscalHalfNumber ORDER BY TheDate DESC) AS FiscalLastDateOfHalf  
	--	FROM Production.DimDate
	--) dd ON dd.TheDate = d.TheDate

	--UPDATE Production.DimDate SET FiscalDayOfHalf = DATEDIFF(day, FiscalFirstDateOfHalf, TheDate)   + 1
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalDayOfHalfName = 'Day '
	--				+ CAST(DATEDIFF(day, FiscalFirstDateOfHalf, TheDate) + 1 AS NVARCHAR(3))
	--				+ ' of H' + CAST(FiscalHalfNumber AS CHAR(1))
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalMonthNumber = DATEDIFF(m, FiscalFirstDateOfYear, TheDate) + 1
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalYearMonth = 'F' + FiscalYearName + '-' + RIGHT('00' + CAST(FiscalMonthNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE d SET FiscalWeekNumber = p.Week#
	--FROM Production.DimDate d
	--INNER JOIN #EMTFiscalCalendar p ON p.DateSK = d.TheDate

	--UPDATE Production.DimDate SET FiscalWeekName = 'Week ' + CAST(DATEDIFF(wk, FiscalFirstDateOfYear, TheDate) + 1 AS NVARCHAR)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalWeekNameWithYear = FiscalWeekName + ', ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalWeekShortName = 'WK' + RIGHT('00' + CAST(DATEDIFF(wk, FiscalFirstDateOfYear, TheDate) + 1 AS NVARCHAR), 2)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalWeekShortNameWithYear = FiscalWeekShortName + ' ' + FiscalYearName
	--WHERE FiscalYearNumber IS NOT NULL
    	
	
	--UPDATE d SET FiscalPeriodNumber = p.Period#
	--FROM Production.DimDate d
	--INNER JOIN #EMTFiscalCalendar p ON p.DateSK = d.TheDate
	
	--UPDATE Production.DimDate SET FiscalYearPeriod = 'F' + FiscalYearName + '-' + RIGHT('00' + CAST(FiscalPeriodNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL
    
	----Additional fiscal columns 
	--UPDATE Production.DimDate SET FiscalWeek_YY_WK = RIGHT(FiscalYearName,2) + '-' + RIGHT('00' + CAST(FiscalWeekNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalMonth_YY_MM = RIGHT(FiscalYearName,2) + '-' + RIGHT('00' + CAST(FiscalMonthNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE Production.DimDate SET FiscalQuarter_YY_QQ = RIGHT(FiscalYearName,2) + '-Q' + RIGHT('00' + CAST(FiscalQuarterNumber AS NVARCHAR(1)), 1)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalYearMonth_YY_MMM = RIGHT(FiscalYearName,2) + '-' + 'M' + RIGHT('00' + CAST(FiscalMonthNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL

	--UPDATE Production.DimDate SET FiscalPeriod_YY_PP = RIGHT(FiscalYearName,2) + '-' + RIGHT('00' + CAST(FiscalPeriodNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL
	--UPDATE Production.DimDate SET FiscalYearPeriod_YY_PPP = RIGHT(FiscalYearName,2) + '-' + 'P' + RIGHT('00' + CAST(FiscalPeriodNumber AS NVARCHAR(2)), 2)
	--WHERE FiscalYearNumber IS NOT NULL


	--DROP TABLE #EMTFiscalCalendar

	--PRINT 'Completed: Updating Fiscal dates.'


--END -- END @IncludeFiscal=1