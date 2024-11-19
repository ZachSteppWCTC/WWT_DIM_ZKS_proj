
/**************************
* Procedure ETL_LoadDimCustomer
* Author: zstepp
* Create Date: 11/4/2024
* 
* Loads ODS Customers to Dimensional Table
* Inserts and Updates with Historical Data
* Type 2 SCD
*
* @InitialInsert: Sets newly inserted records' start dates to 1/1/1900 if True(1). Default False(0).
*
**************************/
Create   procedure ETL_LoadDimCustomer
(@InitialInsert bit = 0)
as
begin
	-- Update Customers with incoming data
	Update DimCustomer
	Set CustomerRowEndDate = GETDATE(),
	CustomerRowIsCurrent = 0
	from WWT_ODS_ZKS.dbo.Customers c
	join DimCustomer dc
	on c.ODSCustomerID = dc.ODSCustomerID
	and dc.CustomerRowEndDate = '12/31/9999'
	where not ( isnull(c.CustomerName,'') = isnull(dc.CustomerName,'')
		and isnull(c.ContactName,'') = isnull(dc.CustomerContactName,'')
		and isnull(c.ContactTitle,'') = isnull(dc.CustomerContactTitle,'')
		and isnull(c.Phone,'') = isnull(dc.CustomerPhone,'')
		and isnull(c.Fax,'') = isnull(dc.CustomerFax,'')
	)

	-- Insert any new data
	Insert into DimCustomer(ODSCustomerID, CustomerName, CustomerContactName, CustomerContactTitle, CustomerPhone, CustomerFax, CustomerRowStartDate, CustomerRowEndDate, CustomerRowIsCurrent)
	select c.ODSCustomerID,
	c.CustomerName,
	c.ContactName,
	c.ContactTitle,
	c.Phone,
	c.Fax,
	case when @InitialInsert = 1
		then '1/1/1900'
		else GETDATE()
		end as FromDate,
	'12/31/9999' as ThruDate,
	1 as CategoryRowIsCurrent
	from WWT_ODS_ZKS.dbo.Customers c
	Left join DimCustomer dc
	on c.ODSCustomerId = dc.ODSCustomerID
	and dc.CustomerRowEndDate = '12/31/9999'
	where dc.CustomerKey is null
end
