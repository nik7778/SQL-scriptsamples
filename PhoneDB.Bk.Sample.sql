-- Script Date: 4/28/2020 10:59 PM
-- Sample of Data Base Bk script
SELECT 1;
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE [Users] (
  [Id] int identity  NOT NULL
, [Name] nvarchar(250) NULL COLLATE NOCASE
, [DID] nvarchar(250) NULL COLLATE NOCASE
, [Email] nvarchar(250) NULL COLLATE NOCASE
, [Mailbox] nvarchar(250) NOT NULL COLLATE NOCASE
, [UserID] nvarchar(250) NOT NULL COLLATE NOCASE
, [Enabled] bit NOT NULL
, [Inactive] bit NOT NULL
, [AccountId] int NOT NULL
, [DomainId] int NOT NULL
, [RegistrationDate] datetime NOT NULL
, [LastUpdated] datetime NOT NULL
, CONSTRAINT [sqlite_autoindex_Users_1] PRIMARY KEY ([Id])
, CONSTRAINT [FK_Users_0_0] FOREIGN KEY ([DomainId]) REFERENCES [Domains] ([DomainId]) ON DELETE NO ACTION ON UPDATE NO ACTION
, CONSTRAINT [FK_Users_1_0] FOREIGN KEY ([AccountId]) REFERENCES [Accounts] ([AccountId]) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [Roles] (
  [RoleId] int identity  NOT NULL
, [RoleType] nvarchar(250) NOT NULL COLLATE NOCASE
, CONSTRAINT [sqlite_autoindex_Roles_1] PRIMARY KEY ([RoleId])
);
CREATE TABLE [ProfileDids] (
  [ProfileDidId] int identity  NOT NULL
, [DID] nvarchar(250) NOT NULL COLLATE NOCASE
, [PhisicalPhone] nvarchar(250) NULL COLLATE NOCASE
, [AccountId] int NOT NULL
, [RegistrationDate] datetime NOT NULL
, [LastUpdated] datetime NOT NULL
, CONSTRAINT [sqlite_autoindex_ProfileDids_1] PRIMARY KEY ([ProfileDidId])
);
CREATE TABLE [LogsOutgoing] (
  [LogsOutgoingId] int identity  NOT NULL
, [UserId] nvarchar(250) NOT NULL COLLATE NOCASE
, [CustomerId] nvarchar(250) NOT NULL COLLATE NOCASE
, [Date] datetime NOT NULL
, [DID] nvarchar(50) NULL COLLATE NOCASE
, [CallerID] nvarchar(250) NULL COLLATE NOCASE
, [CalledPhone] nvarchar(50) NOT NULL COLLATE NOCASE
, [Result] bit NOT NULL
, [Details] nvarchar(4000) NULL COLLATE NOCASE
, CONSTRAINT [sqlite_autoindex_LogsOutgoing_1] PRIMARY KEY ([LogsOutgoingId])
);
CREATE TABLE [LogsIncoming] (
  [LogsIncomingId] int identity  NOT NULL
, [Date] datetime NOT NULL
, [From] nvarchar(300) NOT NULL COLLATE NOCASE
, [FromAddress] nvarchar(300) NULL COLLATE NOCASE
, [To] nvarchar(300) NOT NULL COLLATE NOCASE
, [CallId] nvarchar(250) NOT NULL COLLATE NOCASE
, [Result] bit NOT NULL
, [Details] nvarchar(4000) NULL COLLATE NOCASE
, CONSTRAINT [sqlite_autoindex_LogsIncoming_1] PRIMARY KEY ([LogsIncomingId])
);
CREATE TABLE [FvProfiles] (
  [FvProfileId] int identity  NOT NULL
, [Email] nvarchar(250) NOT NULL COLLATE NOCASE
, [Phone] nvarchar(250) NOT NULL COLLATE NOCASE
, [CustomerID] nvarchar(250) NULL COLLATE NOCASE
, [AccountId] int NOT NULL
, [RegistrationDate] datetime NOT NULL
, [LastUpdated] datetime NOT NULL
, CONSTRAINT [sqlite_autoindex_FvProfiles_1] PRIMARY KEY ([FvProfileId])
, CONSTRAINT [FK_FvProfiles_0_0] FOREIGN KEY ([AccountId]) REFERENCES [Accounts] ([AccountId]) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [Domains] (
  [DomainId] int identity  NOT NULL
, [DomainType] nvarchar(250) NULL COLLATE NOCASE
, CONSTRAINT [sqlite_autoindex_Domains_1] PRIMARY KEY ([DomainId])
);
CREATE TABLE [Crms] (
  [CrmId] int identity  NOT NULL
, [CrmType] nvarchar(250) NOT NULL COLLATE NOCASE
, CONSTRAINT [sqlite_autoindex_Crms_1] PRIMARY KEY ([CrmId])
);
CREATE TABLE [CrmKeys] (
  [CrmKeyId] int identity  NOT NULL
, [Key1] nvarchar(500) NOT NULL COLLATE NOCASE
, [Key2] nvarchar(500) NOT NULL COLLATE NOCASE
, [Key3] nvarchar(500) NULL COLLATE NOCASE
, [Key4] nvarchar(500) NULL COLLATE NOCASE
, [AccountId] int NOT NULL
, [CrmId] int NOT NULL
, [IsActive] bit NOT NULL
, [RegistrationDate] datetime NOT NULL
, [LastUpdated] datetime NOT NULL
, CONSTRAINT [sqlite_autoindex_CrmKeys_1] PRIMARY KEY ([CrmKeyId])
, CONSTRAINT [FK_CrmKeys_0_0] FOREIGN KEY ([CrmId]) REFERENCES [Crms] ([CrmId]) ON DELETE NO ACTION ON UPDATE NO ACTION
, CONSTRAINT [FK_CrmKeys_1_0] FOREIGN KEY ([AccountId]) REFERENCES [Accounts] ([AccountId]) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE [Calls] (
  [CallId] int identity  NOT NULL
, [RpcSID] nvarchar(250) NOT NULL COLLATE NOCASE
, [FromPhoneNumber] nvarchar(250) NOT NULL COLLATE NOCASE
, [FromUserID] nvarchar(250) NOT NULL COLLATE NOCASE
, [ToPhoneNumber] nvarchar(250) NOT NULL COLLATE NOCASE
, [Date] datetime NOT NULL
, [UserId] int NOT NULL
, [FvProfileId] int NOT NULL
, CONSTRAINT [sqlite_autoindex_Calls_1] PRIMARY KEY ([CallId])
);
CREATE TABLE [AppLogs] (
  [AppLogId] int identity  NOT NULL
, [Message] nvarchar(1000) NOT NULL COLLATE NOCASE
, [Module] nvarchar(250) NOT NULL COLLATE NOCASE
, [Date] datetime NOT NULL
, CONSTRAINT [sqlite_autoindex_AppLogs_1] PRIMARY KEY ([AppLogId])
);
CREATE TABLE [Accounts] (
  [AccountId] int identity  NOT NULL
, [FirstName] nvarchar(250) NOT NULL COLLATE NOCASE
, [LastName] nvarchar(250) NOT NULL COLLATE NOCASE
, [Username] nvarchar(100) NOT NULL COLLATE NOCASE
, [Email] nvarchar(250) NOT NULL COLLATE NOCASE
, [Phone] nchar(190) NULL COLLATE NOCASE
, [PasswordHash] nvarchar(300) NOT NULL COLLATE NOCASE
, [RegistrationDate] datetime NOT NULL
, [LastUpdated] datetime NOT NULL
, [RoleId] int NOT NULL
, CONSTRAINT [sqlite_autoindex_Accounts_1] PRIMARY KEY ([AccountId])
, CONSTRAINT [FK_Accounts_0_0] FOREIGN KEY ([RoleId]) REFERENCES [Roles] ([RoleId]) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TRIGGER [fki_Users_DomainId_Domains_DomainId] BEFORE Insert ON [Users] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table Users violates foreign key constraint FK_Users_0_0') WHERE (SELECT DomainId FROM Domains WHERE  DomainId = NEW.DomainId) IS NULL; END;
CREATE TRIGGER [fku_Users_DomainId_Domains_DomainId] BEFORE Update ON [Users] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table Users violates foreign key constraint FK_Users_0_0') WHERE (SELECT DomainId FROM Domains WHERE  DomainId = NEW.DomainId) IS NULL; END;
CREATE TRIGGER [fki_Users_AccountId_Accounts_AccountId] BEFORE Insert ON [Users] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table Users violates foreign key constraint FK_Users_1_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fku_Users_AccountId_Accounts_AccountId] BEFORE Update ON [Users] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table Users violates foreign key constraint FK_Users_1_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fki_FvProfiles_AccountId_Accounts_AccountId] BEFORE Insert ON [FvProfiles] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table FvProfiles violates foreign key constraint FK_FvProfiles_0_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fku_FvProfiles_AccountId_Accounts_AccountId] BEFORE Update ON [FvProfiles] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table FvProfiles violates foreign key constraint FK_FvProfiles_0_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fki_CrmKeys_CrmId_Crms_CrmId] BEFORE Insert ON [CrmKeys] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table CrmKeys violates foreign key constraint FK_CrmKeys_0_0') WHERE (SELECT CrmId FROM Crms WHERE  CrmId = NEW.CrmId) IS NULL; END;
CREATE TRIGGER [fku_CrmKeys_CrmId_Crms_CrmId] BEFORE Update ON [CrmKeys] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table CrmKeys violates foreign key constraint FK_CrmKeys_0_0') WHERE (SELECT CrmId FROM Crms WHERE  CrmId = NEW.CrmId) IS NULL; END;
CREATE TRIGGER [fki_CrmKeys_AccountId_Accounts_AccountId] BEFORE Insert ON [CrmKeys] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table CrmKeys violates foreign key constraint FK_CrmKeys_1_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fku_CrmKeys_AccountId_Accounts_AccountId] BEFORE Update ON [CrmKeys] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table CrmKeys violates foreign key constraint FK_CrmKeys_1_0') WHERE (SELECT AccountId FROM Accounts WHERE  AccountId = NEW.AccountId) IS NULL; END;
CREATE TRIGGER [fki_Accounts_RoleId_Roles_RoleId] BEFORE Insert ON [Accounts] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Insert on table Accounts violates foreign key constraint FK_Accounts_0_0') WHERE (SELECT RoleId FROM Roles WHERE  RoleId = NEW.RoleId) IS NULL; END;
CREATE TRIGGER [fku_Accounts_RoleId_Roles_RoleId] BEFORE Update ON [Accounts] FOR EACH ROW BEGIN SELECT RAISE(ROLLBACK, 'Update on table Accounts violates foreign key constraint FK_Accounts_0_0') WHERE (SELECT RoleId FROM Roles WHERE  RoleId = NEW.RoleId) IS NULL; END;
COMMIT;

