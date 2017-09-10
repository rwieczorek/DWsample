CREATE TABLE [Auxiliary].[FieldDecode] (
    [FieldDecodeKey] SMALLINT       IDENTITY (1, 1) NOT NULL,
    [FieldKey]       SMALLINT       NOT NULL,
    [FieldValue]     NVARCHAR (100) NULL,
    [DecodeValue]    NVARCHAR (100) NULL,
    CONSTRAINT [PK_Auxiliary_FieldDecode] PRIMARY KEY CLUSTERED ([FieldDecodeKey] ASC) ,
    CONSTRAINT [FK_Auxiliary_FieldDecode_FieldKey] FOREIGN KEY ([FieldKey]) REFERENCES [Auxiliary].[Field] ([FieldKey])    
);