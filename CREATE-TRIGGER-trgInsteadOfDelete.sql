CREATE TRIGGER trgInsteadOfDelete ON [dbo].[Employee_Test] 
INSTEAD OF DELETE
AS
	declare @emp_id int;
	declare @emp_name varchar(100);
	declare @emp_sal int;
	
	select @emp_id=d.Emp_ID from deleted d;
	select @emp_name=d.Emp_Name from deleted d;
	select @emp_sal=d.Emp_Sal from deleted d;

	BEGIN
		if(@emp_sal>1200)
		begin
			RAISERROR('Cannot delete where salary > 1200',16,1);
			ROLLBACK;
		end
		else
		begin
			delete from Employee_Test where Emp_ID=@emp_id;
			COMMIT;
			insert into Employee_Test_Audit(Emp_ID,Emp_Name,Emp_Sal,Audit_Action,Audit_Timestamp)
			values(@emp_id,@emp_name,@emp_sal,'Deleted -- Instead Of Delete Trigger.',getdate());
			PRINT 'Record Deleted -- Instead Of Delete Trigger.'
		end
	END
GO