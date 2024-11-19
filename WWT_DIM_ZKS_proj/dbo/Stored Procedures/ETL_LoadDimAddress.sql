
/**************************
* Procedure ETL_LoadDimAddress
* Author: zstepp
* Create Date: 11/1/2024
* 
* Loads ODS Addresses to Dimensional Table
* Insert Only
*
**************************/
Create   procedure ETL_LoadDimAddress
as
begin
	Insert into DimAddress(ODSAddressID, AddressLine1, AddressLine2, City, StateOrRegion, ZipCode, Country)
	select a.ODSAddressID,
	a.AddressLine1,
	a.AddressLine2,
	a.City,
	a.StateOrRegion,
	a.ZipCode,
	a.Country
	from WWT_ODS_ZKS.dbo.Address a
	left join DimAddress da
	on a.ODSAddressID = da.ODSAddressID
	where da.AddressKey is null
end



