SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.Stage';

IF OBJECT_ID(N'tempdb..#Stage') IS NOT NULL
	DROP TABLE #Stage;

CREATE TABLE #Stage(
	StageKey TINYINT NOT NULL PRIMARY KEY CLUSTERED
	,Name NVARCHAR(50) NOT NULL
	,[Order] TINYINT NOT NULL
);


INSERT #Stage(
	StageKey	
	,Name
	,[Order])
VALUES
	(1, N'File Pre Process', 1)
	,(2, N'Staging', 2)
	,(3, N'Data Hygiene', 3)
	,(4, N'Streaming Pre Validation', 4)
	,(5, N'Streaming Validation', 5)
	,(6, N'Streaming Business Rules', 6)
	,(7, N'Streaming Aggregations', 7)
	,(8, N'Pre Validation', 8)
	,(9, N'Validation', 9)
	,(10, N'Post Validation', 10)
	,(11, N'Insert to PreLoad', 11)
	,(12, N'Pre Load', 12)
	,(13, N'Entity Load', 13)
	,(14, N'Dependent Business Rules', 14)
	,(15, N'Dependent Aggregations', 15)
	,(16, N'Archive', 16)
	,(17, N'Finalise', 100);

SET IDENTITY_INSERT Auxiliary.Stage ON;

INSERT Auxiliary.Stage(
	StageKey	
	,Name
	,[Order]
)
SELECT 
	StageKey	
	,Name
	,[Order]
FROM #Stage
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.Stage 
					WHERE Stage.StageKey = #Stage.StageKey);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.Stage
WHERE NOT EXISTS(	SELECT 1 
					FROM #Stage
					WHERE Stage.StageKey = #Stage.StageKey);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);

UPDATE Stage
SET	
	Name = #Stage.Name
	,[Order] = #Stage.[Order]
FROM
	Auxiliary.Stage
	INNER JOIN #Stage
		ON Stage.StageKey = #Stage.StageKey		
		AND (Stage.Name <> #Stage.Name
			OR Stage.[Order] <> #Stage.[Order]);

PRINT NCHAR(9) +  N'Updates: ' + CAST(@@ROWCOUNT AS NVARCHAR);

SET IDENTITY_INSERT Auxiliary.Stage OFF;