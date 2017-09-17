﻿CREATE TABLE [Production].[DimDate] (
    [DateKey]                          INT          NOT NULL,
    [TheDate]                          DATE         NOT NULL,
    [DateISO]                          VARCHAR (10) NULL,
    [DateText]                         VARCHAR (20) NULL,
    [DateAbbrev]                       VARCHAR (11) NULL,
    [DayOfWeekNumber]                  TINYINT      NULL,
    [DayOfWeekName]                    VARCHAR (9)  NULL,
    [DayOfWeekNameShort]               CHAR (3)     NULL,
    [FirstDateOfWeek]                  DATETIME     NULL,
    [LastDateOfWeek]                   DATETIME     NULL,
    [DayOfMonth]                       TINYINT      NULL,
    [DayOfMonthNumber]                 SMALLINT     NULL,
    [MonthName]                        VARCHAR (9)  NULL,
    [MonthNameWithYear]                VARCHAR (15) NULL,
    [MonthShortName]                   VARCHAR (3)  NULL,
    [MonthShortNameWithYear]           CHAR (8)     NULL,
    [DayOfMonthName]                   VARCHAR (16) NULL,
    [FirstDateOfMonth]                 DATETIME     NULL,
    [LastDateOfMonth]                  DATETIME     NULL,
    [CalendarWeekNumber]               TINYINT      NULL,
    [CalendarWeekName]                 VARCHAR (7)  NULL,
    [CalendarWeekNameWithYear]         VARCHAR (13) NULL,
    [CalendarWeekShortName]            CHAR (4)     NULL,
    [CalendarWeekShortNameWithYear]    CHAR (9)     NULL,
    [CalendarWeek_YY_WK]               CHAR (5)     NULL,
    [CalendarMonthNumber]              TINYINT      NULL,
    [CalendarMonth_YY_MM]              CHAR (5)     NULL,
    [CalendarYearMonth]                VARCHAR (8)  NULL,
    [CalendarYearMonth_YY_MMM]         CHAR (6)     NULL,
    [CalendarQuarterNumber]            TINYINT      NULL,
    [CalendarQuarterName]              CHAR (9)     NULL,
    [CalendarQuarterNameWithYear]      CHAR (15)    NULL,
    [CalendarQuarterShortName]         CHAR (2)     NULL,
    [CalendarQuarterShortNameWithYear] CHAR (7)     NULL,
    [CalendarQuarter_YY_QQ]            CHAR (5)     NULL,
    [CalendarYearQuarter]              VARCHAR (8)  NULL,
    [CalendarDayOfQuarter]             TINYINT      NULL,
    [CalendarDayOfQuarterName]         VARCHAR (16) NULL,
    [CalendarFirstDateOfQuarter]       DATETIME     NULL,
    [CalendarLastDateOfQuarter]        DATETIME     NULL,
    [CalendarHalfNumber]               TINYINT      NULL,
    [CalendarHalfName]                 CHAR (6)     NULL,
    [CalendarHalfNameWithYear]         CHAR (12)    NULL,
    [CalendarHalfShortName]            CHAR (2)     NULL,
    [CalendarHalfShortNameWithYear]    CHAR (7)     NULL,
    [CalendarDayOfHalf]                TINYINT      NULL,
    [CalendarDayOfHalfName]            VARCHAR (16) NULL,
    [CalendarFirstDateOfHalf]          DATETIME     NULL,
    [CalendarLastDateOfHalf]           DATETIME     NULL,
    [CalendarYearNumber]               SMALLINT     NULL,
    [CalendarYearName]                 CHAR (4)     NULL,
    [CalendarYearShortName]            CHAR (2)     NULL,
    [CalendarDayOfYear]                SMALLINT     NULL,
    [CalendarDayOfYearName]            VARCHAR (20) NULL,
    [CalendarFirstDateOfYear]          DATETIME     NULL,
    [CalendarLastDateOfYear]           DATETIME     NULL,
    [FiscalWeekNumber]                 TINYINT      NULL,
    [FiscalWeekName]                   VARCHAR (7)  NULL,
    [FiscalWeekNameWithYear]           VARCHAR (13) NULL,
    [FiscalWeekShortName]              CHAR (4)     NULL,
    [FiscalWeekShortNameWithYear]      CHAR (9)     NULL,
    [FiscalWeek_YY_WK]                 CHAR (5)     NULL,
    [FiscalMonthNumber]                TINYINT      NULL,
    [FiscalMonth_YY_MM]                CHAR (5)     NULL,
    [FiscalYearMonth]                  VARCHAR (8)  NULL,
    [FiscalYearMonth_YY_MMM]           CHAR (6)     NULL,
    [FiscalQuarterNumber]              TINYINT      NULL,
    [FiscalQuarterName]                CHAR (9)     NULL,
    [FiscalQuarterNameWithYear]        CHAR (15)    NULL,
    [FiscalQuarterShortName]           CHAR (2)     NULL,
    [FiscalQuarterShortNameWithYear]   CHAR (7)     NULL,
    [FiscalQuarter_YY_QQ]              CHAR (5)     NULL,
    [FiscalYearQuarter]                VARCHAR (8)  NULL,
    [FiscalDayOfQuarter]               TINYINT      NULL,
    [FiscalDayOfQuarterName]           VARCHAR (16) NULL,
    [FiscalFirstDateOfQuarter]         DATETIME     NULL,
    [FiscalLastDateOfQuarter]          DATETIME     NULL,
    [FiscalHalfNumber]                 TINYINT      NULL,
    [FiscalHalfName]                   CHAR (6)     NULL,
    [FiscalHalfNameWithYear]           CHAR (12)    NULL,
    [FiscalHalfShortName]              CHAR (2)     NULL,
    [FiscalHalfShortNameWithYear]      CHAR (7)     NULL,
    [FiscalDayOfHalf]                  TINYINT      NULL,
    [FiscalDayOfHalfName]              VARCHAR (16) NULL,
    [FiscalFirstDateOfHalf]            DATETIME     NULL,
    [FiscalLastDateOfHalf]             DATETIME     NULL,
    [FiscalYearNumber]                 SMALLINT     NULL,
    [FiscalYearName]                   CHAR (4)     NULL,
    [FiscalYearShortName]              CHAR (2)     NULL,
    [FiscalDayOfYear]                  SMALLINT     NULL,
    [FiscalDayOfYearName]              VARCHAR (20) NULL,
    [FiscalFirstDateOfYear]            DATETIME     NULL,
    [FiscalLastDateOfYear]             DATETIME     NULL,
    [WeekdayIndicator]                 VARCHAR (7)  NULL,
    [HolidayIndicator]                 VARCHAR (12) NULL,
    [MajorEvent]                       VARCHAR (50) NULL,
    [SeasonFull]                       CHAR (6)     NULL,
    [SeasonShort]                      CHAR (3)     NULL,
	[FiscalPeriodNumber]			   TINYINT		NULL,
	[FiscalPeriod_YY_PP]			   CHAR (5)		NULL,
	[FiscalYearPeriod]				   VARCHAR (8)	NULL,
	[FiscalYearPeriod_YY_PPP]		   CHAR (6)		NULL,
    CONSTRAINT [PK_Production_DimDate] PRIMARY KEY CLUSTERED ([DateKey] ASC) WITH (DATA_COMPRESSION = PAGE)
);

GO
/*	Haven't bothered to compress these regularly scanned indexes as they're pretty narrow anyway	*/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Production_DimDate_TheDate]
    ON [Production].[DimDate]([TheDate] ASC);

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Production_DimDate_DateKey_TheDate]
    ON [Production].[DimDate]([DateKey] ASC, [TheDate] ASC);

GO

