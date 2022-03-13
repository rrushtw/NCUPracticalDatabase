USE [PracticalDatabase]
GO

CREATE TABLE Holiday(
    Country NVARCHAR(50) NOT NULL,
    [Date] DATE NOT NULL,
    [Description] NVARCHAR(100) NULL

    CONSTRAINT [PK_Holiday] PRIMARY KEY NONCLUSTERED 
    (
        [Date] ASC
    )ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'日期',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Holiday',
@level2type=N'COLUMN',
@level2name=N'Date'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'描述',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Holiday',
@level2type=N'COLUMN',
@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'股市休市日',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'Holiday'
GO