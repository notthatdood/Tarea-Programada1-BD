Create procedure BorrarEmpleados
	@Id int

	as
	Begin
		set nocount on;
		Begin try
			Update Empleado
			Set Activo='0'
			Where Id=@Id
		End try
		Begin catch
			Insert into DBErrores values (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		End catch

		set nocount off;
	End
GO