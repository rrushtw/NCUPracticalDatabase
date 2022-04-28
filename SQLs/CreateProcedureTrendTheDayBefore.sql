USE PracticalDatabase
GO

CREATE PROCEDURE TrendTheDayBefore
    @companyId VARCHAR(4)
    @date DATE
AS
BEGIN
    SELECT TOP 2
        ROW_NUMBER() OVER(ORDER BY [Date] DESC) AS TheDay,
        [Date],
        CompanyId,
        ClosePrice
    INTO #Temp
    FROM StockInfo WITH(NOLOCK)
    WHERE
        CompanyId = @companyId
        AND [Date] <= @date
    ORDER BY [Date] DESC

    SELECT
        T1.[Date],
        T1.CompanyId,
        CASE
            WHEN T2.ClosePrice / T1.ClosePrice - 1 > 0.035 THEN 4
            WHEN T2.ClosePrice / T1.ClosePrice - 1 < -0.035 THEN -4
            WHEN T2.ClosePrice / T1.ClosePrice - 1 > 0.015 THEN 3
            WHEN T2.ClosePrice / T1.ClosePrice - 1 < -0.015 THEN -3
            WHEN T2.ClosePrice / T1.ClosePrice - 1 > 0.005 THEN 2
            WHEN T2.ClosePrice / T1.ClosePrice - 1 < -0.005 THEN -2
            WHEN T2.ClosePrice / T1.ClosePrice - 1 > 0 THEN 1
            WHEN T2.ClosePrice / T1.ClosePrice - 1 < 0 THEN -1
            WHEN T2.ClosePrice / T1.ClosePrice - 1 = 0 THEN 0
            ELSE NULL
        END AS [Type]
    FROM #Temp AS T1
    INNER JOIN #Temp AS T2 ON T1.TheDay + 1 = T2.TheDay;

    DROP TABLE #Temp;
END;
GO