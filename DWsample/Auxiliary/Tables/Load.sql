CREATE TABLE [Auxiliary].[Load] (
    [LoadKey]           INT      IDENTITY (1, 1) NOT NULL,
    [Started]           SMALLDATETIME NOT NULL,
    [Ended]             SMALLDATETIME NULL,
    [CompletedNormally] BIT           NULL,
    CONSTRAINT [PK_Auxiliary_Load] PRIMARY KEY CLUSTERED ([LoadKey] ASC)
);
