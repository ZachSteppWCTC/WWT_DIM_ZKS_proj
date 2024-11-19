CREATE TABLE [dbo].[DimSource] (
    [SourceKey]   INT          IDENTITY (1, 1) NOT NULL,
    [ODSSourceID] INT          NOT NULL,
    [SourceName]  VARCHAR (40) NOT NULL,
    PRIMARY KEY CLUSTERED ([SourceKey] ASC)
);

