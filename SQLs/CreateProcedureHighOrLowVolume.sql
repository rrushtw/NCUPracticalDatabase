USE PracticalDatabase
GO

CREATE PROCEDURE HighOrLowVolume
    @companyId VARCHAR(4),
    @date DATE,
    @days INT
AS
BEGIN
    DECLARE @percent INT;
    DECLARE @topCount INT;
    DECLARE @high REAL;
    DECLARE @low REAL;

    SET @percent = 5;
    SET @topCount = @days * @percent / 100;

    IF (@topCount <= 1)
    BEGIN
        PRINT('樣本不足');
        RETURN;
    END;

    SELECT TOP (@days)
        [Date],
        CompanyId,
        TradeVolume
    INTO #TempStock
    FROM StockInfo WITH(NOLOCK)
    WHERE
        CompanyId = @companyId
        AND [Date] <= @date
    ORDER BY [Date] DESC;

    --get the lowest volume from the top group
    SELECT TOP 1 @high = TradeVolume
    FROM (
        SELECT TOP (@topCount) TradeVolume
        FROM #TempStock
        ORDER BY TradeVolume DESC
    ) AS Sub1
    ORDER BY TradeVolume ASC;

    --get the highest volume from the low group
    SELECT TOP 1 @low = TradeVolume
    FROM (
        SELECT TOP (@topCount) TradeVolume
        FROM #TempStock
        ORDER BY TradeVolume ASC
    ) AS Sub2
    ORDER BY TradeVolume DESC;

    SELECT TOP 1
        [Date],
        CompanyId,
        TradeVolume,
        CASE
            WHEN TradeVolume >= @high THEN '高交易量'
            WHEN TradeVolume <= @low THEN '低交易量'
            ELSE '普通交易量'
        END AS HighOrLow
    FROM #TempStock
    ORDER BY [Date] DESC;

    DROP TABLE #TempStock;
END;
GO