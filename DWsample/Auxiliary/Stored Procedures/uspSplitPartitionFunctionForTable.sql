
/*============================================================================
Description	Dynamically split partition function for a table

Parameters	@Schema SYSNAME	
				Schema name of the partitioned table
			@Table SYSNAME	
				Name of the partitioned table
			@NewBoundary
				Value on which to split the function
			@NextUsedFilegroup
				Filegroup to name as the next used filegroup after split

Date			Author				Reason
-------------------------------------------
2017-09-26		Robert Wieczorek	Creation 
==================================================================================*/ 
CREATE PROCEDURE Auxiliary.[uspSplitPartitionFunctionForTable]
															@Schema SYSNAME
															,@Table SYSNAME
															,@NewBoundary BIGINT
															,@NextUsedFilegroup SYSNAME = N'Secondary'
AS
DECLARE 
	@PartitionFunction SYSNAME
	,@PartitionScheme SYSNAME
	,@SQL NVARCHAR(MAX);

BEGIN TRY 

	SELECT DISTINCT 
		@PartitionFunction = Auxiliary.fnQuoteNameStripSquareBrackets(partition_function)
		,@PartitionScheme = Auxiliary.fnQuoteNameStripSquareBrackets(partition_scheme)
		,@NextUsedFilegroup = Auxiliary.fnQuoteNameStripSquareBrackets(@NextUsedFilegroup)
	FROM Auxiliary.PartitionsOnClusteredIndexes WITH (NOLOCK)
	WHERE 
		object_schema = @Schema
		AND [object_name] = @Table;

	SET @SQL = N'ALTER PARTITION FUNCTION ' + @PartitionFunction + N'() SPLIT RANGE(' + CAST(@NewBoundary AS NVARCHAR(MAX)) + N');';	
	EXEC sys.sp_executesql @SQL;
	
	SET @SQL = N'ALTER PARTITION SCHEME ' + @PartitionScheme + N' NEXT USED ' + @NextUsedFilegroup + N';';	
	EXEC sys.sp_executesql @SQL;
		
END TRY
BEGIN CATCH
	
	--	Special treatment (basically ignore) for the duplicate range error so we can deliberately call this on every table just to make sure they've all got an empty range	
	IF ERROR_NUMBER() = 7721
		PRINT ERROR_MESSAGE();
	ELSE
		THROW;
END CATCH 
