Create procedure InsertarEmpleados
	@Nombre varchar(50),
	@IdTipoIdentificacion int,
	@ValorDocumentoIdentificacion int,
	@IdDepartamento int,
	@Puesto varchar(40),
	@FechaNacimiento date
	

	as

	Insert into Empleado
	Values(@Nombre, @IdTipoIdentificacion, @ValorDocumentoIdentificacion,
	@IdDepartamento, @Puesto, @FechaNacimiento, '1')

GO