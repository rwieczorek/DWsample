/*============================================================================
Name:		fnStripNonNumericChars
Purpose:	Removes non-numeric characters from a string

Parameters	@String
				String to strip non-numeric characters from

Date			Author				Reason
-------------------------------------------
2017-09-10		Robert Wieczorek	Creation

Test:		select Auxiliary.fnStripNonNumericChars('�2.00')
==================================================================================*/

CREATE FUNCTION Auxiliary.fnStripNonNumericChars (@String VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @MatchExpression VARCHAR(20);
    SET @MatchExpression = '%[^0-9.,]%';

    WHILE PATINDEX(@MatchExpression, @String) > 0
    SET @String = STUFF(@String, PATINDEX(@MatchExpression, @String), 1, '');

    RETURN @String;

END;