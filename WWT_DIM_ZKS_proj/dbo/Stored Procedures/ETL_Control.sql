
/**************************
* Procedure ETL_Control
* Author: zstepp
* Create Date: 11/5/2024
* 
* Kicks off all dimensional ETL proecedures in order
*
* @InitialInsert: Sets newly inserted history records' start dates to 1/1/1900
* and inserts unknown default rows if True(1). Default False(0).
*
* @BeginDate: Optional date field for inserting on date dimension.
* @EndDate: Optional date field for inserting on date dimension.
*
* @AutoDate: Fills empty @BeginDate and @EndDate if True(1). Default True(1) 
* AutoDate starts with ( day after latest DimDate, or earliest OrderDate if DimDates is empty )
* AutoDate ends with ( latest ODS Order, Required, or Shipped Date )
* Dates do not load if either @BeginDate or @EndDate is left null and @AutoDate is set to False(0), which may cause errors with new data.
*
* Initial execution should looks something like this:		EXEC ETL_Control 1, '1/1/2020', '6/11/2023'
* OR Initial execution with auto dates:						EXEC ETL_Control 1
* Standard subsequent execution requires no parameters:		EXEC ETL_Control
* Subsequent execution with no dates (not recommended):		EXEC ETL_Control @AutoDate = 0
*
**************************/
Create   procedure ETL_Control
(@InitialInsert bit = 0, @BeginDate date = null, @EndDate date = null, @AutoDate bit = 1)
as
begin
	set nocount on

	if (@InitialInsert = 1)
		begin
		Exec ETL_LoadUnknownRows
		end
	
	if(@BeginDate is not null and @EndDate is not null)
		begin
		Exec ETL_LoadDimDates @BeginDate = @BeginDate, @EndDate = @EndDate
		end
	else
	begin
	if (@AutoDate = 1)
		begin
		if (@BeginDate is null)
			begin
			if ((select top 1 date from DimDate where date <> '1/1/1900' and date <> '12/31/9999') is null)
				begin
				Set @BeginDate = (select min(OrderDate) from WWT_ODS_ZKS.dbo.Orders)
				end
			else 
				begin
				Declare @AutoBeginDate date
				;With LatestDIMdate as (
				select (max(Date)) maxdate from DimDate where Date <> '12/31/9999' and Date <> '1/1/1900')
				Select @AutoBeginDate = (select dateadd(dd, 1, maxdate) from LatestDIMdate)
				Set @BeginDate = @AutoBeginDate
				end
			end
		if (@EndDate is null)
			begin
			Declare @AutoEndDate date
			;With LatestODSdates as (
			select max(OrderDate) MaxDates from WWT_ODS_ZKS.dbo.Orders
			union
			select max(RequiredDate) MaxDates from WWT_ODS_ZKS.dbo.Orders
			union
			select max(ShippedDate) MaxDates from WWT_ODS_ZKS.dbo.Orders)
			select @AutoEndDate = max(MaxDates) from LatestODSdates
			Set @EndDate = @AutoEndDate
			end
		Exec ETL_LoadDimDates @BeginDate = @BeginDate, @EndDate = @EndDate
		end
	end

	Exec ETL_LoadDimCategory
	@InitialInsert = @InitialInsert

	Exec ETL_LoadDimProductHistory
	@InitialInsert = @InitialInsert

	Exec ETL_LoadDimProduct

	Exec ETL_LoadDimCustomer 
	@InitialInsert = @InitialInsert

	Exec ETL_LoadDimAddress

	Exec ETL_LoadDimSource

	Exec ETL_LoadDimEmployee

	Exec ETL_LoadDimSuppliers

	Exec ETL_LoadDimShippers

	Exec ETL_LoadFactOrderDetail
end
