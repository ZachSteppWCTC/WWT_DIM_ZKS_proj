
/**************************
* Procedure ETL_LoadDimDates
* Author: zstepp
* Create Date: 11/4/2024
* 
* Inserts derived fields from all relevant order dates
* Insert Only
*
* @BeginDate: The earliest order date in the fact table
* @EndDate: The latest date in any date field in the fact table
*
**************************/
Create   procedure ETL_LoadDimDates
( @BeginDate date, @EndDate date)
as
Begin
	Declare @dte date 
	select @dte = @BeginDate

	Set Identity_Insert DimDate ON

	While (@dte <= @EndDate)
	Begin
		Insert into DimDate(DateKey, Date, DayOfMonth, MonthNumber, Year, EnglishDayOfWeek, EnglishMonth, Quarter, WeekOfYear, DayOfYear, Season)
		Select convert(varchar(8), @dte, 112) as datekey,
		@dte Date, 
		datepart(day, @dte) as Day, 
		datepart(MONTH, @dte) as MonthNumber, 
		datepart(Year, @dte) as Year,
		dateName(WEEKDAY, @dte) as DayOfWeek,
		dateName(month, @dte) as MonthName,
		datepart(QUARTER, @dte) as Quarter,
		datepart(ISO_WEEK, @dte) as WeekOfYear,
		datepart(DAYOFYEAR, @dte) as DayOfYear,
		(case when month(@dte) in (12, 1, 2) then 'Winter'
			when month(@dte) in (3, 4, 5) then 'Spring'
			when month(@dte) in (6, 7, 8) then 'Summer'
			when month(@dte) in (9, 10, 11) then 'Autumn'
		end) as season

		Select @dte = dateAdd(dd, 1, @dte)
	End

	Set Identity_Insert DimDate OFF
end
