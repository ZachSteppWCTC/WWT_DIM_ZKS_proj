CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [ODSCustomerID]        INT           NOT NULL,
    [CustomerName]         VARCHAR (100) NOT NULL,
    [CustomerContactName]  VARCHAR (30)  NULL,
    [CustomerContactTitle] VARCHAR (30)  NULL,
    [CustomerPhone]        VARCHAR (24)  NULL,
    [CustomerFax]          VARCHAR (24)  NULL,
    [CustomerRowStartDate] DATETIME      NULL,
    [CustomerRowEndDate]   DATETIME      NULL,
    [CustomerRowIsCurrent] BIT           NULL,
    PRIMARY KEY CLUSTERED ([CustomerKey] ASC)
);

