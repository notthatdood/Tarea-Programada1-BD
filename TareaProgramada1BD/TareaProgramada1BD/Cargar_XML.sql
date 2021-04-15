Create procedure insertarCatalogos as

Insert into Puesto

Select 

A.CatalogoXML.value('@Id','int') as Id,
A.CatalogoXML.value('@Nombre','varchar(40)') as Nombre,
A.CatalogoXML.value('@SalarioXHora','int') as SalarioXHora,
'1' as Activo

From
(
Select cast(CatalogoXML as xml) from
Openrowset(Bulk 'C:\Catalogos.xml', Single_Blob) T(CatalogoXML)
) as S(CatalogoXML)

Cross apply CatalogoXML.nodes('Catalogos/Puestos/Puesto') as A(CatalogoXML)

Insert into TipoDocuIdentidad

Select 

A.CatalogoXML.value('@Id','int') as Id,
A.CatalogoXML.value('@Nombre','varchar(40)') as Nombre
From
(
Select cast(CatalogoXML as xml) from
Openrowset(Bulk 'C:\Catalogos.xml', Single_Blob) T(CatalogoXML)
) as S(CatalogoXML)

Cross apply CatalogoXML.nodes('Catalogos/Tipos_de_Documento_de_Identidad/TipoDocuIdentidad') as A(CatalogoXML)

Insert into Departamento

Select 

A.CatalogoXML.value('@Id','int') as Id,
A.CatalogoXML.value('@Nombre','varchar(40)') as Nombre
From
(
Select cast(CatalogoXML as xml) from
Openrowset(Bulk 'C:\Catalogos.xml', Single_Blob) T(CatalogoXML)
) as S(CatalogoXML)

Cross apply CatalogoXML.nodes('Catalogos/Departamentos/Departamento') as A(CatalogoXML)
GO

Create procedure insertarEmpleado as

Insert into Empleado

Select 

A.EmpleadoXML.value('@Nombre','varchar(30)') as Nombre,
A.EmpleadoXML.value('@IdTipoIdentificacion','int') as IdTipoIdentificacion,
A.EmpleadoXML.value('@ValorDocumentoIdentifacion','int') as ValorDocumentoIdentifacion,
A.EmpleadoXML.value('@IdDepartamento','int') as IdDepartamento,
A.EmpleadoXML.value('@Puesto','varchar(40)') as Puesto,
A.EmpleadoXML.value('@FechaNacimiento','date') as FechaNacimiento,
'1' as Activo
From
(
Select cast(EmpleadosXML as xml) from
Openrowset(Bulk 'C:\NoCatalogos.xml', Single_Blob) T(EmpleadosXML)
) as S(EmpleadosXML)

Cross apply EmpleadosXML.nodes('Empleados/Empleado') as A(EmpleadoXML)

GO

Execute insertarCatalogos
Execute insertarEmpleado