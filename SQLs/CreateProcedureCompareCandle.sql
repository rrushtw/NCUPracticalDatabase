USE PracticalDatabase
GO

CREATE PROCEDURE CompareCandle
    @companyId VARCHAR(4),
    @date DATE
AS
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY [Date] DESC) AS DayCount,
        [Date]
    INTO #DateList
    FROM (
        SELECT DISTINCT TOP 2 [Date]
        FROM StockInfo WITH(NOLOCK)
        WHERE [Date] <= @date
        ORDER BY [Date] DESC
    ) AS Sub;

    SELECT
        S1.[Date],
        S1.companyId,
        CASE
            WHEN
                S2.ClosePrice > S2.OpenPrice -- red yesterday
                AND S1.ClosePrice < S1.OpenPrice -- black today
            THEN '空頭'
            WHEN
                S2.ClosePrice < S2.OpenPrice -- black yesterday
                AND S1.ClosePrice > S1.OpenPrice -- red today
            THEN '多頭'
            ELSE NULL
        END AS Status1,
        CASE
            WHEN
                S2.ClosePrice = S1.ClosePrice
            THEN '遭遇線'
            WHEN
                --the red candle today is inside the black candle yesterday
                (S2.OpenPrice > S1.OpenPrice
                AND S2.OpenPrice > S1.ClosePrice
                AND S2.ClosePrice < S1.OpenPrice
                AND S2.ClosePrice < S1.ClosePrice) 
                OR --the black candle today is inside the red candle yesterday
                (S2.OpenPrice < S1.OpenPrice
                AND S2.OpenPrice < S1.ClosePrice
                AND S2.ClosePrice > S1.OpenPrice
                AND S2.ClosePrice > S1.ClosePrice)
            THEN '懷抱線'
            WHEN
                --the black candle yesterday is inside the red candle today
                (S2.OpenPrice > S1.OpenPrice
                AND S2.OpenPrice < S1.ClosePrice
                AND S2.ClosePrice > S1.OpenPrice
                AND S2.ClosePrice < S1.ClosePrice)
                OR --the red candle yesterday is inside the black candle today
                (S2.OpenPrice < S1.OpenPrice
                AND S2.OpenPrice > S1.ClosePrice
                AND S2.ClosePrice < S1.OpenPrice
                AND S2.ClosePrice > S1.ClosePrice)
            THEN '吞噬線'
            WHEN
                --the black candle yesterday is half higher than the red candle today
                (S2.OpenPrice > S1.OpenPrice
                AND S2.OpenPrice > S1.ClosePrice
                AND S2.ClosePrice <= (S1.OpenPrice + S1.ClosePrice) / 2)
                OR --the red candle yesterday is half lower than the black candle today
                (S2.OpenPrice < S1.OpenPrice
                AND S2.OpenPrice < S1.OpenPrice
                AND S2.ClosePrice >= (S1.OpenPrice + S1.ClosePrice) / 2)
            THEN '插入線'
            ELSE NULL
        END AS Status2
    FROM (
        SELECT
            D1.[Date] AS TheDay,
            D2.[Date] AS TheDayBefore
        FROM #DateList AS D1
        INNER JOIN #DateList AS D2 ON D1.DayCount + 1 = D2.DayCount
    ) AS DD
    LEFT JOIN StockInfo AS S1 WITH(NOLOCK) ON DD.TheDay = S1.[Date] AND S1.CompanyId = @companyId
    LEFT JOIN StockInfo AS S2 WITH(NOLOCK) ON DD.TheDayBefore = S2.[Date] AND S1.CompanyId = S2.CompanyId;

    DROP TABLE #DateList;
END;