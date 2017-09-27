/***********************************************************************************
Procedure	Auxiliary.uspSetDateTimeKeysByFeedBatchKey
Author		Robert Wieczorek
Created		2017-09-27

Purpose		Sets date and time key columns from the date and time tables
			NB. A datetime column that will be converted to both date key and time key needs to be submitted once wil @isDate and again with @isTime set

Parameters	@Schema
				The Schema holding the object that is subject to decode. Name quotes will be stripped and reapplied.
			@Table 
				The Table name holding the column to be derived. Name quotes will be stripped and reapplied. 
			@DateTimeColumn 
				The column containing date/time/datetime values. Name quotes will be stripped and reapplied. 
			@KeyColumn 
				The column into which the derived date/time key will go. Name quotes will be stripped and reapplied. 
			@isTime BIT
				If 1, a lookup against DimTime is used instead of DimDate.
			@FeedBatchKey INT
				The FeedBatchKey for which to run the datekeys set. 
				If null, will set datekeys indiscriminately
			@StepKey TINYINT
				The StepKey for logging purposes.
				If NULL will be set to 'Dependent Decodes'
Modified
**********************************************************************************/ 
CREATE PROCEDURE Auxiliary.uspSetDateTimeKeysByFeedBatchKey
	@Schema SYSNAME
	,@Table SYSNAME
	,@DateTimeColumn SYSNAME
	,@KeyColumn SYSNAME	
	,@isTime BIT = 0
	,@FeedBatchKey INT = NULL
	,@StepKey TINYINT = NULL
AS

SET NOCOUNT ON; 
SET DATEFORMAT dmy;

DECLARE 
	@SQL NVARCHAR(MAX) = N''		
	,@Trace NVARCHAR(1000)
	,@Detail NVARCHAR(1000)	
	,@ErrorMessage NVARCHAR(512)	
	,@TableName NVARCHAR(261) 	
	,@ColumnName NVARCHAR(130)
	,@Container NVARCHAR(300) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)	 	
	,@FieldValue NVARCHAR(100) 
	,@DecodeValue NVARCHAR(100)
	,@FeedBatchLogKey INT
	,@RowsAffected INT;

SELECT 
	@Schema = Auxiliary.fnQuoteNameStripSquareBrackets(@Schema)
	,@Table = Auxiliary.fnQuoteNameStripSquareBrackets(@Table)
	,@KeyColumn = Auxiliary.fnQuoteNameStripSquareBrackets(@KeyColumn)
	,@DateTimeColumn = Auxiliary.fnQuoteNameStripSquareBrackets(@DateTimeColumn);

SELECT @StepKey = StepKey 
FROM Auxiliary.Step 
WHERE 
	StepKey = @StepKey
	OR (@StepKey IS NULL 
		AND Name = N'Dependent Decodes');

IF @StepKey IS NULL
BEGIN	
	SET @ErrorMessage = N'StepKey ' + COALESCE(CAST(@StepKey AS NVARCHAR(10)), N'') + N' not found';
	THROW 50000, @ErrorMessage, 1;
END  	

SET @SQL = NULL;

IF @isTime = 0
BEGIN
	SET @SQL = '		
	SET DATEFORMAT dmy	
	UPDATE ' + @Table + '
	SET ' + @KeyColumn + ' = COALESCE(DimDate.DateKey, -1)
	FROM 
		' + @Schema + N'.' + @Table + '
		LEFT JOIN Production.DimDate
			ON TRY_CONVERT(DATE, REPLACE(REPLACE(' + @Table + '.' + @DateTimeColumn + ', ''-'', ''''), ''T'', '' '')) = DimDate.TheDate
	WHERE 
		' + @KeyColumn + ' IS NULL'
END
ELSE IF @isTime = 1
BEGIN
	SET @SQL = '			
	UPDATE ' + @Table + '
	SET ' + @KeyColumn + ' = COALESCE(DimTime.TimeKey, -1)
	FROM 
		' + @Schema + N'.' + @Table + '
		LEFT JOIN Production.DimTime
			ON CAST(LEFT(TRY_CONVERT(TIME, REPLACE(REPLACE(' + @Table + '.' + @DateTimeColumn + ', ''-'', ''''), ''T'', '' '')), 5) AS TIME) = DimTime.TheTime
	WHERE 
		' + @KeyColumn + ' IS NULL'
END

IF @FeedBatchKey IS NOT NULL
	SET @SQL += NCHAR(13) + NCHAR(9) + NCHAR(9) + N'AND ' + @Table + '.FeedFileKey = ' + CAST(@FeedBatchKey AS NVARCHAR(10));

SET @SQL += N';';

BEGIN TRY
BEGIN TRANSACTION			
		
	IF @FeedBatchKey IS NOT NULL
	BEGIN
		
		SELECT 
			@Trace = N'' + @Schema + N'.' + @Table + N'.' + @DateTimeColumn
			,@Detail = @KeyColumn;

		EXEC Auxiliary.uspAddFeedBatchLog @FeedBatchKey = @FeedBatchKey, @StepKey = @StepKey, @Container = @Container, @Trace = @Trace, @Detail = @Detail, @FeedBatchLogKey = @FeedBatchLogKey OUTPUT;
	END
	PRINT @SQL;
	EXEC sys.sp_executesql @SQL;

	SET @RowsAffected = @@ROWCOUNT;
	IF @FeedBatchKey IS NOT NULL	
		EXEC Auxiliary.uspUpdateFeedBatchLog @FeedBatchLogKey = @FeedBatchLogKey, @RowsAffected = @RowsAffected;
	

	IF XACT_STATE()	= 1
	BEGIN    
		COMMIT TRANSACTION;									
	END
    ELSE
	BEGIN	
		SET @ErrorMessage = @Trace + N': Uncommitable transaction';
		THROW 50000, @ErrorMessage, 1;
	END   
END TRY  
BEGIN CATCH
	
	SET @ErrorMessage = ERROR_MESSAGE();

	--	Rollback any open transactions
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		
	--	Log error
	IF @FeedBatchKey IS NOT NULL
		EXEC Auxiliary.uspAddFeedBatchError	@FeedBatchKey, @StepKey, @Container, @Trace, @ErrorMessage;

	--	Rethrow error if desired
	THROW;
END CATCH