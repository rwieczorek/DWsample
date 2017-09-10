
/*============================================================================
Name:		fnDateTimeColumnsEnumeratedByTable
Description	Returns tables in a schema eligible for Date/Time key retrieval
			Allocates in to buckets from 1 to @DoP

Parameters	@DoP (default 3)
				Tables will be allocated a bucket from 1 to @DoP
			@Schema (default = Staging)
				Schema in which to search for tables to set date keys on
							
Date			Author				Reason
-------------------------------------------
2017-09-10 		Robert Wieczorek 	Creation

==================================================================================*/
CREATE FUNCTION [Auxiliary].[fnDateTimeColumnsEnumeratedByTable]
(
	@DoP TINYINT = 3
	,@Schema sysname = N'Staging'
)
RETURNS TABLE
AS

RETURN
SELECT 
	@Schema AS [Schema]
	,SourceTable AS [Table]
    ,SourceColumn AS DateTimeColumn
    ,DestinationColumn AS KeyColumn
    ,TimeConversion AS isTimeKey 
	,1 + DENSE_RANK() OVER (PARTITION BY SourceSchema 
							ORDER BY SourceTable) % @DoP AS Bucket
FROM Auxiliary.DateTimeKeyDestination
WHERE SourceSchema = @Schema;
