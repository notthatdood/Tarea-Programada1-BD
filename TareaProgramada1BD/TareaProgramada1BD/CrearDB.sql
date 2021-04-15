Create database TareaProgramada
GO

Use TareaProgramada
GO

Create table Puesto ( Id int,
					  Nombre varchar(40) PRIMARY KEY,
					  SalarioXHora int,
					  Activo bit)
GO

Create table Departamento ( Id int PRIMARY KEY,
							Nombre varchar(40))
GO

Create table TipoDocuIdentidad ( Id int PRIMARY KEY,
								 Nombre varchar(40))
GO

Create table Empleado ( Id int IDENTITY(1,1) PRIMARY KEY,
					    Nombre varchar(50),
					    IdTipoIdentificacion int,
						ValorDocumentoIdentificacion int, 
						IdDepartamento int, Puesto varchar(40),
						FechaNacimiento date, Activo bit,
						FOREIGN KEY (IdTipoIdentificacion) REFERENCES TipoDocuIdentidad (Id),
						FOREIGN KEY (Puesto) REFERENCES Puesto (Nombre),
						FOREIGN KEY (IdDepartamento) REFERENCES Departamento (Id))