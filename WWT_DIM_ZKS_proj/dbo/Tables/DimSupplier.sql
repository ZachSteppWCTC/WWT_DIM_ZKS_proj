CREATE TABLE [dbo].[DimSupplier] (
    [SupplierKey]                  INT           IDENTITY (1, 1) NOT NULL,
    [ODSSupplierID]                INT           NOT NULL,
    [SupplierCompanyName]          VARCHAR (40)  NOT NULL,
    [SupplierContactName]          VARCHAR (30)  NULL,
    [SupplierContactTitle]         VARCHAR (30)  NULL,
    [SupplierWebsite]              VARCHAR (256) NULL,
    [SupplierPhone]                VARCHAR (24)  NULL,
    [SupplierFax]                  VARCHAR (24)  NULL,
    [SupplierPreviousCompanyName1] VARCHAR (40)  NULL,
    [SupplierPreviousCompanyName2] VARCHAR (40)  NULL,
    PRIMARY KEY CLUSTERED ([SupplierKey] ASC)
);

