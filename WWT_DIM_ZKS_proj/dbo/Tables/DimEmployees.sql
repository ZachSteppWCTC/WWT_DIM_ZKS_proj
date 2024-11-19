CREATE TABLE [dbo].[DimEmployees] (
    [EmployeeKey]       INT          IDENTITY (1, 1) NOT NULL,
    [ODSEmployeeID]     INT          NOT NULL,
    [EmployeeFirstName] VARCHAR (20) NOT NULL,
    [EmployeeLastName]  VARCHAR (20) NOT NULL,
    [EmployeeFullName]  VARCHAR (42) NULL,
    [EmployeeJobTitle]  VARCHAR (30) NULL,
    [EmployeeTitle]     VARCHAR (25) NULL,
    [EmployeeBirthDate] DATETIME     NULL,
    [HireDate]          DATETIME     NULL,
    [TerminationDate]   DATETIME     NULL,
    [IsActive]          BIT          NULL,
    [ManagerFullName]   VARCHAR (42) NULL,
    PRIMARY KEY CLUSTERED ([EmployeeKey] ASC)
);

