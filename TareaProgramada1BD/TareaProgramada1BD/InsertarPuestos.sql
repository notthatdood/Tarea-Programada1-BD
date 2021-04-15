Create procedure InsertarPuestos
	@Id int,
	@Nombre varchar(40),
	@SalarioXHora int

	as

	Insert into Puesto
	Values(@Id, @Nombre, @SalarioXHora,'1')

GO