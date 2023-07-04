BEGIN TRANSACTION

BEGIN TRY
	
	DECLARE @DBSOURCE nvarchar(50) = 'DB1.dbo';
	DECLARE @DBDESTINATION nvarchar(50) = 'DB2.dbo';
	DECLARE @SQL nvarchar(MAX);

	/*removing foreign key references for Company*/
	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company] DROP CONSTRAINT [FK_Company_CompanyType]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company] DROP CONSTRAINT [FK_Company_BDType]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company] DROP CONSTRAINT [FK_Company_MarketSegment]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company] DROP CONSTRAINT [FK_Company_Entity]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Entity] DROP CONSTRAINT [FK_Entity_Company]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	
		
	/*Delete and Update data for MarketSegment, CompanyType*/
	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.CompanyType', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	

	SET @SQL = REPLACE('SET IDENTITY_INSERT {@DBDESTINATION}.CompanyType ON INSERT INTO {@DBDESTINATION}.CompanyType ([CompanyTypeId], [CompanyType])
					SELECT [ID], [Company Type] FROM {@DBSOURCE}.[Company Types];					
					INSERT INTO {@DBDESTINATION}.CompanyType ([CompanyTypeId], [CompanyType]) VALUES (5, ''Type'')
					SET IDENTITY_INSERT {@DBDESTINATION}.CompanyType OFF', '{@DBDESTINATION}', @DBDESTINATION);	
	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)	

	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.MarketSegment', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	
	
	SET @SQL = REPLACE('INSERT INTO {@DBDESTINATION}.MarketSegment ([Name])
					SELECT DISTINCT [Market Segment] FROM {@DBSOURCE}.[Company] WHERE [Market Segment] is not NULL ORDER BY [Market Segment]', '{@DBDESTINATION}', @DBDESTINATION);	
	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)

	/*DELETE data from Company table, after that Update it*/
	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.Company', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	

	SET @SQL = REPLACE('
	SELECT DISTINCT [Market Segment] INTO #TempMarketSegment
	FROM {@DBSOURCE}.[Company] WHERE [Market Segment] is not NULL

	SELECT DISTINCT [BD Type] INTO #TempBDType
	FROM {@DBSOURCE}.[Company] WHERE [BD Type] is not NULL 

	SET IDENTITY_INSERT {@DBDESTINATION}.Company ON 	
	INSERT INTO {@DBDESTINATION}.Company ([CompanyId],[EntityId],[MarketSegmentId],
	[BDTypeId],[CompanyName],[CompanyTypeId],[WebPage],[Notes],[IDComp],[Mark])
	SELECT [Company ID],[Entity ID], MarketSegmentTable.ID as MarketSegmentId,BDTypeTable.ID as BDTypeId,[Company Name],[Company Type],
	[Web Page],[Notes],[IDComp],[Mark] FROM {@DBSOURCE}.[Company]
	LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY [Market Segment] ASC) as ID, [Market Segment] FROM #TempMarketSegment) as MarketSegmentTable
	ON {@DBSOURCE}.[Company].[Market Segment] = MarketSegmentTable.[Market Segment] 
	LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY [BD Type] ASC) as ID, [BD Type] FROM #TempBDType) as BDTypeTable
	ON {@DBSOURCE}.[Company].[BD Type] = BDTypeTable.[BD Type]
	SET IDENTITY_INSERT {@DBDESTINATION}.Company OFF 

	DROP TABLE #TempMarketSegment 
	DROP TABLE #TempBDType', '{@DBDESTINATION}', @DBDESTINATION);	

	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)	

	/*adding back foreign keys for Copmany*/
	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_CompanyType] FOREIGN KEY([CompanyTypeId])
						 REFERENCES {@DBDESTINATION}.[CompanyType] ([CompanyTypeId]); 
						 ALTER TABLE {@DBDESTINATION}.[Company] CHECK CONSTRAINT [FK_Company_CompanyType]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company] WITH CHECK ADD  CONSTRAINT [FK_Company_BDType] FOREIGN KEY([BDTypeId])
						REFERENCES {@DBDESTINATION}.[BDType] ([BDTypeId]); 
						ALTER TABLE {@DBDESTINATION}.[Company] CHECK CONSTRAINT [FK_Company_BDType]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_MarketSegment] FOREIGN KEY([MarketSegmentId])
						 REFERENCES {@DBDESTINATION}.[MarketSegment] ([MarketSegmentId]); 
						 ALTER TABLE {@DBDESTINATION}.[Company] CHECK CONSTRAINT [FK_Company_MarketSegment]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Company]  WITH CHECK ADD  CONSTRAINT [FK_Company_Entity] FOREIGN KEY([EntityId])
						 REFERENCES {@DBDESTINATION}.[Entity] ([EntityId]); 
						 ALTER TABLE {@DBDESTINATION}.[Company] CHECK CONSTRAINT [FK_Company_Entity]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_Company] FOREIGN KEY([CompanyId])
						 REFERENCES {@DBDESTINATION}.[Company] ([CompanyId]); 
						 ALTER TABLE {@DBDESTINATION}.[Entity] CHECK CONSTRAINT [FK_Entity_Company]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('SELECT * FROM {@DBDESTINATION}.Company', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)
	
COMMIT TRANSACTION

END TRY

BEGIN CATCH

	ROLLBACK TRANSACTION
	
END CATCH