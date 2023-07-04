BEGIN TRANSACTION

BEGIN TRY

	DECLARE @DBSOURCE nvarchar(50) = 'DB1.dbo';
	DECLARE @DBDESTINATION nvarchar(50) = 'DB2.dbo';
	DECLARE @SQL nvarchar(MAX);

	/*remove contraints related to Contact */
	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact] DROP CONSTRAINT [FK_Contact_Contact]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact] DROP CONSTRAINT [FK_Contact_ContactType]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact] DROP CONSTRAINT [FK_Contact_BDContactType]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact] DROP CONSTRAINT [FK_Contact_ZipCode]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact] DROP CONSTRAINT [FK_Contact_ZipCode1]', '{@DBDESTINATION}', @DBDESTINATION);
	EXEC (@SQL)	


	/*Update the dependent entities*/
	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.ContactType', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	
	
	SET @SQL = REPLACE('SET IDENTITY_INSERT {@DBDESTINATION}.ContactType ON INSERT INTO {@DBDESTINATION}.ContactType ([ContactTypeId], [ContactType])
					SELECT [Contact Type ID],[Contact Type] FROM {@DBSOURCE}.[Contact Type] SET IDENTITY_INSERT {@DBDESTINATION}.ContactType OFF', '{@DBDESTINATION}', @DBDESTINATION);	
	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)	

	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.BDContactType', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	
	
	SET @SQL = REPLACE('SET IDENTITY_INSERT {@DBDESTINATION}.BDContactType ON INSERT INTO {@DBDESTINATION}.BDContactType ([BDContactTypeId], [Name])
					SELECT [ID], [BD Contact Type] FROM {@DBSOURCE}.[BD Contact Type];
					INSERT INTO {@DBDESTINATION}.BDContactType ([BDContactTypeId], [Name]) VALUES (5, ''Unknown'');
					SET IDENTITY_INSERT {@DBDESTINATION}.BDContactType OFF', '{@DBDESTINATION}', @DBDESTINATION);	
	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)

	/*update contacts*/
	SET @SQL = REPLACE('TRUNCATE TABLE {@DBDESTINATION}.Contact', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	
	
	SET @SQL = REPLACE('	
	SET IDENTITY_INSERT {@DBDESTINATION}.Contact ON 
	INSERT INTO {@DBDESTINATION}.Contact ([ContactId],[EntityId],[LastName],[FirstName],[ZipCodeId],[MZipCodeId],
	[AKA],[EmailAddress],[JobTitle],[BusinessPhone],[BusinessExtention],[HomePhone],[MobilePhone],[FaxNumber],[Address],[City],[StateProvince]
	,[MAddress],[MCity],[MState],[ContactTypeId],[ScopeOfWork],[CountryRegion],[WebPage],[Notes],[IDComp],[ResourceType]
	,[MailingAddress],[ContactCompany],[MCCAssociate],[Mark],[BDInitiator],[BDContactTypeId],[MarketRegion],[Active])
	SELECT [Contact ID],[Entity ID],[Last Name],[First Name],ZipCodeTable.[ID] as ZipCodeId,
	MZipCodeTable.ID as MZipCodeId,[AKA],[E-mail Address],[Job Title],[Business Phone],[Business Extention],[Home Phone]
	,[Mobile Phone],[Fax Number],[Address],[City],[State/Province],[MAddress],[MCity],[MState]
	,[Contact Type] as ContactTypeId,[Scope of Work],[Country/Region],[Web Page],[Notes],[IDComp]
	,[Resource Type],[Mailing Address],[Contact Company],[MCC Associate],[Mark],[BD Initiator],[BD Contact Type]
	,[Market Region],[Active]
	FROM {@DBSOURCE}.[Contacts]
	LEFT JOIN (SELECT ID, [ZipCode] FROM {@DBSOURCE}.zip_codes) as ZipCodeTable
	ON {@DBSOURCE}.[Contacts].[ZIP Code] = ZipCodeTable.[ZipCode]
	LEFT JOIN (SELECT ID, [ZipCode] FROM {@DBSOURCE}.zip_codes) as MZipCodeTable
	ON {@DBSOURCE}.[Contacts].[MZip Code] = MZipCodeTable.[ZipCode]
	WHERE [Entity ID] is not null
	ORDER BY [Contact ID] ASC
	SET IDENTITY_INSERT {@DBDESTINATION}.Contact OFF', '{@DBDESTINATION}', @DBDESTINATION);	
	SET @SQL = REPLACE(@SQL, '{@DBSOURCE}', @DBSOURCE);
	EXEC (@SQL)


	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact]  WITH CHECK ADD CONSTRAINT [FK_Contact_ContactType] 
					FOREIGN KEY([ContactTypeId]) REFERENCES {@DBDESTINATION}.[ContactType] ([ContactTypeId]);
					ALTER TABLE {@DBDESTINATION}.[Contact] CHECK CONSTRAINT [FK_Contact_ContactType];','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)	

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_BDContactType] FOREIGN KEY([BDContactTypeId])
						 REFERENCES {@DBDESTINATION}.[BDContactType] ([BDContactTypeId]); 
						 ALTER TABLE {@DBDESTINATION}.[Contact] CHECK CONSTRAINT [FK_Contact_BDContactType]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_ZipCode] FOREIGN KEY([ZipCodeId])
						 REFERENCES {@DBDESTINATION}.[ZipCode] ([ZipCodeId]); 
						 ALTER TABLE {@DBDESTINATION}.[Contact] CHECK CONSTRAINT [FK_Contact_ZipCode]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_ZipCode1] FOREIGN KEY([ZipCodeId])
						 REFERENCES {@DBDESTINATION}.[ZipCode] ([ZipCodeId]); 
						 ALTER TABLE {@DBDESTINATION}.[Contact] CHECK CONSTRAINT [FK_Contact_ZipCode1]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('ALTER TABLE {@DBDESTINATION}.[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_Contact] FOREIGN KEY([ContactId])
						 REFERENCES {@DBDESTINATION}.[Contact] ([ContactId]); 
						 ALTER TABLE {@DBDESTINATION}.[Contact] CHECK CONSTRAINT [FK_Contact_Contact]','{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

	SET @SQL = REPLACE('SELECT * FROM {@DBDESTINATION}.ContactType', '{@DBDESTINATION}', @DBDESTINATION);	
	EXEC (@SQL)

COMMIT TRANSACTION

END TRY

BEGIN CATCH

	ROLLBACK TRANSACTION
	
END CATCH