

/**************************
* Procedure ETL_LoadDimProductHistory
* Author: zstepp
* Create Date: 11/4/2024
* 
* Loads ODS Product Data to Dimensional Table
* Inserts and Updates with Historical Data
* Type 2 SCD
*
* @InitialInsert: Sets newly inserted records' start dates to 1/1/1900 if True(1). Default False(0).
*
**************************/
Create   procedure ETL_LoadDimProductHistory
(@InitialInsert bit = 0)
as
begin
	-- Update old records with new incoming data
	Update DimProductHistory
	Set ProductHistoryRowEndDate = GETDATE()
	from WWT_ODS_ZKS.dbo.Products p
	join DimProductHistory dph
	on p.ODSProductID = dph.ODSProductID
	and dph.ProductHistoryRowEndDate = '12/31/9999'
	where not ( isnull(p.ProductName,'') = isnull(dph.ProductHistoricalName,'')
		and isnull(p.QuantityPerUnit,'') = isnull(dph.ProductHistoricalQuantityPerUnit,'')
		and isnull(p.RetailPrice,'') = isnull(dph.ProductHistoricalRetailPrice,'')
	)

	Insert into DimProductHistory(ODSProductID, ProductHistoricalName, ProductHistoricalQuantityPerUnit, ProductHistoricalRetailPrice, ProductHistoryRowStartDate, ProductHistoryRowEndDate)
	select p.ODSProductID,
	p.ProductName,
	p.QuantityPerUnit,
	p.RetailPrice,
	case when @InitialInsert = 1
		then '1/1/1900'
		else GETDATE()
		end as FromDate,
	'12/31/9999' as ThruDate
	from WWT_ODS_ZKS.dbo.Products p
	Left join DimProductHistory dph
	on p.ODSProductID = dph.ODSProductID
	and dph.ProductHistoryRowEndDate = '12/31/9999'
	where dph.ProductHistoryKey is null
end
