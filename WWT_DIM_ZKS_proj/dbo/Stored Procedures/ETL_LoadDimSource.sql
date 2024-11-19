
/**************************
* Procedure ETL_LoadDimSource
* Author: zstepp
* Create Date: 11/1/2024
* 
* Loads ODS Sources to Dimensional Table
* Inserts and Updates
*
**************************/
create   procedure ETL_LoadDimSource
as
Begin
	Update DimSource
	set SourceName = s.TraderName
	from WWT_ODS_ZKS.dbo.SourceTrader s
	join DimSource ds
	on s.SourceID = ds.ODSSourceID
	where not (ISNULL(s.TraderName,'') = ISNULL(ds.SourceName,''))

	Insert into DimSource(ODSSourceID, SourceName)
	Select
	s.SourceID,
	s.TraderName
	from WWT_ODS_ZKS.dbo.SourceTrader s
	left join DimSource ds
	on s.SourceID = ds.ODSSourceID
	where ds.SourceKey is null
end
