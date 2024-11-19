CREATE TABLE [dbo].[DimProductHistory] (
    [ProductHistoryKey]                INT           IDENTITY (1, 1) NOT NULL,
    [ODSProductID]                     INT           NOT NULL,
    [ProductHistoricalName]            VARCHAR (100) NULL,
    [ProductHistoricalQuantityPerUnit] VARCHAR (20)  NULL,
    [ProductHistoricalRetailPrice]     MONEY         NULL,
    [ProductHistoryRowStartDate]       DATETIME      NULL,
    [ProductHistoryRowEndDate]         DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ProductHistoryKey] ASC)
);

