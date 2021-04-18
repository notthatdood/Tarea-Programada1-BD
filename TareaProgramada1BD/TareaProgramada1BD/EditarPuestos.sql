Create procedure EditarPuestos
	@Id int,
	@Nombre varchar(40),
	@SalarioXHora int

	as
	Begin
		set nocount on;
		Begin try
			Update Puesto
			Set Nombre=@Nombre, SalarioXHora=@SalarioXHora
			Where Id=@Id and Activo='1'
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