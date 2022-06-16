USE PracticalDatabase
GO

CREATE OR ALTER PROCEDURE GetStockByCompanyAndDate
    @companyId VARCHAR(4),
    @beginDate DATE,
    @endDate DATE
AS
BEGIN
    SELECT
        CompanyId,
        [Date],
        TradeVolume,
        TradePrice,
        OpenPrice,
        HighestPrice,
        LowestPrice,
        ClosePrice,
        Change,
        TradeCount,
        MA05,
        MA10,
        MA20,
        MA60,
        MA120,
        MA240
    FROM StockInfo WITH(NOLOCK)
    WHERE
        [Date] BETWEEN @beginDate AND @endDate
        AND CompanyId = @companyId;
END;
GO