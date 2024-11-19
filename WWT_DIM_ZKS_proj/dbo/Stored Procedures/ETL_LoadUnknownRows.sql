/**************************
* Procedure ETL_LoadUnknownRows
* Author: zstepp
* Create Date: 11/4/2024
* 
* Inserts a single row into each dimensional tables that represents unknown.
* Inserts 1/1/1900 and 12/31/9999 into Dates as Unknown Placeholders
* Insert Only
*
**************************/
Create   procedure ETL_LoadUnknownRows
as
begin
	Set Identity_Insert DimSupplier ON
	Insert into DimSupplier(SupplierKey, ODSSupplierID, SupplierCompanyName, SupplierContactName, SupplierContactTitle, SupplierWebsite, SupplierPhone, SupplierFax, SupplierPreviousCompanyName1, SupplierPreviousCompanyName2)
	select 0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', null, null
	Set Identity_Insert DimSupplier OFF

	Set Identity_Insert DimSource ON
	Insert into DimSource(SourceKey, ODSSourceID, SourceName)
	Select 0, 0, 'Unknown'
	Set Identity_Insert DimSource OFF

	Set Identity_Insert DimShippers ON
	Insert into DimShippers(ShipperKey, ODSShipperID, ShipperCompanyName, ShipperPhone, ShipperPreviousCompanyName1, ShipperPreviousCompanyName2)
	Select 0, 0, 'Unknown', 'Unknown', null, null
	Set Identity_Insert DimShippers OFF

	Set Identity_Insert DimProduct ON
	Insert into DimProduct(ProductKey, ODSProductID, ProductName, QuantityPerUnit, RetailPrice)
	Select 0, 0, 'Unknown', 'Unknown', 0
	Set Identity_Insert DimProduct OFF

	Set Identity_Insert DimProductHistory ON
	Insert into DimProductHistory(ProductHistoryKey, ODSProductID, ProductHistoricalName, ProductHistoricalQuantityPerUnit, ProductHistoricalRetailPrice, ProductHistoryRowStartDate, ProductHistoryRowEndDate)
	Select 0, 0, 'Unknown', 'Unknown', 0, '1/1/1900', '1/1/1900'
	Set Identity_Insert DimProductHistory OFF

	Set Identity_Insert DimEmployees ON
	Insert into DimEmployees(EmployeeKey, ODSEmployeeID, EmployeeFirstName, EmployeeLastName, EmployeeFullName, EmployeeJobTitle, EmployeeTitle, EmployeeBirthDate, HireDate, TerminationDate, IsActive, ManagerFullName)
	Select 0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '1/1/1900', '1/1/1900', null, 0, 'Unknown'
	Set Identity_Insert DimEmployees OFF

	Set Identity_Insert DimCustomer ON
	Insert into DimCustomer(CustomerKey, ODSCustomerID, CustomerName, CustomerContactName, CustomerContactTitle, CustomerPhone, CustomerFax, CustomerRowStartDate, CustomerRowEndDate, CustomerRowIsCurrent)
	Select 0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', '1/1/1900', '1/1/1900', 0
	Set Identity_Insert  DimCustomer OFF

	Set Identity_Insert DimCategory ON
	Insert into DimCategory(CategoryKey, ODSCategoryID, CategoryName, CategoryDescription, CategoryRowStartDate, CategoryRowEndDate, CategoryRowIsCurrent)
	Select 0, 0, 'Unknown', 'Unknown', '1/1/1900', '1/1/1900', 0
	Set Identity_Insert  DimCategory OFF

	Set Identity_Insert DimAddress ON
	Insert into DimAddress(AddressKey, ODSAddressID, AddressLine1, AddressLine2, City, StateOrRegion, ZipCode, Country)
	Select 0, 0, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown'
	Set Identity_Insert  DimAddress OFF

	Set Identity_Insert DimDate ON
	Insert into DimDate(DateKey, Date, DayOfMonth, MonthNumber, Year, EnglishDayOfWeek, EnglishMonth, Quarter, WeekOfYear, DayOfYear, Season)
	Values (19000101, '1/1/1900', 0, 0, 0, 'Unknown', 'Unknown', 0, 0, 0, 'Unknown'),
	(99991231, '12/31/9999', 0, 0, 0, 'Unknown', 'Unknown', 0, 0, 0, 'Unknown')
	Set Identity_Insert  DimDate OFF
end
