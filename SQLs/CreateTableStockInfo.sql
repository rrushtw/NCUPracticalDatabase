USE [PracticalDatabase]
GO

CREATE TABLE StockInfo(
    CompanyId NVARCHAR(4) NOT NULL,
    [Date] DATE NOT NULL,
    TradeVolume BIGINT NOT NULL,
    TradePrice BIGINT NOT NULL,
    OpenPrice FLOAT(24) NOT NULL,
    HighestPrice FLOAT(24) NOT NULL,
    LowestPrice FLOAT(24) NOT NULL,
    ClosePrice FLOAT(24) NOT NULL,
    Change FLOAT(24) NOT NULL,
    TradeCount INT NOT NULL,
    MA05 FLOAT(24) NULL,
    MA10 FLOAT(24) NULL,
    MA20 FLOAT(24) NULL,
    MA60 FLOAT(24) NULL,
    MA120 FLOAT(24) NULL,
    MA240 FLOAT(24) NULL

    CONSTRAINT [PK_StockInfo] PRIMARY KEY NONCLUSTERED 
    (
        CompanyId ASC,
        [Date] ASC
    )ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'股票代號',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'CompanyId'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'交易日期',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'Date'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'成交股數',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'TradeVolume'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'成交金額',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'TradePrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'開盤價',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'OpenPrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'最高價',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'HighestPrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'最低價',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'LowestPrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'收盤價',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'ClosePrice'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'漲跌價差',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'Change'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'成交筆數',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'TradeCount'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'五日線；週',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA05'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'十日線；半月',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA10'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'月線',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA20'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'季線；三月',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA60'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'半年線；六月',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA120'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'年線',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo',
@level2type=N'COLUMN',
@level2name=N'MA240'
GO

EXEC sys.sp_addextendedproperty
@name=N'MS_Description',
@value=N'股票資訊',
@level0type=N'SCHEMA',
@level0name=N'dbo',
@level1type=N'TABLE',
@level1name=N'StockInfo'
GO