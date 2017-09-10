SET NOCOUNT ON;
PRINT N'-------------------------------------';
PRINT N'Auxiliary.Step';

IF OBJECT_ID(N'tempdb..#Step') IS NOT NULL
	DROP TABLE #Step;

IF OBJECT_ID(N'tempdb..#StepMapping') IS NOT NULL
	DROP TABLE #StepMapping;

CREATE TABLE #Step(
	StepKey TINYINT NOT NULL,
	StageKey TINYINT NOT NULL,
	Name NVARCHAR(50) NOT NULL UNIQUE,
	[Order] TINYINT NOT NULL	
);



CREATE TABLE #StepMapping(
	StepKey TINYINT NOT NULL,
	StageName NVARCHAR(50) NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	[Order] TINYINT IDENTITY(1, 1) NOT NULL
);


INSERT #StepMapping (
	StepKey
	,StageName
	,Name)
VALUES
	(1, N'File Pre Process', N'SFTP')
	,(2, N'File Pre Process', N'HTTP')
	,(3, N'File Pre Process', N'Stations XML')
	,(4, N'Staging', N'File Validity')
	,(43, N'Staging', N'Partition Creation (Staging and History)')
	,(5, N'Staging', N'File Field to Staging Mapping')
	,(6, N'Data Hygiene', N'DTV')
	,(7, N'Streaming Pre Validation', N'Decodes')
	,(42, N'Streaming Pre Validation', N'Cleaning')
	,(8, N'Streaming Validation', N'Mandatoriness')
	,(9, N'Streaming Validation', N'Data Type')
	,(10, N'Streaming Validation', N'Truncation')
	,(11, N'Streaming Validation', N'Set RecordRejected Flag')
	,(12, N'Streaming Business Rules', N'Streaming Business Rules')
	,(13, N'Streaming Aggregations', N'Streaming Aggregations')
	,(14, N'Pre Validation', N'Dependent Decodes')
	,(15, N'Validation', N'Dependent Validation')
	,(16, N'Post Validation', N'Post Validation')
	,(17, N'Staging', N'Insert to Pre Load')
	,(18, N'Pre Load', N'Initialise DW Load')
	,(19, N'Pre Load', N'Expectancy')
	,(20, N'Pre Load', N'Customer Matching')
	,(21, N'Entity Load', N'Station')
	,(22, N'Entity Load', N'Customer')
	,(23, N'Entity Load', N'Preferences')
	,(24, N'Entity Load', N'Email Events')
	,(25, N'Entity Load', N'Trainline Transactions')
	,(26, N'Entity Load', N'Season Tickets')
	,(27, N'Entity Load', N'Wifi Purchases')
	,(28, N'Entity Load', N'Customer Service Cases')
	,(29, N'Entity Load', N'Loyalty')
	,(44, N'Entity Load', N'Customer Segments')
	,(30, N'Dependent Business Rules', N'Contactability')
	,(31, N'Dependent Business Rules', N'Other')
	,(32, N'Dependent Aggregations', N'Spend')
	,(33, N'Dependent Aggregations', N'Claims')
	,(34, N'Dependent Aggregations', N'Customer Attributes')
	,(35, N'Dependent Aggregations', N'Customer Events')
	,(36, N'Dependent Aggregations', N'Email Campaign Aggregation')
	,(37, N'Dependent Aggregations', N'SSRS Reports')
	,(38, N'Archive', N'Archive')
	,(39, N'Staging', N'RedEye Extract')
	,(40, N'Dependent Aggregations', N'Active Wifi Journey')
	,(41, N'Finalise', N'Finalise')
	;


INSERT #Step(
	StepKey
	,StageKey
	,Name
	,[Order])
SELECT
	m.StepKey
	,s.StageKey
	,m.Name
	,m.[Order]
FROM #StepMapping m
INNER JOIN Auxiliary.Stage s ON s.Name = m.StageName
	
	
--	SELECT * FROM #StepMapping m
--INNER JOIN Auxiliary.Stage s ON s.Name = m.StageName
--	SELECT * FROM #Step

SET IDENTITY_INSERT Auxiliary.Step ON;

UPDATE Step
SET	
	StageKey = #Step.StageKey
	,Name = #Step.Name
	,[Order] = #Step.[Order]
FROM
	Auxiliary.Step
	INNER JOIN #Step
		ON Step.StepKey = #Step.StepKey		
		AND (Step.StageKey <> #Step.StageKey
			OR Step.Name <> #Step.Name
			OR Step.[Order] <> #Step.[Order]);

PRINT NCHAR(9) +  N'Updates: ' + CAST(@@ROWCOUNT AS NVARCHAR);

INSERT Auxiliary.Step(
	StepKey	
	,StageKey
	,Name
	,[Order]
)
SELECT 
	StepKey	
	,StageKey
	,Name
	,[Order]
FROM #Step
WHERE NOT EXISTS(	SELECT 1 
					FROM Auxiliary.Step 
					WHERE Step.StepKey = #Step.StepKey);

PRINT NCHAR(9) + N'Inserts: ' + CAST(@@ROWCOUNT AS NVARCHAR);

DELETE Auxiliary.Step
WHERE NOT EXISTS(	SELECT 1 
					FROM #Step
					WHERE Step.StepKey = #Step.StepKey);

PRINT NCHAR(9) +  N'Deletes: ' + CAST(@@ROWCOUNT AS NVARCHAR);

SET IDENTITY_INSERT Auxiliary.Step OFF;