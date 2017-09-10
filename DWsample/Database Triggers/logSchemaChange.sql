CREATE TRIGGER [logSchemaChange] 
ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS 
AS
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET QUOTED_IDENTIFIER ON
SET CONCAT_NULL_YIELDS_NULL ON
DECLARE @data XML
SET @data =  EVENTDATA()
   INSERT DDLlog
        ( EventType
        , PostTime 
        , SPID 
        , ServerName 
        , LoginName 
        , UserName 
        , DatabaseName 
        , SchemaName 
        , ObjectName 
        , ObjectType 
        , TSQLCommand 
)
VALUES(  
           @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(50)')
        ,  @data.value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime')
        ,  @data.value('(/EVENT_INSTANCE/SPID)[1]', 'int')
        ,  @data.value('(/EVENT_INSTANCE/ServerName)[1]', 'sysname')
        ,  @data.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(100)')
        ,  @data.value('(/EVENT_INSTANCE/UserName)[1]', 'varchar(100)')
        ,  @data.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'sysname')
        ,  @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname')
        ,  @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname')
        ,  @data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(100)')
        ,  @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'varchar(Max)')
)
SET ANSI_NULLS OFF
SET ANSI_PADDING OFF
SET ANSI_WARNINGS OFF
SET QUOTED_IDENTIFIER OFF
SET CONCAT_NULL_YIELDS_NULL OFF