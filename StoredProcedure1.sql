USE [MKI]
GO
/****** Object:  StoredProcedure [dbo].[KPICR_Finance_CR_List_GET]    Script Date: 7/21/2014 5:12:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Finance_CR_List]
	@Table CRSelectedTableType READONLY
AS
BEGIN

	select
		CR.[NumeroCR]		as CR
		, CR_KPI.Cost		as Cost
		, CR_KPI.[Time]		as [Time]
		, CAST(
				CASE
					WHEN CR_KPI.CostRank > 3 AND CR_KPI.TimeRank > 3
					THEN 1
					ELSE 0
				END
				AS BIT
		)				AS [STARS]
		, CAST(
				CASE
					WHEN CR_KPI.CostRank <= 3 AND CR_KPI.TimeRank > 3
					THEN 1
					ELSE 0
				END
				AS BIT
		)				AS [CASHHOOVERS]
		, CAST(
				CASE
					WHEN CR_KPI.CostRank > 3 AND CR_KPI.TimeRank <= 3
					THEN 1
					ELSE 0
				END
				AS BIT
		)				AS [SLOWMOVERS]
		, CAST(
				CASE
					WHEN CR_KPI.CostRank <= 3 AND CR_KPI.TimeRank <= 3
					THEN 1
					ELSE 0
				END
				AS BIT
		)				AS [BLACKHOLES]
		
	from CR_KPI CR_KPI
	inner join CR CR on CR.ID = CR_KPI.ID
	INNER JOIN @Table AS T ON CR_KPI.ID = T.ID
	where 1=1
	and CR_KPI.Cost		is not null
	and CR_KPI.[Time]	is not null

END
	
