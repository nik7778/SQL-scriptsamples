BEGIN TRANSACTION
DECLARE @TableName NVARCHAR(50)
DECLARE @Tab1 TABLE(ID INT IDENTITY(1,1), TenantID UNIQUEIDENTIFIER);
DECLARE @TenantNr INT;
DECLARE @RowsNumber INT;
DECLARE @FirstCounter INT;
DECLARE @SecondCounter INT;
DECLARE @Tenant UNIQUEIDENTIFIER;

INSERT INTO @Tab1 (TenantID)
SELECT DISTINCT TenantId from [Call];

SELECT @TenantNr = COUNT(TenantID) FROM @Tab1
SET @FirstCounter=1

WHILE (@FirstCounter <= @TenantNr)
BEGIN
	SELECT @Tenant = TenantID FROM @Tab1 WHERE ID = @FirstCounter
	SELECT @RowsNumber = COUNT(CallId) FROM [Call] WHERE TenantId = @Tenant
	SET @SecondCounter = 1

	WHILE (@SecondCounter <= @RowsNumber)
	BEGIN
		UPDATE [Call] SET [Call].CallNr = @SecondCounter FROM [Call] 
		WHERE CallId = (SELECT TOP 1 CallId FROM [Call] WHERE TenantId = @Tenant AND CallNr = 0 ORDER BY CallId)
		SET @SecondCounter = @SecondCounter + 1
	END
	
    SET @FirstCounter = @FirstCounter  + 1
END

SELECT * FROM [Call] ORDER BY TenantId, CallNr ASC

ROLLBACK TRANSACTION