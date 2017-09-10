CREATE TABLE [Auxiliary].[Step] (
    [StepKey]  TINYINT       IDENTITY (1, 1) NOT NULL,
    [StageKey] TINYINT       NOT NULL,
    [Name]     NVARCHAR (50) NOT NULL,
    [Order]    TINYINT       NOT NULL,
    CONSTRAINT [PK_Auxiliary_Step] PRIMARY KEY CLUSTERED ([StepKey] ASC),
    CONSTRAINT [FK_Auxiliary_Step_StageKey] FOREIGN KEY ([StageKey]) REFERENCES [Auxiliary].[Stage] ([StageKey]),
    CONSTRAINT [IX_Auxiliary_Step_StageKey_Name] UNIQUE NONCLUSTERED ([StageKey] ASC, [Name] ASC)
);