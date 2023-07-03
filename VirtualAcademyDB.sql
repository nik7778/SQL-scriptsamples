-- --------------------------------------------------
-- Sample of Data Base script generator
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [VirtualAcademy];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_Bill_Account]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Bills] DROP CONSTRAINT [FK_Bill_Account];
GO
IF OBJECT_ID(N'[dbo].[FK_Coupon_CourseCategory]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Coupons] DROP CONSTRAINT [FK_Coupon_CourseCategory];
GO
IF OBJECT_ID(N'[dbo].[FK_CourseBoard_CourseCategory]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Courses] DROP CONSTRAINT [FK_CourseBoard_CourseCategory];
GO
IF OBJECT_ID(N'[dbo].[FK_CourseFilePaths_Courses]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CourseFilePaths] DROP CONSTRAINT [FK_CourseFilePaths_Courses];
GO
IF OBJECT_ID(N'[dbo].[FK_Courses_Accounts]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Courses] DROP CONSTRAINT [FK_Courses_Accounts];
GO
IF OBJECT_ID(N'[dbo].[FK_FilePaths_Services]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ServiceFilePaths] DROP CONSTRAINT [FK_FilePaths_Services];
GO
IF OBJECT_ID(N'[dbo].[FK_Price_CourseCategory]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Prices] DROP CONSTRAINT [FK_Price_CourseCategory];
GO
IF OBJECT_ID(N'[dbo].[FK_ResourceFilePaths_Resources]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ResourceFilePaths] DROP CONSTRAINT [FK_ResourceFilePaths_Resources];
GO
IF OBJECT_ID(N'[dbo].[FK_Resources_Account]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Resources] DROP CONSTRAINT [FK_Resources_Account];
GO
IF OBJECT_ID(N'[dbo].[FK_Resources_ResourceCategory]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Resources] DROP CONSTRAINT [FK_Resources_ResourceCategory];
GO
IF OBJECT_ID(N'[dbo].[FK_Services_Account]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Services] DROP CONSTRAINT [FK_Services_Account];
GO
IF OBJECT_ID(N'[dbo].[FK_Services_ServiceCategories]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Services] DROP CONSTRAINT [FK_Services_ServiceCategories];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Accounts]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Accounts];
GO
IF OBJECT_ID(N'[dbo].[Bills]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Bills];
GO
IF OBJECT_ID(N'[dbo].[Coupons]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Coupons];
GO
IF OBJECT_ID(N'[dbo].[CourseCategories]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CourseCategories];
GO
IF OBJECT_ID(N'[dbo].[CourseFilePaths]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CourseFilePaths];
GO
IF OBJECT_ID(N'[dbo].[Courses]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Courses];
GO
IF OBJECT_ID(N'[dbo].[Prices]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Prices];
GO
IF OBJECT_ID(N'[dbo].[ResourceCategories]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ResourceCategories];
GO
IF OBJECT_ID(N'[dbo].[ResourceFilePaths]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ResourceFilePaths];
GO
IF OBJECT_ID(N'[dbo].[Resources]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Resources];
GO
IF OBJECT_ID(N'[dbo].[ServiceCategories]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ServiceCategories];
GO
IF OBJECT_ID(N'[dbo].[ServiceFilePaths]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ServiceFilePaths];
GO
IF OBJECT_ID(N'[dbo].[Services]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Services];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Accounts'
CREATE TABLE [dbo].[Accounts] (
    [AccountId] int IDENTITY(1,1) NOT NULL,
    [Email] nvarchar(250)  NOT NULL,
    [EmailConfirmed] bit  NOT NULL,
    [PasswordHash] nvarchar(max)  NOT NULL,
    [LoginEndDateUtc] datetime  NULL,
    [AccsessFailedCount] int  NULL,
    [UserName] nvarchar(250)  NULL,
    [VerificationGuid] nvarchar(max)  NULL,
    [RegistrationDate] datetime  NULL,
    [Status] int  NULL,
    [Terms] bit  NULL
);
GO

-- Creating table 'Bills'
CREATE TABLE [dbo].[Bills] (
    [BillId] int IDENTITY(1,1) NOT NULL,
    [PaymentNr] nvarchar(max)  NOT NULL,
    [Amount] decimal(18,0)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [StartDate] datetime  NULL,
    [EndDate] datetime  NULL,
    [PayerEmail] nvarchar(200)  NOT NULL,
    [AccountFk] int  NOT NULL,
    [CourseId] int  NULL,
    [CategoryId] int  NULL,
    [Paid] bit  NOT NULL,
    [Perioud] int  NULL,
    [ServiceId] int  NULL
);
GO

-- Creating table 'Coupons'
CREATE TABLE [dbo].[Coupons] (
    [CouponId] int IDENTITY(1,1) NOT NULL,
    [CouponNr] nvarchar(50)  NOT NULL,
    [CourseFk] int  NOT NULL,
    [Used] bit  NOT NULL
);
GO

-- Creating table 'CourseCategories'
CREATE TABLE [dbo].[CourseCategories] (
    [CategoryId] int IDENTITY(1,1) NOT NULL,
    [CourseName] nvarchar(500)  NOT NULL
);
GO

-- Creating table 'Prices'
CREATE TABLE [dbo].[Prices] (
    [PriceId] int IDENTITY(1,1) NOT NULL,
    [Value] decimal(18,0)  NOT NULL,
    [Discount] bit  NOT NULL,
    [CourseCategoryFk] int  NOT NULL
);
GO

-- Creating table 'ResourceCategories'
CREATE TABLE [dbo].[ResourceCategories] (
    [ResourceCategoryId] int IDENTITY(1,1) NOT NULL,
    [ResourceName] nvarchar(100)  NOT NULL
);
GO

-- Creating table 'ResourceFilePaths'
CREATE TABLE [dbo].[ResourceFilePaths] (
    [FilePathId] int IDENTITY(1,1) NOT NULL,
    [FileName] nvarchar(max)  NOT NULL,
    [FileType] varchar(50)  NOT NULL,
    [ResourceFk] int  NOT NULL
);
GO

-- Creating table 'Resources'
CREATE TABLE [dbo].[Resources] (
    [ResourceId] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(100)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [Price] decimal(18,0)  NOT NULL,
    [Date] datetime  NOT NULL,
    [Status] int  NOT NULL,
    [ResourceCategoryFk] int  NOT NULL,
    [AccountFk] int  NOT NULL,
    [Path] nvarchar(max)  NOT NULL,
    [NrDownloads] int  NULL
);
GO

-- Creating table 'ServiceCategories'
CREATE TABLE [dbo].[ServiceCategories] (
    [ServiceCategoryId] int IDENTITY(1,1) NOT NULL,
    [CategoryName] nvarchar(250)  NOT NULL
);
GO

-- Creating table 'Services'
CREATE TABLE [dbo].[Services] (
    [ServiceId] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [Details] nvarchar(max)  NOT NULL,
    [BasicOption1] nvarchar(max)  NULL,
    [StandardOption1] nvarchar(max)  NULL,
    [PremiumOption1] nvarchar(max)  NULL,
    [BasicPrice] decimal(18,0)  NULL,
    [StandardPrice] decimal(18,0)  NULL,
    [PremiumPrice] decimal(18,0)  NULL,
    [Date] datetime  NOT NULL,
    [LastModifiedDate] datetime  NULL,
    [EndDate] datetime  NULL,
    [ServiceCategoryFk] int  NOT NULL,
    [Email] nvarchar(200)  NOT NULL,
    [NrPosts] int  NOT NULL,
    [AccountFk] int  NOT NULL,
    [InTerms] bit  NOT NULL,
    [Visitors] int  NULL,
    [Status] int  NULL,
    [Paid] bit  NULL,
    [IsCompany] bit  NOT NULL,
    [Rating] int  NOT NULL,
    [BasicOption2] nvarchar(max)  NULL,
    [BasicOption3] nvarchar(max)  NULL,
    [BasicOption4] nvarchar(max)  NULL,
    [StandardOption2] nvarchar(max)  NULL,
    [StandardOption3] nvarchar(max)  NULL,
    [StandardOption4] nvarchar(max)  NULL,
    [PremiumOption2] nvarchar(max)  NULL,
    [PremiumOption3] nvarchar(max)  NULL,
    [PremiumOption4] nvarchar(max)  NULL
);
GO

-- Creating table 'ServiceFilePaths'
CREATE TABLE [dbo].[ServiceFilePaths] (
    [FilePathId] int IDENTITY(1,1) NOT NULL,
    [FileName] nvarchar(max)  NOT NULL,
    [FileType] varchar(50)  NOT NULL,
    [ServiceFk] int  NOT NULL
);
GO

-- Creating table 'CourseFilePaths'
CREATE TABLE [dbo].[CourseFilePaths] (
    [FilePathId] int IDENTITY(1,1) NOT NULL,
    [FileName] nvarchar(max)  NOT NULL,
    [FileType] varchar(50)  NOT NULL,
    [CourseFk] int  NOT NULL
);
GO

-- Creating table 'Courses'
CREATE TABLE [dbo].[Courses] (
    [CourseId] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(500)  NOT NULL,
    [Description] nvarchar(max)  NOT NULL,
    [CategoryFk] int  NOT NULL,
    [Date] datetime  NOT NULL,
    [Status] int  NULL,
    [WebReferences] nvarchar(max)  NULL,
    [Likes] bigint  NULL,
    [Rating] nvarchar(500)  NULL,
    [Visitors] bigint  NULL,
    [Price] decimal(18,0)  NOT NULL,
    [AccountFk] int  NOT NULL,
    [DiscountPrice] decimal(18,0)  NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [AccountId] in table 'Accounts'
ALTER TABLE [dbo].[Accounts]
ADD CONSTRAINT [PK_Accounts]
    PRIMARY KEY CLUSTERED ([AccountId] ASC);
GO

-- Creating primary key on [BillId] in table 'Bills'
ALTER TABLE [dbo].[Bills]
ADD CONSTRAINT [PK_Bills]
    PRIMARY KEY CLUSTERED ([BillId] ASC);
GO

-- Creating primary key on [CouponId] in table 'Coupons'
ALTER TABLE [dbo].[Coupons]
ADD CONSTRAINT [PK_Coupons]
    PRIMARY KEY CLUSTERED ([CouponId] ASC);
GO

-- Creating primary key on [CategoryId] in table 'CourseCategories'
ALTER TABLE [dbo].[CourseCategories]
ADD CONSTRAINT [PK_CourseCategories]
    PRIMARY KEY CLUSTERED ([CategoryId] ASC);
GO

-- Creating primary key on [PriceId] in table 'Prices'
ALTER TABLE [dbo].[Prices]
ADD CONSTRAINT [PK_Prices]
    PRIMARY KEY CLUSTERED ([PriceId] ASC);
GO

-- Creating primary key on [ResourceCategoryId] in table 'ResourceCategories'
ALTER TABLE [dbo].[ResourceCategories]
ADD CONSTRAINT [PK_ResourceCategories]
    PRIMARY KEY CLUSTERED ([ResourceCategoryId] ASC);
GO

-- Creating primary key on [FilePathId] in table 'ResourceFilePaths'
ALTER TABLE [dbo].[ResourceFilePaths]
ADD CONSTRAINT [PK_ResourceFilePaths]
    PRIMARY KEY CLUSTERED ([FilePathId] ASC);
GO

-- Creating primary key on [ResourceId] in table 'Resources'
ALTER TABLE [dbo].[Resources]
ADD CONSTRAINT [PK_Resources]
    PRIMARY KEY CLUSTERED ([ResourceId] ASC);
GO

-- Creating primary key on [ServiceCategoryId] in table 'ServiceCategories'
ALTER TABLE [dbo].[ServiceCategories]
ADD CONSTRAINT [PK_ServiceCategories]
    PRIMARY KEY CLUSTERED ([ServiceCategoryId] ASC);
GO

-- Creating primary key on [ServiceId] in table 'Services'
ALTER TABLE [dbo].[Services]
ADD CONSTRAINT [PK_Services]
    PRIMARY KEY CLUSTERED ([ServiceId] ASC);
GO

-- Creating primary key on [FilePathId] in table 'ServiceFilePaths'
ALTER TABLE [dbo].[ServiceFilePaths]
ADD CONSTRAINT [PK_ServiceFilePaths]
    PRIMARY KEY CLUSTERED ([FilePathId] ASC);
GO

-- Creating primary key on [FilePathId] in table 'CourseFilePaths'
ALTER TABLE [dbo].[CourseFilePaths]
ADD CONSTRAINT [PK_CourseFilePaths]
    PRIMARY KEY CLUSTERED ([FilePathId] ASC);
GO

-- Creating primary key on [CourseId] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [PK_Courses]
    PRIMARY KEY CLUSTERED ([CourseId] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [AccountFk] in table 'Bills'
ALTER TABLE [dbo].[Bills]
ADD CONSTRAINT [FK_Bill_Account]
    FOREIGN KEY ([AccountFk])
    REFERENCES [dbo].[Accounts]
        ([AccountId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Bill_Account'
CREATE INDEX [IX_FK_Bill_Account]
ON [dbo].[Bills]
    ([AccountFk]);
GO

-- Creating foreign key on [AccountFk] in table 'Resources'
ALTER TABLE [dbo].[Resources]
ADD CONSTRAINT [FK_Resources_Account]
    FOREIGN KEY ([AccountFk])
    REFERENCES [dbo].[Accounts]
        ([AccountId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Resources_Account'
CREATE INDEX [IX_FK_Resources_Account]
ON [dbo].[Resources]
    ([AccountFk]);
GO

-- Creating foreign key on [AccountFk] in table 'Services'
ALTER TABLE [dbo].[Services]
ADD CONSTRAINT [FK_Services_Account]
    FOREIGN KEY ([AccountFk])
    REFERENCES [dbo].[Accounts]
        ([AccountId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Services_Account'
CREATE INDEX [IX_FK_Services_Account]
ON [dbo].[Services]
    ([AccountFk]);
GO

-- Creating foreign key on [CourseFk] in table 'Coupons'
ALTER TABLE [dbo].[Coupons]
ADD CONSTRAINT [FK_Coupon_CourseCategory]
    FOREIGN KEY ([CourseFk])
    REFERENCES [dbo].[CourseCategories]
        ([CategoryId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Coupon_CourseCategory'
CREATE INDEX [IX_FK_Coupon_CourseCategory]
ON [dbo].[Coupons]
    ([CourseFk]);
GO

-- Creating foreign key on [CourseCategoryFk] in table 'Prices'
ALTER TABLE [dbo].[Prices]
ADD CONSTRAINT [FK_Price_CourseCategory]
    FOREIGN KEY ([CourseCategoryFk])
    REFERENCES [dbo].[CourseCategories]
        ([CategoryId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Price_CourseCategory'
CREATE INDEX [IX_FK_Price_CourseCategory]
ON [dbo].[Prices]
    ([CourseCategoryFk]);
GO

-- Creating foreign key on [ResourceCategoryFk] in table 'Resources'
ALTER TABLE [dbo].[Resources]
ADD CONSTRAINT [FK_Resources_ResourceCategory]
    FOREIGN KEY ([ResourceCategoryFk])
    REFERENCES [dbo].[ResourceCategories]
        ([ResourceCategoryId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Resources_ResourceCategory'
CREATE INDEX [IX_FK_Resources_ResourceCategory]
ON [dbo].[Resources]
    ([ResourceCategoryFk]);
GO

-- Creating foreign key on [ResourceFk] in table 'ResourceFilePaths'
ALTER TABLE [dbo].[ResourceFilePaths]
ADD CONSTRAINT [FK_ResourceFilePaths_Resources]
    FOREIGN KEY ([ResourceFk])
    REFERENCES [dbo].[Resources]
        ([ResourceId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ResourceFilePaths_Resources'
CREATE INDEX [IX_FK_ResourceFilePaths_Resources]
ON [dbo].[ResourceFilePaths]
    ([ResourceFk]);
GO

-- Creating foreign key on [ServiceCategoryFk] in table 'Services'
ALTER TABLE [dbo].[Services]
ADD CONSTRAINT [FK_Services_ServiceCategories]
    FOREIGN KEY ([ServiceCategoryFk])
    REFERENCES [dbo].[ServiceCategories]
        ([ServiceCategoryId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Services_ServiceCategories'
CREATE INDEX [IX_FK_Services_ServiceCategories]
ON [dbo].[Services]
    ([ServiceCategoryFk]);
GO

-- Creating foreign key on [ServiceFk] in table 'ServiceFilePaths'
ALTER TABLE [dbo].[ServiceFilePaths]
ADD CONSTRAINT [FK_FilePaths_Services]
    FOREIGN KEY ([ServiceFk])
    REFERENCES [dbo].[Services]
        ([ServiceId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_FilePaths_Services'
CREATE INDEX [IX_FK_FilePaths_Services]
ON [dbo].[ServiceFilePaths]
    ([ServiceFk]);
GO

-- Creating foreign key on [AccountFk] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [FK_Courses_Accounts]
    FOREIGN KEY ([AccountFk])
    REFERENCES [dbo].[Accounts]
        ([AccountId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Courses_Accounts'
CREATE INDEX [IX_FK_Courses_Accounts]
ON [dbo].[Courses]
    ([AccountFk]);
GO

-- Creating foreign key on [CategoryFk] in table 'Courses'
ALTER TABLE [dbo].[Courses]
ADD CONSTRAINT [FK_CourseBoard_CourseCategory]
    FOREIGN KEY ([CategoryFk])
    REFERENCES [dbo].[CourseCategories]
        ([CategoryId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CourseBoard_CourseCategory'
CREATE INDEX [IX_FK_CourseBoard_CourseCategory]
ON [dbo].[Courses]
    ([CategoryFk]);
GO

-- Creating foreign key on [CourseFk] in table 'CourseFilePaths'
ALTER TABLE [dbo].[CourseFilePaths]
ADD CONSTRAINT [FK_CourseFilePaths_Courses]
    FOREIGN KEY ([CourseFk])
    REFERENCES [dbo].[Courses]
        ([CourseId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CourseFilePaths_Courses'
CREATE INDEX [IX_FK_CourseFilePaths_Courses]
ON [dbo].[CourseFilePaths]
    ([CourseFk]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------