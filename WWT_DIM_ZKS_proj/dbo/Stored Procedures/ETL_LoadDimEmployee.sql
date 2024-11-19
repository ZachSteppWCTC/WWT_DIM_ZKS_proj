
/**************************
* Procedure ETL_LoadDimEmployee
* Author: zstepp
* Create Date: 11/1/2024
* 
* Loads ODS Employees to Dimensional Table
* Inserts and Updates
*
**************************/
Create   procedure ETL_LoadDimEmployee
as
begin
	update DimEmployees
	set EmployeeFirstName = e.FirstName,
	EmployeeLastName = e.LastName,
	EmployeeFullName = CONCAT(e.FirstName, ' ', e.LastName),
	EmployeeJobTitle = e.JobTitle,
	EmployeeTitle = e.Title,
	EmployeeBirthDate = e.BirthDate,
	HireDate = e.HireDate,
	TerminationDate = e.TerminationDate,
	IsActive = e.isActive,
	ManagerFullName = CONCAT(m.FirstName, ' ', m.LastName)
	from WWT_ODS_ZKS.dbo.Employees e
	join WWT_ODS_ZKS.dbo.Employees m
	on e.ReportsTo = m.ODSEmployeeID
	join DimEmployees de
	on de.ODSEmployeeID = e.ODSEmployeeID
	where not (
		isnull(de.EmployeeFirstName, '') = isnull(e.FirstName, '')
		and isnull(de.EmployeeLastName, '') = isnull(e.LastName, '')
		and isnull(de.EmployeeFullName, '') = isnull(CONCAT(e.FirstName, ' ', e.LastName), '')
		and isnull(de.EmployeeJobTitle, '') = isnull(e.JobTitle, '')
		and isnull(de.EmployeeTitle, '') = isnull(e.Title, '')
		and isnull(de.EmployeeBirthDate, '') = isnull(e.BirthDate, '')
		and isnull(de.HireDate, '') = isnull(e.HireDate, '')
		and isnull(de.TerminationDate, '') = isnull(e.TerminationDate, '')
		and isnull(de.IsActive, '') = isnull(e.isActive, '')
		and isnull(de.ManagerFullName, '') = isnull(CONCAT(m.FirstName, ' ', m.LastName), '')
	)

	Insert into DimEmployees(ODSEmployeeID, EmployeeFirstName, EmployeeLastName, EmployeeFullName, EmployeeJobTitle, EmployeeTitle, EmployeeBirthDate, HireDate, TerminationDate, IsActive, ManagerFullName)
	Select
	e.ODSEmployeeID,
	e.FirstName,
	e.LastName, 
	CONCAT(e.FirstName, ' ' , e.LastName),
	e.JobTitle,
	e.Title,
	e.BirthDate,
	e.HireDate,
	e.TerminationDate,
	e.isActive,
	CONCAT(m.FirstName, ' ' , m.LastName)
	from WWT_ODS_ZKS.dbo.Employees e
	left join WWT_ODS_ZKS.dbo.Employees m
	on e.ReportsTo = m.ODSEmployeeID
	left join DimEmployees de
	on e.ODSEmployeeID = de.ODSEmployeeID
	where de.EmployeeKey is null
end
