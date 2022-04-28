USE PracticalDatabase
GO

CREATE PROCEDURE HighOrLowPrice
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
        HighestPrice
    INTO #TempStock
    FROM StockInfo WITH(NOLOCK)
    WHERE
        CompanyId = @companyId
        AND [Date] <= @date
    ORDER BY [Date] DESC;

    --get the lowest price from the top group
    SELECT TOP 1 @high = HighestPrice
    FROM (
        SELECT TOP (@topCount) HighestPrice
        FROM #TempStock
        ORDER BY HighestPrice DESC
    ) AS Sub1
    ORDER BY HighestPrice ASC;

    --get the highest price from the low group
    SELECT TOP 1 @low = HighestPrice
    FROM (
        SELECT TOP (@topCount) HighestPrice
        FROM #TempStock
        ORDER BY HighestPrice ASC
    ) AS Sub2
    ORDER BY HighestPrice DESC;

    SELECT TOP 1
        [Date],
        CompanyId,
        HighestPrice,
        CASE
            WHEN HighestPrice >= @high THEN '高檔'
            WHEN HighestPrice <= @low THEN '低檔'
            ELSE '普通'
        END AS HighOrLow
    FROM #TempStock
    ORDER BY [Date] DESC;

    DROP TABLE #TempStock;
END;
GO