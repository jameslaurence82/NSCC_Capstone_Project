/****** 
Creation of the Drug Interaction Database
Author: James Laurence
Date: March 18th, 2024
INFT3000
******/
-- Create Database drugDB
CREATE DATABASE drugDBtest
GO
-- uses newly created database
USE [drugDBtest]
GO
-- Creation of the DRUG Table
CREATE TABLE [dbo].[DRUG](
    [DRUG_ID] [varchar](10) NOT NULL,
    [DRUG_Name] [nvarchar](255) NULL,
    [DRUG_Description] [nvarchar](max) NULL,
    [DRUG_Indication] [nvarchar](max) NULL,
    [DRUG_Pharmacodynamic] [nvarchar](max) NULL,
    [DRUG_Toxicity] [nvarchar](max) NULL,
    CONSTRAINT PK_DRUG_ID PRIMARY KEY ([DRUG_ID]) -- Sets Primary Key
);
GO

-- Creation of the PRICE table
CREATE TABLE [dbo].[PRICE](
    [PRICE_ID] [int] IDENTITY(1, 1) NOT NULL,
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [PRICE_Description] [varchar](255) NULL,
    [PRICE_Cost] [float] NULL,
    [PRICE_Currency] [nvarchar](50) NULL,
    [PRICE_PerUnit] [nvarchar](50) NULL,
    CONSTRAINT PK_PRICE_ID_DRUG_ID PRIMARY KEY ([PRICE_ID], [FK_DRUG_ID]) -- Sets composite key
);
GO

-- Creation of the DRUG_INTERACTION Table
CREATE TABLE [dbo].[DRUG_INTERACTION](
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [INTER_DrugID] [varchar](10) NOT NULL,
    [INTER_DrugName] [varchar](255) NULL,
    [INTER_Description] [varchar](255) NULL,
    CONSTRAINT PK_DRUG_ID_INTER_DRUG_ID PRIMARY KEY ([FK_DRUG_ID], [INTER_DrugID]) -- Sets composite key
);
GO
-- Creation of the FOOD_INTERACTION table
CREATE TABLE [dbo].[FOOD_INTERACTION](
    [FOOD_ID] [int] IDENTITY(1, 1) NOT NULL,
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [FOOD_Description] [varchar](max) NULL,
    CONSTRAINT PK_FOOD_ID_DRUG_ID PRIMARY KEY ([FOOD_ID], [FK_DRUG_ID]) -- Sets composite key
);
GO

-- Creation of the PRODUCT table
CREATE TABLE [dbo].[PRODUCT](
    [PRO_ID] [int] IDENTITY(1, 1) NOT NULL,
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [PRO_GenericName] [varchar](max) NULL,
    [PRO_Labeller] [varchar](255) NULL,
    [PRO_DosageForm] [varchar](100) NULL,
    [PRO_Strength] [varchar](50) NULL,
    [PRO_RouteUsed] [varchar](255) NULL,
    [PRO_isOTC] [varchar](10) NULL,
    [PRO_isApproved] [varchar](10) NULL,
    [PRO_ApprovalCountry] [varchar](10) NULL,
    [PRO_ApprovalSource] [varchar](10) NULL,
    CONSTRAINT PK_PRODUCT_ID_DRUG_ID PRIMARY KEY ([PRO_ID]) -- Sets primary key
);
GO

