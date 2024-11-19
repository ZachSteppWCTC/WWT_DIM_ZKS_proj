
/**************************
* Procedure ETL_LoadDimShippers
* Author: zstepp
* Create Date: 11/1/2024
* 
* Loads ODS Shippers to Dimensional Table
* Inserts and Updates with Historical Data
* Type 3 SCD
*
**************************/
Create   procedure ETL_LoadDimShippers
as
begin
	Update DimShippers
	Set ShipperPreviousCompanyName1 = case when s.CompanyName <> ds.ShipperCompanyName
		then ds.ShipperCompanyName
		else ShipperPreviousCompanyName1
		end,
	ShipperPreviousCompanyName2 = case when s.CompanyName <> ds.ShipperCompanyName
		then ds.ShipperPreviousCompanyName1
		else ShipperPreviousCompanyName2
		end,
	ShipperCompanyName = s.CompanyName,
	ShipperPhone = s.Phone
	from WWT_ODS_ZKS.dbo.Shippers s
	join DimShippers ds
	on s.ODSShipperID = ds.ODSShipperID
	where not (isnull(s.CompanyName,'') = isnull(ds.ShipperCompanyName,'')
		and isnull(s.Phone,'') = isnull(ds.ShipperPhone,'')
	)

	Insert into DimShippers(ODSShipperID, ShipperCompanyName, ShipperPhone)
	select s.ODSShipperID,
	s.CompanyName,
	s.Phone
	from WWT_ODS_ZKS.dbo.Shippers s
	left join DimShippers ds
	on ds.ODSShipperID = s.ODSShipperID
	where ds.ShipperKey is null
end
