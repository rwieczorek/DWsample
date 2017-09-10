/*============================================================================
Name:		fnQuoteNameStripSquareBrackets
Purpose:	Strips [ and ] from a string and then applies QUOTENAME() to ensure consistent table/column names

Parameters:	@Name 
				Text to strip of [ and ] and run QUOTENAME on													

Date			Author				Reason
-------------------------------------------
2016-09-10		Robert Wieczorek	Creation

==================================================================================*/ 
CREATE FUNCTION Auxiliary.fnQuoteNameStripSquareBrackets
(
	@Name sysname
)
RETURNS sysname
AS
BEGIN	
	RETURN QUOTENAME(REPLACE(REPLACE(@Name, N']', N''), N'[', N''));
END