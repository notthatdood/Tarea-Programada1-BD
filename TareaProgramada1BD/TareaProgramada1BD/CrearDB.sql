Create database TareaProgramada1
GO

Use TareaProgramada1
GO

Create table Puesto ( Id int,
					  Nombre varchar(40) PRIMARY KEY,
					  SalarioXHora int)
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
						IdDepartamento int, Puesto varchar(40), FechaNacimiento date,
						FOREIGN KEY (IdTipoIdentificacion) REFERENCES TipoDocuIdentidad (Id),
						FOREIGN KEY (Puesto) REFERENCES Puesto (Nombre),
						FOREIGN KEY (IdDepartamento) REFERENCES Departamento (Id))