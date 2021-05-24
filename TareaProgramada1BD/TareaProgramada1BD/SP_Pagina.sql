USE TareaProgramada
GO

CREATE PROCEDURE ListarUsuarios

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT Id,Username,Pwd FROM Empleado WHERE Empleado.Activo=1
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
		END CATCH
		SET NOCOUNT OFF;
	END

--EXECUTE ListarDepartamento
GO

---Recibe el Id del empleado, y devuelve los campos solicitados además del ID de
--PlanillaMensualXEmpleado, este no se muestra, solo se necesita para consultar en ListarDeduccionesMes
CREATE PROCEDURE ListarMes
	@InIdEmpleado INT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			DECLARE @TotalDeducciones INT;
			SELECT
				@TotalDeducciones=SUM(DEM.TotalDeducciones)
			FROM
				DeduccionXEmpleadoXMes DEM, PlanillaMensualXEmpleado PMXE
			WHERE
				DEM.IdPlanillaMensualXEmpleado=PMXE.Id AND PMXE.IdEmpleado=@InIdEmpleado;
			

			SELECT TOP 12
				PMXE.Id, PMXE.IdMes, PMXE.SalarioTotal, PMXE.SalarioNeto
			FROM
				PlanillaMensualXEmpleado PMXE, Empleado E
			WHERE
				PMXE.IdEmpleado=@InIdEmpleado AND E.Id=@InIdEmpleado AND E.Activo=1;
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
		
		END CATCH
		SET NOCOUNT OFF;
	END
GO

--EXECUTE ListarMes '7'

---Recibe el Id de la PlanillaMensualXEmpleado, y devuelve el nombre de la deduccion, el valor(Si no
--es porcentual será 0), si es porcentual y el monto que dedujo
CREATE PROCEDURE ListarDeduccionesMes
	@InIdPlanillaMensualXEmpleado INT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				TD.Nombre, TD.Valor, TD.Porcentual, DEM.TotalDeducciones
			FROM
				TipoDeduccion TD, DeduccionXEmpleadoXMes DEM
			WHERE
				DEM.IdTipoDeduccion=TD.Id AND DEM.IdPlanillaMensualXEmpleado=@InIdPlanillaMensualXEmpleado
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
		
		END CATCH
		SET NOCOUNT OFF;
	END
GO

--EXECUTE ListarDeduccionesMes '17'

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