USE PracticalDatabase
GO

CREATE PROCEDURE StockUpDown
    @companyId VARCHAR(4),
    @beginDate DATE,
    @endDate DATE
AS
BEGIN
    -- #region Calculate the day and the previous day
    CREATE TABLE #DateList(
        TheDay DATE,
        Previous DATE
    );

    DECLARE @theDay DATE;
    DECLARE @previous DATE;
    SET @theDay = CASE
        WHEN @endDate <= CAST(GETDATE() AS DATE) THEN @endDate
        ELSE CAST(GETDATE() AS DATE)
        END;
    SET @previous = DATEADD(DAY, -1, @theDay);

    WHILE(@theDay >= @beginDate)
    BEGIN
        --Skip Sunday and Saturday
        IF (DATEPART(WEEKDAY, @theDay) = 1 OR DATEPART(WEEKDAY, @theDay) = 7)
        BEGIN
            SET @theDay = DATEADD(DAY, -1, @theDay);
            CONTINUE;
        END;

        IF (DATEPART(WEEKDAY, @previous) = 1 OR DATEPART(WEEKDAY, @previous) = 7)
        BEGIN
            SET @previous = DATEADD(DAY, -1, @previous);
            CONTINUE;
        END;

        --Skip holiday
        IF EXISTS(SELECT TOP 1 1 FROM Holiday WHERE [Date] = @theDay)
        BEGIN
            SET @theDay = DATEADD(DAY, -1, @theDay);
            CONTINUE;
        END;

        IF EXISTS(SELECT TOP 1 1 FROM Holiday WHERE [Date] = @previous)
        BEGIN
            SET @previous = DATEADD(DAY, -1, @previous);
            CONTINUE;
        END;

        --ELSE
        INSERT INTO #DateList (TheDay, Previous)
        SELECT @theDay, @previous;

        SET @theDay = DATEADD(DAY, -1, @theDay);
        SET @previous = DATEADD(DAY, -1, @theDay);
    END;

    --SELECT TheDay, Previous FROM #DateList ORDER BY TheDay ASC;
    -- #endregion

    -- #region SELECT targets INTO temp table
    SELECT TOP 1 @previous = Previous
    FROM #DateList WITH(NOLOCK)
    ORDER BY Previous ASC;
    
    SELECT
        [Date],
        CompanyId,
        OpenPrice,
        HighestPrice,
        LowestPrice,
        ClosePrice
    INTO #TempStock
    FROM StockInfo WITH(NOLOCK)
    WHERE
        [Date] BETWEEN @previous AND @endDate
        AND CompanyId = @companyId;
    -- #endregion

    SELECT
        DL.TheDay AS [Date],
        TS1.CompanyId,
        CASE
            WHEN TS1.LowestPrice > TS2.HighestPrice THEN 3
            WHEN TS1.HighestPrice < TS2.LowestPrice THEN -3
            WHEN TS1.OpenPrice > TS2.OpenPrice
                AND TS1.HighestPrice > TS2.HighestPrice
                AND TS1.LowestPrice > TS2.LowestPrice
                AND TS1.ClosePrice > TS2.ClosePrice
            THEN 2
            WHEN TS1.OpenPrice < TS2.OpenPrice
                AND TS1.HighestPrice < TS2.HighestPrice
                AND TS1.LowestPrice < TS2.LowestPrice
                AND TS1.ClosePrice < TS2.ClosePrice
            THEN -2
            WHEN TS1.ClosePrice > TS2.ClosePrice THEN 1
            WHEN TS1.ClosePrice = TS2.ClosePrice THEN 0
            WHEN TS1.ClosePrice < TS2.ClosePrice THEN -1
            ELSE NULL
        END AS [Status]
    FROM #DateList AS DL WITH(NOLOCK)
    INNER JOIN #TempStock AS TS1 ON DL.TheDay = TS1.Date
    LEFT JOIN #TempStock AS TS2 ON DL.Previous = TS2.Date;

    -- #region Drop temp tables
    DROP TABLE #DateList;
    DROP TABLE #TempStock;
    -- #endregion
END;
GO