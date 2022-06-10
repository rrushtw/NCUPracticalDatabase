USE PracticalDatabase
GO

CREATE OR ALTER PROCEDURE MACross
    @companyId VARCHAR(4)
AS
BEGIN
    SELECT TOP 3
        [Date],
        CompanyId,
        ClosePrice,
        MA05,
        MA10
    INTO #TempStock
    FROM StockInfo WITH(NOLOCK)
    WHERE CompanyId = @companyId
    ORDER BY [Date] DESC;

    DECLARE @currentClosePrice REAL;
    DECLARE @currentMA05 REAL;

    DECLARE @day1MA05 REAL;
    DECLARE @day1MA10 REAL;
    DECLARE @day2MA05 REAL;
    DECLARE @day2MA10 REAL;

    SELECT TOP 1
        @currentClosePrice = ClosePrice,
        @currentMA05 = MA05
    FROM #TempStock
    ORDER BY [Date] DESC;

    SELECT TOP 1
        @day1MA05 = MA05,
        @day1MA10 = MA10
    FROM #TempStock
    ORDER BY [Date] ASC;

    SELECT TOP 2
        @day2MA05 = MA05,
        @day2MA10 = MA10
    FROM #TempStock
    ORDER BY [Date] ASC;

    DROP TABLE #TempStock;

    -- going up
    IF (@day2MA10 > @day1MA10 AND @day2MA05 > @day1MA05)
    BEGIN
        IF (@currentClosePrice <= @currentMA05)
        BEGIN
            SELECT
                @companyId AS CompanyId,
                '多頭 轉盤整 或 轉多空 警示' AS [Message];
        END;

        RETURN;
    END;

    -- going down
    IF (@day2MA10 < @day1MA10 AND @day2MA05 < @day1MA05)
    BEGIN
        IF (@currentClosePrice >= @currentMA05)
        BEGIN
            SELECT
                @companyId AS CompanyId,
                '多空 轉盤整 或 轉多頭 警示' AS [Message];
        END;

        RETURN;
    END;

    IF (@currentClosePrice >= @currentMA05 AND @currentMA05 > @day2MA05)
    BEGIN
        SELECT
            @companyId AS CompanyId,
            '盤整 轉多頭 警示' AS [Message];
        RETURN;
    END;

    IF (@currentClosePrice <= @currentMA05 AND @currentMA05 < @day2MA05)
    BEGIN
        SELECT
            @companyId AS CompanyId,
            '盤整 轉多空 警示' AS [Message];
        RETURN;
    END;

    SELECT
        @companyId AS CompanyId,
        '盤整' AS [Message];
END;