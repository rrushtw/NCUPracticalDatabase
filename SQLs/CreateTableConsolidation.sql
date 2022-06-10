CREATE TABLE Consolidation(
    CompanyId NVARCHAR(4) NOT NULL,
    BeginDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    AveragePrice REAL NOT NULL

    CONSTRAINT [PK_Consolidation] PRIMARY KEY NONCLUSTERED 
    (
        [CompanyId] ASC,
        [BeginDate] ASC
    )ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'公司股票代號',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Consolidation',
@level2type=N'COLUMN',
@level2name=N'CompanyId'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'起始日期',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Consolidation',
@level2type=N'COLUMN',
@level2name=N'BeginDate'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'結束日期',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Consolidation',
@level2type=N'COLUMN',
@level2name=N'EndDate'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'盤整均價',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Consolidation',
@level2type=N'COLUMN',
@level2name=N'AveragePrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'盤整價格',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Consolidation'
GO