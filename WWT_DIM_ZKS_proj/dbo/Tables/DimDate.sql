CREATE TABLE [dbo].[DimDate] (
    [DateKey]          INT          IDENTITY (1, 1) NOT NULL,
    [Date]             DATETIME     NULL,
    [DayOfMonth]       INT          NULL,
    [MonthNumber]      INT          NULL,
    [Year]             INT          NULL,
    [EnglishDayOfWeek] VARCHAR (10) NULL,
    [EnglishMonth]     VARCHAR (10) NULL,
    [Quarter]          INT          NULL,
    [WeekOfYear]       INT          NULL,
    [DayOfYear]        INT          NULL,
    [Season]           VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([DateKey] ASC)
);

