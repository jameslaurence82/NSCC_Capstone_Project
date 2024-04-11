/****** 
Creation of the Drug Interaction Database
Revision 1.3
Author: James Laurence
Team Memebers:
Chris Whalen
Louise Fear
Gabriela Mkonde
James Laurence
Date: March 20th, 2024
INFT3000
******/

-- Create Database drugDB
CREATE DATABASE drugDB
GO
-- uses newly created database
USE [drugDB]
GO
-- Creation of the DRUG Table
CREATE TABLE [dbo].[DRUG](
    [DRUG_ID] [varchar](10) NOT NULL,
    [DRUG_Name] [nvarchar](255) NOT NULL,
    [DRUG_Description] [nvarchar](max) NULL,
    [DRUG_Indication] [nvarchar](max) NULL,
    [DRUG_Pharmacodynamic] [nvarchar](max) NULL,
    [DRUG_Toxicity] [nvarchar](max) NULL,
    CONSTRAINT PK_DRUG_ID PRIMARY KEY ([DRUG_ID]) -- Set Primary Key
)
GO
-- Creation of the PRICE table
CREATE TABLE [dbo].[PRICE](
    [PRICE_ID] [int] IDENTITY(1, 1) NOT NULL,
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [PRICE_Description] [varchar](255) NULL,
    [PRICE_Cost] [float] NULL,
    [PRICE_Currency] [nvarchar](50) NULL,
    [PRICE_PerUnit] [nvarchar](50) NULL,
    CONSTRAINT PK_PRICE_ID PRIMARY KEY ([PRICE_ID]) -- Set primary key
)
GO
-- Creation of the DRUG_INTERACTION Table
CREATE TABLE [dbo].[DRUG_INTERACTION](
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [INTER_DrugID] [varchar](10) NOT NULL,
    [INTER_DrugName] [varchar](255) NOT NULL,
    [INTER_Description] [varchar](255) NOT NULL,
    CONSTRAINT PK_DRUG_ID_INTER_DrugID PRIMARY KEY ([FK_DRUG_ID], [INTER_DrugID]) -- Set composite key
)
GO
-- Creation of the FOOD_INTERACTION table
CREATE TABLE [dbo].[FOOD_INTERACTION](
    [FK_DRUG_ID] [varchar](10) NOT NULL,
    [FOOD_Description] [varchar](max) NULL,
    CONSTRAINT PK_FK_DRUG_ID PRIMARY KEY ([FK_DRUG_ID]) -- Sets composite key
)
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
    CONSTRAINT PK_PROD_ID PRIMARY KEY ([PRO_ID]) -- Sets primary key
)
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
ADD CONSTRAINT [PRODUCT_FK_DRUG_ID] FOREIGN KEY([FK_DRUG_ID])
REFERENCES [dbo].[DRUG] ([DRUG_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO