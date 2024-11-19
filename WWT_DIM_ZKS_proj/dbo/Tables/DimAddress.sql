CREATE TABLE [dbo].[DimAddress] (
    [AddressKey]    INT          IDENTITY (1, 1) NOT NULL,
    [ODSAddressID]  INT          NULL,
    [AddressLine1]  VARCHAR (60) NULL,
    [AddressLine2]  VARCHAR (60) NULL,
    [City]          VARCHAR (50) NULL,
    [StateOrRegion] VARCHAR (20) NULL,
    [ZipCode]       VARCHAR (50) NULL,
    [Country]       VARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([AddressKey] ASC)
);

