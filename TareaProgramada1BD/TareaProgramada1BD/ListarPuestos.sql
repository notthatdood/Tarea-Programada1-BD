Create procedure ListarPuestos as

	Select * from Puesto where Activo=1 order by Nombre

GO