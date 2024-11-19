CREATE TABLE [dbo].[DimProduct] (
    [ProductKey]      INT           IDENTITY (1, 1) NOT NULL,
    [ODSProductID]    INT           NOT NULL,
    [ProductName]     VARCHAR (100) NULL,
    [QuantityPerUnit] VARCHAR (20)  NULL,
    [RetailPrice]     MONEY         NULL,
    PRIMARY KEY CLUSTERED ([ProductKey] ASC)
);