-- Creation of the DRUG_PRODUCT bridge table
CREATE TABLE [dbo].[DRUG_PRODUCT](
    [DRUG_PRO_ID] [int] IDENTITY(1, 1) NOT NULL,
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [FK_PRO_ID] [int] NOT NULL,
    CONSTRAINT PK_DRUG_PRODUCT_ID PRIMARY KEY ([DRUG_PRO_ID]) -- Sets primary key
);
GO
-- Creation of the DRUG_DRUG_INTERACTION bridge table
CREATE TABLE [dbo].[DRUG_DRUG_INTERACTION](
	[DRUG_INTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[FK_DRUG_ID] [varchar](10) NOT NULL,
	[FK_DI_FK_DRUG_ID] [varchar](10) NOT NULL,
	[FK_INTER_DrugID] [int] NOT NULL
	CONSTRAINT PK_DRUG_INTER_ID PRIMARY KEY ([DRUG_INTER_ID]) -- sets primary key
);
GO
-- Creation of the DRUG_FOOD_INTERACTION bridge table
CREATE TABLE [dbo].[DRUG_FOOD_INTERACTION](
	[DRUG_FOOD_ID] [int] IDENTITY(1,1) NOT NULL,
	[FK_DRUG_ID] [varchar](10) NOT NULL,
	[FK_FI_FK_DRUG_ID] [varchar](10) NOT NULL,
	[FK_FOOD_ID] [int] NOT NULL
	CONSTRAINT PK_DRUG_FOOD_ID PRIMARY KEY ([DRUG_FOOD_ID]) -- sets primary key
);
GO
-- Creation of the DRUG_PRICE bridge table
CREATE TABLE [dbo].[DRUG_PRICE](
	[DRUG_PRICE_ID] [int] IDENTITY(1,1) NOT NULL,
	[FK_DRUG_ID] [varchar](10) NOT NULL,
	[FK_PRICE_ID] [int] NOT NULL,
	[FK_PRICE_DRUG_ID] [varchar](10) NOT NULL
	CONSTRAINT PK_DRUG_PRICE_ID PRIMARY KEY ([DRUG_PRICE_ID]) -- sets primary key
);
GO
-- Setting Foreign Key Constraint for PRICE Table with Cascade on Update/Delete
ALTER TABLE [dbo].[PRICE] 
ADD CONSTRAINT [PRICE_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_INTERACTION Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_INTERACTION] 
ADD CONSTRAINT [DRUG_INTER_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for FOOD_INTERACTION Table with Cascade on Update/Delete
ALTER TABLE [dbo].[FOOD_INTERACTION] 
ADD CONSTRAINT [FOOD_INTER_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for PRODUCT Table with Cascade on Update/Delete
ALTER TABLE [dbo].[PRODUCT] 
ADD CONSTRAINT [PRODCUT_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRODUCT bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRODUCT] 
ADD CONSTRAINT [DRUG_PRODUCT_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRODUCT bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRODUCT] 
ADD CONSTRAINT [DRUG_PRODUCT_PRO_ID] FOREIGN KEY([FK_PRO_ID])
REFERENCES [dbo].[PRODUCT] ([PRO_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRODUCT bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRODUCT] 
ADD CONSTRAINT [DRUG_PRODUCT_FK_PRO_FK_DRUG_ID] FOREIGN KEY([FK_PRO_FK_DRUG_ID])
REFERENCES [dbo].[PRODUCT] ([FK_DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_DRUG_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_DRUG_INTERACTION] 
ADD CONSTRAINT [DRUG_DRUG_INTER_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_DRUG_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_DRUG_INTERACTION] 
ADD CONSTRAINT [DRUG_DRUG_INTER_DI_FK_DRUG_ID] FOREIGN KEY([FK_DI_FK_DRUG_ID])
REFERENCES [dbo].[DRUG_INTERACTION] ([FK_DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_DRUG_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_DRUG_INTERACTION] 
ADD CONSTRAINT [DRUG_DRUG_INTER_FK_DrugID] FOREIGN KEY([FK_INTER_DrugID])
REFERENCES [dbo].[DRUG_INTERACTION] ([INTER_DrugID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_FOOD_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_FOOD_INTERACTION] 
ADD CONSTRAINT [DRUG_FOOD_INTER_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_FOOD_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_FOOD_INTERACTION] 
ADD CONSTRAINT [DRUG_FOOD_INTER_FI_FK_DRUG_ID] FOREIGN KEY([FK_FI_FK_DRUG_ID])
REFERENCES [dbo].[FOOD_INTERACTION] ([FK_DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_FOOD_INTERACTION bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_FOOD_INTERACTION] 
ADD CONSTRAINT [DRUG_FOOD_FK_FOOD_ID] FOREIGN KEY([FK_FOOD_ID])
REFERENCES [dbo].[FOOD_INTERACTION] ([FOOD_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRICE bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRICE] 
ADD CONSTRAINT [DRUG_PRICE_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRICE bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRICE] 
ADD CONSTRAINT [DRUG_PRICE_FK_PRICE_ID] FOREIGN KEY([FK_PRICE_ID])
REFERENCES [dbo].[PRICE] ([PRICE_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
-- Setting Foreign Key Constraint for DRUG_PRICE bridge Table with Cascade on Update/Delete
ALTER TABLE [dbo].[DRUG_PRICE] 
ADD CONSTRAINT [DRUG_PRICE_PRICE_FK_DRUG_ID] FOREIGN KEY([FK_PRICE_DRUG_ID])
REFERENCES [dbo].[PRICE] ([FK_DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE;
-- DROP DATABASE drugDBtest