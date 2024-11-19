CREATE TABLE [dbo].[DimCategory] (
    [CategoryKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ODSCategoryID]        INT           NOT NULL,
    [CategoryName]         VARCHAR (30)  NOT NULL,
    [CategoryDescription]  VARCHAR (MAX) NULL,
    [CategoryRowStartDate] DATETIME      NULL,
    [CategoryRowEndDate]   DATETIME      NULL,
    [CategoryRowIsCurrent] BIT           NULL,
    PRIMARY KEY CLUSTERED ([CategoryKey] ASC)
);

