USE [MKI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[ReadXml] 
(
   @xmlFile xml
)
RETURNS @Table Table (ID varchar(max)) 
BEGIN 
	INSERT INTO @Table 
	SELECT t.c.value('.', 'VARCHAR(100)') ID FROM @xmlFile.nodes('IdCollection/*') t(c)
RETURN 
END 
