Create procedure EditarEmpleados
	@Id int,
	@Nombre varchar(50),
	@IdTipoIdentificacion int,
	@ValorDocumentoIdentificacion int,
	@FechaNacimiento date,
	@Puesto varchar(40),
	@IdDepartamento int

	as
	Begin
		set nocount on;
		Begin try
			Update Empleado
			Set Nombre=@Nombre, IdTipoIdentificacion=@IdTipoIdentificacion,
			ValorDocumentoIdentificacion=@ValorDocumentoIdentificacion, FechaNacimiento=@FechaNacimiento,
			Puesto=@Puesto, IdDepartamento=@IdDepartamento
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