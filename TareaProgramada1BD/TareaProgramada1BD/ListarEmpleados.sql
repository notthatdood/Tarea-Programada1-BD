Create procedure ListarEmpleados as

	Select Nombre,Puesto from Empleado where Activo=1 order by Nombre

GO