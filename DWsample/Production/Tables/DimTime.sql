CREATE TABLE [Production].[DimTime] (
    [TimeKey]           SMALLINT     NOT NULL,
    [TheTime]           AS           (CONVERT([time],[TimeString24])),
    [TimeString24]      CHAR (5)     NULL,
    [TimeString12]      CHAR (5)     NULL,
    [HourOfDay24]       TINYINT      NULL,
    [HourOfDay12]       TINYINT      NULL,
    [AmPm]              CHAR (2)     NULL,
    [MinuteOfHour]      TINYINT      NULL,
    [HalfOfHour]        TINYINT      NULL,
    [HalfHourOfDay]     TINYINT      NULL,
    [QuarterOfHour]     TINYINT      NULL,
    [QuarterHourOfDay]  TINYINT      NULL,
    [PeriodOfDay]       VARCHAR (10) NULL,
    [DateCreated]       DATETIME     DEFAULT (getdate()) NULL,
    [DateUpdated]       DATETIME     DEFAULT (getdate()) NULL,
    [RowIsCurrent]      CHAR (1)     DEFAULT ('Y') NULL,
    [RowStartDate]      DATETIME     DEFAULT (getdate()) NULL,
    [RowEndDate]        DATETIME     DEFAULT ('99991231') NULL,
    [InsertAuditKey]    INT          NOT NULL,
    [UpdateAuditKey]    INT          NOT NULL,
    CONSTRAINT [PK_Production_DimTime] PRIMARY KEY CLUSTERED ([TimeKey] ASC)
);

