SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.ValidationType';

IF OBJECT_ID(N'tempdb..#ValidationType') IS NOT NULL
	DROP TABLE #ValidationType;

CREATE TABLE #ValidationType(
	ValidationTypeKey TINYINT NOT NULL PRIMARY KEY CLUSTERED
	,Name NVARCHAR(50) NOT NULL
);


INSERT #ValidationType(
	ValidationTypeKey	
	,Name)
VALUES
	(1, N'Truncation')
	,(2, N'Mandatory')
	,(3, N'Data Type')
	,(4, N'Nullability')
	,(5, N'Test Data');

SET IDENTITY_INSERT Auxiliary.ValidationType ON;

INSERT Auxiliary.ValidationType(
	ValidationTypeKey	
	,Name
)
SELECT 
	ValidationTypeKey	
	,Name
FROM #ValidationType
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.ValidationType
					WHERE ValidationType.ValidationTypeKey = #ValidationType.ValidationTypeKey);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.ValidationType
WHERE NOT EXISTS(	SELECT 1 
					FROM #ValidationType
					WHERE ValidationType.ValidationTypeKey = #ValidationType.ValidationTypeKey);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);

UPDATE ValidationType
SET	
	Name = #ValidationType.Name
FROM
	Auxiliary.ValidationType
	INNER JOIN #ValidationType
		ON ValidationType.ValidationTypeKey = #ValidationType.ValidationTypeKey		
		AND ValidationType.Name <> #ValidationType.Name;

PRINT NCHAR(9) +  N'Updates: ' + CAST(@@ROWCOUNT AS NVARCHAR);

SET IDENTITY_INSERT Auxiliary.ValidationType OFF;