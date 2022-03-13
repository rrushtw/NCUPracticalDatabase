USE [PracticalDatabase]
GO

CREATE TABLE CompanyInfo(
    CompanyId NVARCHAR(4) NOT NULL,
    CompanyName NVARCHAR(50) NOT NULL,
    IndustryType NVARCHAR(100) NOT NULL,
    Remark NVARCHAR(MAX) NULL

    CONSTRAINT [PK_Company] PRIMARY KEY NONCLUSTERED 
    (
        [CompanyId] ASC
    )ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'公司股票代號',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'CompanyInfo',
@level2type=N'COLUMN',
@level2name=N'CompanyId'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'公司股票名稱',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'CompanyInfo',
@level2type=N'COLUMN',
@level2name=N'CompanyName'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'產業別',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'CompanyInfo',
@level2type=N'COLUMN',
@level2name=N'IndustryType'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'備註',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'CompanyInfo',
@level2type=N'COLUMN',
@level2name=N'Remark'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'公司股票清單',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'CompanyInfo'
GO