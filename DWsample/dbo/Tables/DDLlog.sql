CREATE TABLE [dbo].[DDLlog] (
    [DDLlog_ID]    INT            IDENTITY (1, 1) NOT NULL,
    [EventType]    NVARCHAR (50)  NULL,
    [PostTime]     DATETIME       NULL,
    [SPID]         INT            NULL,
    [ServerName]   NVARCHAR (128) NULL,
    [LoginName]    VARCHAR (100)  NULL,
    [UserName]     VARCHAR (100)  NULL,
    [DatabaseName] NVARCHAR (128) NULL,
    [SchemaName]   NVARCHAR (128) NULL,
    [ObjectName]   NVARCHAR (128) NULL,
    [ObjectType]   VARCHAR (100)  NULL,
    [TSQLCommand]  VARCHAR (MAX)  NULL
);