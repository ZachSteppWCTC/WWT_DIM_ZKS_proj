
/**************************
* Procedure ETL_LoadDimSuppliers
* Author: zstepp
* Create Date: 11/4/2024
* 
* Loads ODS Suppliers to Dimensional Table
* Inserts and Updates with Historical Data
* Type 3 SCD
*
**************************/
Create   procedure ETL_LoadDimSuppliers
as
begin
	Update DimSupplier
	Set SupplierPreviousCompanyName1 = case when s.CompanyName <> ds.SupplierCompanyName
		then ds.SupplierCompanyName
		else SupplierPreviousCompanyName1
		end,
	SupplierPreviousCompanyName2 = case when s.CompanyName <> ds.SupplierCompanyName
		then ds.SupplierPreviousCompanyName1
		else SupplierPreviousCompanyName2
		end,
	SupplierCompanyName = s.CompanyName,
	SupplierContactName = s.ContactName,
	SupplierContactTitle = s.ContactTitle,
	SupplierWebsite = s.Website,
	SupplierPhone = s.Phone,
	SupplierFax = s.Fax
	from WWT_ODS_ZKS.dbo.Suppliers s
	join DimSupplier ds
	on s.ODSSupplierID = ds.ODSSupplierID
	where not (isnull(s.CompanyName,'') = isnull(ds.SupplierCompanyName,'')
		and isnull(s.Phone,'') = isnull(ds.SupplierPhone,'')
		and isnull(s.ContactName,'') = isnull(ds.SupplierContactName,'')
		and isnull(s.ContactTitle,'') = isnull(ds.SupplierContactTitle,'')
		and isnull(s.Website,'') = isnull(ds.SupplierWebsite,'')
		and isnull(s.Fax,'') = isnull(ds.SupplierFax,'')
	)

	Insert into DimSupplier(ODSSupplierID, SupplierCompanyName, SupplierContactName, SupplierContactTitle, SupplierWebsite, SupplierPhone, SupplierFax)
	select s.ODSSupplierID,
	s.CompanyName,
	s.ContactName,
	s.ContactTitle,
	SupplierWebsite,
	SupplierPhone,
	SupplierFax
	from WWT_ODS_ZKS.dbo.Suppliers s
	left join DimSupplier ds
	on ds.ODSSupplierID = s.ODSSupplierID
	where ds.SupplierKey is null
end
