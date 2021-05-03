CREATE PROCEDURE InsertarPuestos
	@InPuestoId INT,
	@InPuestoNombre varchar(40),
	@InPuestoSalarioXHora INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SET @OutResultCode=0;
			INSERT INTO Puesto
			VALUES(@InPuestoId, @InPuestoNombre, @InPuestoSalarioXHora,'1')
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

--DECLARE @ResultCode INT
--EXECUTE InsertarPuestos 'Id', 'Nombre', 'SalarioXHora', @ResultCode OUTPUT
--SELECT @ResultCode