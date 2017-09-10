
/*============================================================================
Description	Removes non-alphanumeric characters from a string

Parameters	@String
				String to strip non-alphanumeric characters from

Date			Author				Reason
-------------------------------------------
2017-09-10		Robert Wieczorek	Creation

select Auxiliary.fnStripNonAlphaNumChars('�2.00')
==================================================================================*/

CREATE FUNCTION Auxiliary.fnStripNonAlphaNumChars (@String NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @MatchExpression NVARCHAR(20);
    SET @MatchExpression = '%[^a-z0-9]%';

    WHILE PATINDEX(@MatchExpression, @String) > 0
    SET @String = STUFF(@String, PATINDEX(@MatchExpression, @String), 1, '');

    RETURN @String;

END;