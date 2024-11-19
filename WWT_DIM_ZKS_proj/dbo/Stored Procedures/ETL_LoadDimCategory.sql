
/**************************
* Procedure ETL_LoadDimCategory
* Author: zstepp
* Create Date: 11/1/2024
* 
* Loads ODS Categories to Dimensional Table
* Inserts and Updates with Historical Data
* Type 2 SCD
*
* @InitialInsert: Sets newly inserted records' start dates to 1/1/1900 if True(1). Default False(0).
*
**************************/
Create   procedure ETL_LoadDimCategory
(@InitialInsert bit = 0)
as
begin
	-- Update categories having incoming data
	Update DimCategory
	Set CategoryRowEndDate = GETDATE(),
	CategoryRowIsCurrent = 0
	from WWT_ODS_ZKS.dbo.Category c
	join DimCategory dc
	on c.ODSCategoryId = dc.ODSCategoryID
	and dc.CategoryRowEndDate = '12/31/9999'
	where not ( isnull(c.Category,'') = isnull(dc.CategoryName,'')
		and isnull(c.Description,'') = isnull(dc.CategoryDescription,'')
	)

	-- Insert any new data
	Insert into DimCategory(ODSCategoryID, CategoryName, CategoryDescription, CategoryRowStartDate, CategoryRowEndDate, CategoryRowIsCurrent)
	select c.ODSCategoryId,
	c.Category,
	c.Description,
		case when @InitialInsert = 1
		then '1/1/1900'
		else GETDATE()
		end as FromDate,
	'12/31/9999' as ThruDate,
	1 as CategoryRowIsCurrent
	from WWT_ODS_ZKS.dbo.Category c
	Left join DimCategory dc
	on c.ODSCategoryId = dc.ODSCategoryID
	and dc.CategoryRowEndDate = '12/31/9999'
	where dc.CategoryKey is null
end
