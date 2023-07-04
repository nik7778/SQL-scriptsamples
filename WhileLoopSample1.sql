BEGIN TRANSACTION
DECLARE @TableName NVARCHAR(50)
DECLARE @Tab1 TABLE(ID INT IDENTITY(1,1), TenantID UNIQUEIDENTIFIER);
DECLARE @TenantNr INT;
DECLARE @RowsNumber INT;
DECLARE @FirstCounter INT;
DECLARE @SecondCounter INT;
DECLARE @Tenant UNIQUEIDENTIFIER;

INSERT INTO @Tab1 (TenantID)
SELECT DISTINCT TenantId from Customer;

SELECT @TenantNr = COUNT(TenantID) FROM @Tab1
SET @FirstCounter=1


WHILE (@FirstCounter <= @TenantNr)
BEGIN
	SELECT @Tenant = TenantID FROM @Tab1 WHERE ID = @FirstCounter
	SELECT @RowsNumber = COUNT(CustomerId) FROM Customer WHERE TenantId = @Tenant
	SET @SecondCounter = 1

	WHILE (@SecondCounter <= @RowsNumber)
	BEGIN
		UPDATE Customer SET Customer.CustomerNr = @SecondCounter FROM Customer
		WHERE CustomerId = (SELECT TOP 1 CustomerId FROM [Customer] WHERE TenantId = @Tenant AND CustomerNr = 0 ORDER BY CustomerId)
		SET @SecondCounter = @SecondCounter + 1
	END
	
    SET @FirstCounter = @FirstCounter  + 1
END

SELECT * FROM Customer ORDER BY TenantId, CustomerNr ASC

ROLLBACK TRANSACTION