CREATE TABLE [dbo].[DimShippers] (
    [ShipperKey]                  INT          IDENTITY (1, 1) NOT NULL,
    [ODSShipperID]                INT          NOT NULL,
    [ShipperCompanyName]          VARCHAR (40) NOT NULL,
    [ShipperPhone]                VARCHAR (24) NULL,
    [ShipperPreviousCompanyName1] VARCHAR (40) NULL,
    [ShipperPreviousCompanyName2] VARCHAR (40) NULL,
    PRIMARY KEY CLUSTERED ([ShipperKey] ASC)
);

