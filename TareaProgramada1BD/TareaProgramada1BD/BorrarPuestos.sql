Create procedure BorrarPuestos
	@Nombre varchar(40)

	as
	Begin
		set nocount on;
		Begin try
			Update Puesto
			Set Activo='0'
			Where Nombre=@Nombre
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