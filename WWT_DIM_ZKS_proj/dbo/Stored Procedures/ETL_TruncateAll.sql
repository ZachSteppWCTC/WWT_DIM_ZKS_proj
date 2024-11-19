
/**************************
* Procedure ETL_TruncateAll
* Author: zstepp
* Create Date: 11/5/2024
* 
* Deletes records from all tables and reseeds identity columns.
* Effectively does what truncate does, but I found this to work better when Foreign Keys are preventing execution.
*
**************************/
Create   procedure ETL_TruncateAll
as
begin
	-- Disable constraints
	Exec sp_MSforeachtable "Alter Table ? Nocheck Constraint all"
	-- Delete all from all tables
	Exec sp_MSforeachtable "Delete from ?"
	-- Enable constraints
	Exec sp_MSforeachtable @command1="print '?'", @command2="Alter Table ? with check check Constraint all"
	-- Reseed identity columns
	Exec sp_MSforeachtable "DBCC CHECKIDENT ( '?', RESEED, 0)"
end

/**************************
Run Code

Initial Executions: 
EXEC ETL_Control 1

Subsequent Executions:
EXEC ETL_Control

Clear All Tables if Needed:
EXEC ETL_TruncateAll

**************************/