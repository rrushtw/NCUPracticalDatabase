USE PracticalDatabase
GO

CREATE OR ALTER PROCEDURE [dbo].[UpdateConsolidation]
    @companyId VARCHAR(10), --companyId
    @beginDate VARCHAR(10) --2022-01-01
AS
BEGIN
    DELETE FROM Consolidation
    WHERE
        ((BeginDate < @beginDate AND EndDate > @beginDate) OR BeginDate > @beginDate)
        AND CompanyId = @companyId;

    SELECT
        [Date],
        CompanyId,
        ClosePrice,
        MA05
    INTO #TempStock
    FROM StockInfo WITh(NOLOCK)
    WHERE
        [Date] > @beginDate
        AND CompanyId = @companyId;

    /*definition*/
    DECLARE @delta REAL = 0.03 --3% range
    DECLARE @minDay INT = 5 --5 days at least

    /*consolidation elements*/
    DECLARE @startDate DATE
    DECLARE @endDate DATE
    DECLARE @len INT = 0
    DECLARE @total REAL = 0

    /*fetch row data from #TempStock*/
    DECLARE @standard REAL
    DECLARE @tmp_date DATE
    DECLARE @tmp_close REAL
    DECLARE @tmp_ma REAL

    WHILE EXISTS(SELECT TOP 1 1 FROM #TempStock)
    BEGIN
        SELECT TOP(1)
            @tmp_date = [Date],
            @tmp_close = ClosePrice,
            @tmp_ma = MA05
        FROM #TempStock
        ORDER BY [Date] ASC;

        IF(@len = 0)
        BEGIN
            SET @startDate = @tmp_date;
            SET @standard = @tmp_ma;
            SET @total += @tmp_close;
            SET @len += 1;

            DELETE FROM #TempStock
            WHERE [Date] = @tmp_date;

            CONTINUE;
        END

        IF(@standard * (1 - @delta) <= @tmp_ma AND @tmp_ma <= @standard * (1 + @delta))
        BEGIN
            SET @endDate = @tmp_date;
            SET @total += @tmp_close;
            SET @len += 1;
        END
        ELSE
        BEGIN
            IF(@len >= @minDay)
            BEGIN
                INSERT INTO Consolidation (CompanyId, BeginDate, EndDate, AveragePrice)
                SELECT @companyId, @startDate, @endDate, @total / @len;
            END

            SET @startDate = @tmp_date;
            SET @standard = @tmp_ma;
            SET @total = 0;
            SET @len = 1;
        END

        DELETE FROM #TempStock
        WHERE [Date] = @tmp_date;
    END

    SELECT
        CompanyId,
        BeginDate,
        EndDate,
        AveragePrice
    FROM Consolidation WITH(NOLOCK)
    ORDER BY BeginDate ASC;

    DROP TABLE #TempStock;
END;
GO