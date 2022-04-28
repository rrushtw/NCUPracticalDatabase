USE PracticalDatabase
GO

CREATE PROCEDURE PrintByPercent
    @days INT,
    @percent REAL
AS
BEGIN
    SELECT
        ROW_NUMBER() OVER(ORDER BY [Date] DESC) AS DayCount,
        [Date]
    INTO #DateList
    FROM (
        SELECT DISTINCT TOP(@days + 1)
        [Date]
        FROM StockInfo WITH(NOLOCK)
        ORDER BY [Date] DESC
    ) AS Sub;

    DECLARE @beginDate DATE;
    DECLARE @endDate DATE;

    SELECT TOP 1 @beginDate = [Date]
    FROM #DateList
    ORDER BY [Date] ASC;

    SELECT TOP 1 @endDate = [Date]
    FROM #DateList
    ORDER BY [Date] DESC;

    SELECT
        CompanyId,
        [Date],
        ClosePrice
    INTO #TempStock
    FROM StockInfo WITH(NOLOCK)
    WHERE [Date] BETWEEN @beginDate AND @endDate;

    SELECT
        T1.[Date],
        T1.CompanyId,
        T2.ClosePrice / T1.ClosePrice * 100 AS [Percent]
    INTO #TempPercent
    FROM (
        SELECT
            D1.[Date] AS TheDay,
            D2.[Date] AS TheDayBefore
        FROM #DateList AS D1
        INNER JOIN #DateList AS D2 ON D1.DayCount + 1 = D2.DayCount
    ) AS DD
    LEFT JOIN #TempStock AS T1 ON DD.TheDay = T1.[Date]
    LEFT JOIN #TempStock AS T2 ON DD.TheDayBefore = T2.[Date] AND T1.CompanyId = T2.CompanyId;

    SELECT
        CompanyId,
        COUNT(1) AS DayCount
    FROM #TempPercent
    WHERE
        @percent > 100 AND [Percent] > @percent
        OR @percent < 100 AND [Percent] < @percent
    GROUP BY CompanyId
    HAVING COUNT(1) >= @days

    DROP TABLE #DateList;
    DROP TABLE #TempStock;
    DROP TABLE #TempPercent;
END;
GO