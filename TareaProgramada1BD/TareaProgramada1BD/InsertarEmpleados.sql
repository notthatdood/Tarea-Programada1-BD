Create procedure InsertarEmpleados
	@Nombre varchar(50),
	@IdTipoIdentificacion int,
	@ValorDocumentoIdentificacion int,
	@IdDepartamento int,
	@Puesto varchar(40),
	@FechaNacimiento date
	
	as
	Begin
		set nocount on;
		Begin try
			Insert into Empleado
			Values(@Nombre, @IdTipoIdentificacion, @ValorDocumentoIdentificacion,
			@IdDepartamento, @Puesto, @FechaNacimiento, '1')
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