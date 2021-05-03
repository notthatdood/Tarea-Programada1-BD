CREATE PROCEDURE EditarPuestos
	@InPuestoId INT,
	@InPuestoNombre varchar(40),
	@InPuestoSalarioXHora INT,
	@OutResultCode INT OUTPUT

	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			SELECT
				@OutResultCode=0;
			IF NOT EXISTS(SELECT 1 FROM Puesto C WHERE C.Id=@InPuestoId)
			OR EXISTS(SELECT 1 FROM Puesto C WHERE C.Id=@InPuestoId AND Activo='0')
				BEGIN
					Set @OutResultCode=50001; --El puesto no existe
					RETURN
				END;
			UPDATE Puesto
			SET Nombre=@InPuestoNombre, SalarioXHora=@InPuestoSalarioXHora
			WHERE Id=@InPuestoId and Activo='1'
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
--EXECUTE EditarPuestos 'Id', 'Nombre', 'SalarioXHora', @ResultCode OUTPUT
--SELECT @ResultCode