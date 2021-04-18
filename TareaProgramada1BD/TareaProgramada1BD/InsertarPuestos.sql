Create procedure InsertarPuestos
	@Id int,
	@Nombre varchar(40),
	@SalarioXHora int

	as
	Begin
		set nocount on;
		Begin try
			Insert into Puesto
			Values(@Id, @Nombre, @SalarioXHora,'1')
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