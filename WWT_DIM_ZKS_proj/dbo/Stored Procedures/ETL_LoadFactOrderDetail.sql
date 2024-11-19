Create   procedure ETL_LoadFactOrderDetail
as
begin
    SELECT DISTINCT 
    OrderID,
    ROW_NUMBER() OVER(ORDER BY OrderID) AS NewOrderID
	into #NewOrderIDs
    FROM (Select ODSOrderID from WWT_ODS_ZKS.dbo.Orders) AS OriginalOrders (OrderID);

	With OrderTotals(OrderId, SalesAmount, DiscountPercent, DiscountAmount, Cost) as (
		Select o.ODSOrderID,
		cast(sum((d.Quantity * d.UnitPrice) * (1 - isnull(d.Discount, 0))) as money),
		round(1 - (sum((d.Quantity * d.UnitPrice) * (1 - isnull(d.Discount, 0))) / sum(d.Quantity * d.UnitPrice)), 2),
		cast(sum((d.Quantity * d.UnitPrice) * isnull(d.Discount, 0)) as money),
		cast(sum(p.Cost) as money)
		From WWT_ODS_ZKS.dbo.OrderDetails d
		join WWT_ODS_ZKS.dbo.Orders o
		on d.ODSOrderID = o.ODSOrderID
		join WWT_ODS_ZKS.dbo.Products p
		on d.ODSProductID = p.ODSProductID
		group by o.ODSOrderID
	)
	Select nids.NewOrderID AS OrderKey,
	ROW_NUMBER() OVER(PARTITION BY d.ODSOrderID ORDER BY d.ODSProductID) AS OrderDetailKey,
	d.ODSOrderID,
	d.ODSProductID,
	o.OrderDate,
	o.RequiredDate,
	o.ShippedDate,
	case when o.ShippedDate is not null
		then DATEDIFF(dd, o.OrderDate, o.ShippedDate)
		else null end as DaysToShip,
	case when o.RequiredDate is not null and o.ShippedDate is not null and o.RequiredDate < o.ShippedDate
		then abs(DATEDIFF(dd, o.ShippedDate, o.RequiredDate))
	when o.RequiredDate is not null and o.ShippedDate is not null and o.RequiredDate >= o.ShippedDate
		then 0
	else
		null end as DaysOverDue,
	d.UnitPrice,
	p.Cost,
	d.Quantity,
	d.Discount,
	d.UnitPrice * d.Discount as PerUnitDiscountAmount,
	(d.Quantity * d.UnitPrice) * (1 - isnull(d.Discount, 0)) as LineTotal,
	(d.Quantity * d.UnitPrice) * d.Discount as LineDiscountAmount,
	ot.SalesAmount,
	ot.DiscountAmount as OrderDiscountAmount,
	ot.DiscountPercent as OrderDiscountPercent,
	o.Freight,
	ot.SalesAmount - ot.Cost as Profit,
	isnull(ca.AddressKey, 0) as CustomerCurrentAddressKey,
	isnull(da.AddressKey, 0) as DeliveryAddressKey,
	isnull(dsh.ShipperKey, 0) as ShipperKey,
	isnull(dso.SourceKey, 0) as SourceKey,
	isnull(dcus.CustomerKey, 0) as CustomerKey,
	isnull(de.EmployeeKey, 0) as EmployeeKey,
	isnull(dp.ProductKey, 0) as ProductKey,
	isnull(dph.ProductHistoryKey, 0) as ProductHistoryKey,
	isnull(dsu.SupplierKey, 0) as SupplierKey,
	isnull(dcat.CategoryKey, 0) as CategoryKey,
	convert(varchar(8),o.OrderDate , 112) as OrderDateKey,
	convert(varchar(8),o.RequiredDate , 112) as RequiredDateKey,
	convert(varchar(8),o.ShippedDate , 112) as ShippedDateKey
	into #OrderDetails
	From WWT_ODS_ZKS.dbo.OrderDetails d
	join WWT_ODS_ZKS.dbo.Orders o
	on d.ODSOrderID = o.ODSOrderID
	join #NewOrderIDs nids
	on nids.OrderID = d.ODSOrderID
	join OrderTotals ot
	on ot.OrderId = o.ODSOrderID
	join WWT_ODS_ZKS.dbo.Products p
	on d.ODSProductID = p.ODSProductID
	join WWT_ODS_ZKS.dbo.Customers c
	on c.ODSCustomerID = o.ODSCustomerID
	-- Left joining dimensions
	left join DimCustomer dcus
	on dcus.ODSCustomerID = c.ODSCustomerID
	and o.OrderDate between dcus.CustomerRowStartDate and dcus.CustomerRowEndDate
	left join DimProduct dp
	on dp.ODSProductID = p.ODSProductID
	left join DimProductHistory dph
	on dph.ODSProductID = p.ODSProductID
	and o.OrderDate between dph.ProductHistoryRowStartDate and dph.ProductHistoryRowEndDate
	left join DimShippers dsh
	on dsh.ODSShipperID = o.ShipVia
	left join DimCategory dcat
	on dcat.ODSCategoryID = p.ODSCategoryId
	and o.OrderDate between dcat.CategoryRowStartDate and dcat.CategoryRowEndDate
	left join DimSupplier dsu
	on dsu.ODSSupplierID = p.ODSSupplierId
	left join DimEmployees de
	on de.ODSEmployeeID = o.ODSEmployeeID
	left join DimSource dso
	on dso.ODSSourceID = o.SourceID
	left join DimAddress ca --Customer Address
	on ca.ODSAddressID = c.BillingAddressID
	left join DimAddress da --Delivery Address
	on da.ODSAddressID = o.DeliveryAddressID

	Update FactOrderDetail
	set OrderDate = o.OrderDate,
	RequiredDate = o.RequiredDate,
	ShippedDate = o.ShippedDate,
	DaysToShip = o.DaysToShip,
	DaysOverdue = o.DaysOverdue,
	UnitPrice = o.UnitPrice,
	UnitCost = o.Cost,
	Quantity = o.Quantity,
	DiscountPercent = o.Discount,
	PerUnitDiscountAmount = o.PerUnitDiscountAmount,
	LineTotal = o.LineTotal,
	LineDiscountAmount = o.LineDiscountAmount,
	SalesAmount = o.SalesAmount,
	OrderDiscountAmount = o.OrderDiscountAmount,
	OrderDiscountPercent = o.OrderDiscountPercent,
	Freight = o.Freight,
	Profit = o.Profit,
	CustomerAddressKey = o.CustomerCurrentAddressKey,
	DeliveryAddressKey = o.DeliveryAddressKey,
	ShipperKey = o.ShipperKey,
	SourceKey = o.SourceKey,
	CustomerKey = o.CustomerKey,
	EmployeeKey = o.EmployeeKey,
	ProductKey = o.ProductKey,
	ProductHistoryKey = o.ProductHistoryKey,
	SupplierKey = o.SupplierKey,
	CategoryKey = o.CategoryKey,
	OrderDateKey = o.OrderDateKey,
	RequiredDateKey = o.RequiredDateKey,
	ShippedDateKey = o.ShippedDateKey
	from FactOrderDetail f
	join #OrderDetails o
	on f.ODSOrderID = o.ODSOrderID
	and f.ODSProductID = o.ODSProductID
	where not (
		isnull(f.OrderDate, '12/31/9999') = isnull(o.OrderDate, '12/31/9999')
		and isnull(f.RequiredDate, '12/31/9999') = isnull(o.RequiredDate, '12/31/9999')
		and isnull(f.ShippedDate, '12/31/9999') = isnull(o.ShippedDate, '12/31/9999')
		and isnull(f.DaysToShip, -1) = isnull(o.DaysToShip, -1)
		and isnull(f.DaysOverdue, -1) = isnull(o.DaysOverdue, -1)
		and isnull(f.UnitPrice, -1) = isnull(o.UnitPrice, -1)
		and isnull(f.UnitCost, -1) = isnull(o.Cost, -1)
		and isnull(f.Quantity, -1) = isnull(o.Quantity, -1)
		and isnull(f.DiscountPercent, -1) = isnull(o.Discount, -1)
		and isnull(f.PerUnitDiscountAmount, -1) = isnull(o.PerUnitDiscountAmount, -1)
		and isnull(f.LineTotal, -1) = isnull(o.LineTotal, -1)
		and isnull(f.LineDiscountAmount, -1) = isnull(o.LineDiscountAmount, -1)
		and isnull(f.SalesAmount, -1) = isnull(o.SalesAmount, -1)
		and isnull(f.OrderDiscountAmount, -1) = isnull(o.OrderDiscountAmount, -1)
		and isnull(f.OrderDiscountPercent, -1) = isnull(o.OrderDiscountPercent, -1)
		and isnull(f.Freight, -1) = isnull(o.Freight, -1)
		and isnull(f.Profit, -1) = isnull(o.Profit, -1)
		and f.CustomerAddressKey = o.CustomerCurrentAddressKey
		and f.DeliveryAddressKey = o.DeliveryAddressKey
		and f.ShipperKey = o.ShipperKey
		and f.SourceKey = o.SourceKey
		and f.CustomerKey = o.CustomerKey
		and f.EmployeeKey = o.EmployeeKey
		and f.ProductKey = o.ProductKey
		and f.ProductHistoryKey = o.ProductHistoryKey
		and f.SupplierKey = o.SupplierKey
		and f.CategoryKey = o.CategoryKey
		and f.OrderDateKey = o.OrderDateKey
		and f.RequiredDateKey = o.RequiredDateKey
		and f.ShippedDateKey = o.ShippedDateKey)

	Insert into FactOrderDetail(OrderKey, OrderDetailKey, ODSOrderID, ODSProductID, OrderDate, RequiredDate, ShippedDate,
		DaysToShip, DaysOverdue, UnitPrice, UnitCost, Quantity, DiscountPercent, PerUnitDiscountAmount,
		LineTotal, LineDiscountAmount, SalesAmount, OrderDiscountAmount, OrderDiscountPercent, Freight,
		Profit, CustomerAddressKey, DeliveryAddressKey, ShipperKey, SourceKey, CustomerKey, EmployeeKey,
		ProductKey, ProductHistoryKey, SupplierKey, CategoryKey, OrderDateKey, RequiredDateKey, ShippedDateKey)
	Select o.OrderKey, o.OrderDetailKey, o.ODSOrderID, o.ODSProductID, o.OrderDate, o.RequiredDate, o.ShippedDate,
		o.DaysToShip, o.DaysOverdue, o.UnitPrice, o.Cost, o.Quantity, o.Discount, o.PerUnitDiscountAmount,
		o.LineTotal, o.LineDiscountAmount, o.SalesAmount, o.OrderDiscountAmount, o.OrderDiscountPercent, o.Freight,
		o.Profit, o.CustomerCurrentAddressKey, o.DeliveryAddressKey, o.ShipperKey, o.SourceKey, o.CustomerKey, o.EmployeeKey,
		o.ProductKey, o.ProductHistoryKey, o.SupplierKey, o.CategoryKey, o.OrderDateKey, o.RequiredDateKey, o.ShippedDateKey
	from #OrderDetails o
	left join FactOrderDetail f
	on f.ODSOrderID = o.ODSOrderID
	and f.ODSProductID = o.ODSProductID
	where f.OrderKey is null
	and f.OrderDetailKey is null

	drop table #OrderDetails
	drop table #NewOrderIDs
end