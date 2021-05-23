--SELECT EOMONTH( @mydate, -1 ) Último del mes anterior
--SELECT EOMONTH( '2021-02-04') Último del mes
--SELECT EOMONTH( @mydate, 1 ) Último del mes siguiente
--SELECT DATEADD(d,1,EOMONTH(getdate(),-1)) Primero del mes actual
--SELECT DATEDIFF(day, '2036-03-01', '2036-02-28') Diferencia de dos fechas en días

USE TareaProgramada
GO

CREATE PROCEDURE InsertarMes
	@InFechaInicio DATE,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0;
			DECLARE
				@InFechaFinal DATE,
				@InFechaTemporal DATE,
				@Bandera BIT;
			SELECT
				@InFechaFinal=DATEADD(DAY,7,@InFechaInicio),  @InFechaTemporal=EOMONTH(@InFechaFinal), @Bandera='0';
				--@FechaFinal=DATEADD(DAY,7,'2021-02-04'), @FechaTemporal=EOMONTH(@FechaFinal), @Bandera='0';
			WHILE(@Bandera='0') BEGIN
			--PRINT(@FechaFinal)
				IF(@InFechaFinal>@InFechaTemporal) BEGIN
					SELECT
						@InFechaFinal=DATEADD(DAY,-1,@InFechaFinal),
						@Bandera='1';
				END
				IF(@Bandera='0') BEGIN
					SELECT
						@InFechaFinal=DATEADD(DAY,7,@InFechaFinal);
				END
			END
			--PRINT(@InFechaFinal)
			INSERT INTO PlanillaMensual VALUES (@InFechaInicio, @InFechaFinal);
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

CREATE PROCEDURE AsociarEmpleadoConMes
	@InPuestoId INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

/*DECLARE @ResultCode INT
EXECUTE InsertarMes '2021-02-05', @ResultCode OUTPUT
SELECT @ResultCode
SELECT * FROM PlanillaMensual*/

CREATE PROCEDURE InsertarSemana
	@InIdMes INT,
	@InFechaInicio DATE,
	@OutIdSemana INT OUTPUT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0;
			DECLARE
				@InFechaFinal DATE,
				@InFechaTemporal DATE,
				@Bandera BIT;
			SELECT
				@InFechaFinal=DATEADD(DAY,7,@InFechaInicio),  @InFechaTemporal=EOMONTH(@InFechaFinal), @Bandera='0';
				--@FechaFinal=DATEADD(DAY,7,'2021-02-04'), @FechaTemporal=EOMONTH(@FechaFinal), @Bandera='0';
			--PRINT(@InFechaFinal)
			INSERT INTO PlanillaSemanal VALUES (@InIdMes, @InFechaInicio, @InFechaFinal);
			SELECT TOP 1
				@OutIdSemana=PS.Id
			FROM
				PlanillaSemanal PS
			ORDER BY PS.Id DESC;
			--PRINT(@OutIdSemana)
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

CREATE PROCEDURE InsertarEmpleados
	@InEmpleadoNombre VARCHAR(50),
	@InEmpleadoIdTipoIdentificacion INT,
	@InEmpleadoValorDocumentoIdentificacion INT,
	@InEmpleadoFechaNacimiento DATE,
	@InEmpleadoIdPuesto INT,
	@InEmpleadoIdDepartamento INT,
	@InEmpleadoUsername VARCHAR(30),
	@InEmpleadoPwd VARCHAR(30),
	@OutResultCode INT OUTPUT
	
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			INSERT INTO Empleado
			VALUES(@InEmpleadoNombre, @InEmpleadoIdTipoIdentificacion, @InEmpleadoValorDocumentoIdentificacion,
			@InEmpleadoIdDepartamento, @InEmpleadoIdPuesto, @InEmpleadoFechaNacimiento, @InEmpleadoUsername,
			@InEmpleadoPwd,'1')
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO
--DECLARE @ResultCode INT
--EXECUTE InsertarEmpleado 'Nombre', 'TipoIdentificacion',
--'ValorDocIdentificacion', 'FechaNacimiento', 'IdPuesto', 'IdDepartamento', @ResultCode OUTPUT
--SELECT @ResultCode

CREATE PROCEDURE InsertarJornada
	@InIdJornada INT,
	@InValorDocumentoIdentificacion INT,
	@InIdSemana INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			DECLARE @IdEmpleado INT;
			SELECT @IdEmpleado=E.Id FROM Empleado E WHERE E.ValorDocumentoIdentificacion=@InValorDocumentoIdentificacion;
			--PRINT(@IdEmpleado)
			INSERT INTO Jornada VALUES(@IdEmpleado, @InIdJornada, @InIdSemana);
			
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

CREATE PROCEDURE MarcarAsistencia
	@InFechaEntrada DATETIME,
	@InFechaSalida DATETIME,
	@InValorDocumentoIdentidad INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			DECLARE @IdJornada INT;
			SELECT @IdJornada=J.Id FROM Empleado E, Jornada J
			WHERE E.ValorDocumentoIdentificacion=@InValorDocumentoIdentidad
			AND E.Id=J.IdEmpleado;
			--PRINT(@IdJornada)
			INSERT INTO MarcaAsistencia VALUES(@IdJornada, @InFechaEntrada, @InFechaSalida);
			
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

/*DECLARE @ResultCode INT
EXECUTE MarcarAsistencia '2021-02-05 03:37 PM', '2021-02-05 11:39 PM',
'71731275', @ResultCode OUTPUT
SELECT @ResultCode*/

CREATE PROCEDURE AsociarEmpleadoConFijaNoObligatoria
	@InIdDeduccion INT,
	@InMonto INT,
	@InValorDocumentoIdentificacion INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			DECLARE @IdDeduccionXEmpleado INT;
			BEGIN TRANSACTION AsociarDeduccion
			INSERT INTO DeduccionXEmpleado SELECT E.Id, TD.Id
			FROM Empleado E, TipoDeduccion TD WHERE TD.Id=@InIdDeduccion AND
			E.ValorDocumentoIdentificacion=@InValorDocumentoIdentificacion;
			SELECT TOP 1 @IdDeduccionXEmpleado=DXE.Id FROM DeduccionXEmpleado DXE ORDER BY DXE.Id DESC;
			INSERT INTO FijaNoObligatoria VALUES(@IdDeduccionXEmpleado, @InMonto);
			COMMIT TRANSACTION AsociarDeduccion;
		END TRY
		BEGIN CATCH
			IF @@Trancount>0 
				ROLLBACK TRANSACTION AsociarDeduccion;
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO

/*DECLARE @ResultCode INT
EXECUTE AsociarEmpleadoConFijaNoObligatoria'2', '10000','15442171', @ResultCode OUTPUT
SELECT @ResultCode*/

/*CREATE PROCEDURE name
	@InPuestoId INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			
		END TRY
		BEGIN CATCH
			INSERT INTO DBErrores VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
			)
		
			SET @OutResultCode=50005;
		END CATCH
		SET NOCOUNT OFF;
	END
GO*/