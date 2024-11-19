
/**************************
* Procedure ETL_LoadDimProduct
* Author: zstepp
* Create Date: 11/4/2024
* 
* Loads ODS Product Data to Dimensional Table
* Inserts and Updates
*
**************************/
create   procedure ETL_LoadDimProduct
as
Begin
	Update DimProduct
	set ProductName = p.ProductName,
	QuantityPerUnit = p.QuantityPerUnit,
	RetailPrice = p.RetailPrice
	from WWT_ODS_ZKS.dbo.Products p
	join DimProduct dp
	on p.ODSProductID = dp.ODSProductID
	where not (ISNULL(p.ProductName,'') = ISNULL(dp.ProductName,''))
	and ISNULL(p.QuantityPerUnit,'') = ISNULL(dp.QuantityPerUnit,'')
	and ISNULL(p.RetailPrice,-1) = ISNULL(dp.RetailPrice,-1)

	Insert into DimProduct(ODSProductID, ProductName, QuantityPerUnit, RetailPrice)
	Select
	p.ODSProductID,
	p.ProductName,
	p.QuantityPerUnit,
	p.RetailPrice
	from WWT_ODS_ZKS.dbo.Products p
	left join DimProduct dp
	on p.ODSProductID = dp.ODSProductID
	where dp.ProductKey is null
end
