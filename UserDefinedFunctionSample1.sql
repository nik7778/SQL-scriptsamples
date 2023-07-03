USE [MKI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[GetStringVariableFromTable]
(	
   @xmlFile xml
)
RETURNS varchar(max)
AS
BEGIN

DECLARE @setOfIds varchar(max);

	SELECT @setOfIds = tb.IdCollection FROM (Select distinct 
		substring(
			(
				Select ',' + cast(ST1.ID as varchar(100))  AS [text()]
				From (SELECT * FROM [dbo].[ReadXml] (@xmlFile)) ST1
				For XML PATH ('')
			), 2, 1000) [IdCollection]
	From (SELECT * FROM [dbo].[ReadXml] (@xmlFile)) Main) tb

RETURN @setOfIds
END

