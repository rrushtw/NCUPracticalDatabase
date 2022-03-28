USE PracticalDatabase
GO

CREATE PROCEDURE CalculateTrend
    @beginDate DATE,
    @endDate DATE
AS
BEGIN
    DECLARE @companyId VARCHAR(4) = '0000';
    DECLARE @tempBeginDate DATE;
    DECLARE @tempEndDate DATE;
    DECLARE @dayCount INT = 0;

    DECLARE @ma05 REAL;
    DECLARE @ma10 REAL;
    DECLARE @ma20 REAL;
    DECLARE @ma60 REAL;

    -- foreach CompanyId IN Company 
    WHILE (1=1)
    BEGIN
        SELECT @companyId = MIN(CompanyId)
        FROM Company WITH(NOLOCK)
        WHERE CompanyId > @companyId;

        IF (@companyId IS NULL) BREAK;

        -- SET beginDate AND endDate
        SELECT @tempEndDate = MAX([Date])
        FROM StockInfo WITH(NOLOCK)
        WHERE [Date] < @endDate;

        -- Add 1 day because there is minus 1 day in the begin of loop
        SET @tempEndDate = DATEADD(DAY, 1, @tempEndDate);

        WHILE (@tempEndDate > @beginDate)
        BEGIN
            SET @tempEndDate = DATEADD(DAY, -1, @tempEndDate);

            -- #region MA05
            IF EXISTS (
                SELECT MA05 FROM StockInfo WITH(NOLOCK)
                WHERE
                    MA05 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId)
            BEGIN
                SELECT @tempBeginDate = MIN([Date])
                FROM (
                    SELECT DISTINCT TOP 5 [Date]
                    FROM StockInfo WITH(NOLOCK)
                    WHERE [Date] <= @tempEndDate
                    ORDER BY [Date] DESC
                ) AS D;

                SELECT @dayCount = COUNT(1)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                IF (@dayCount < 5) CONTINUE;

                SELECT @ma05 = AVG(ClosePrice)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                UPDATE StockInfo
                SET MA05 = @ma05
                WHERE
                    MA05 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId;
            END;
            -- #endregion

            -- #region MA10
            IF EXISTS (
                SELECT MA10 FROM StockInfo WITH(NOLOCK)
                WHERE
                    MA10 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId)
            BEGIN
                SELECT @tempBeginDate = MIN([Date])
                FROM (
                    SELECT DISTINCT TOP 10 [Date]
                    FROM StockInfo WITH(NOLOCK)
                    WHERE [Date] <= @tempEndDate
                    ORDER BY [Date] DESC
                ) AS D;

                SELECT @dayCount = COUNT(1)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                IF (@dayCount < 10) CONTINUE;

                SELECT @ma10 = AVG(ClosePrice)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                UPDATE StockInfo
                SET MA10 = @ma10
                WHERE
                    MA10 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId;
            END;
            -- #endregion

            -- #region MA20
            IF EXISTS (
                SELECT MA20 FROM StockInfo WITH(NOLOCK)
                WHERE
                    MA20 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId)
            BEGIN
                SELECT @tempBeginDate = MIN([Date])
                FROM (
                    SELECT DISTINCT TOP 20 [Date]
                    FROM StockInfo WITH(NOLOCK)
                    WHERE [Date] <= @tempEndDate
                    ORDER BY [Date] DESC
                ) AS D;

                SELECT @dayCount = COUNT(1)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                IF (@dayCount < 20) CONTINUE;

                SELECT @ma20 = AVG(ClosePrice)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                UPDATE StockInfo
                SET MA20 = @ma20
                WHERE
                    MA20 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId;
            END;
            -- #endregion

            -- #region MA60
            IF EXISTS (
                SELECT MA60 FROM StockInfo WITH(NOLOCK)
                WHERE
                    MA60 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId)
            BEGIN
                SELECT @tempBeginDate = MIN([Date])
                FROM (
                    SELECT DISTINCT TOP 60 [Date]
                    FROM StockInfo WITH(NOLOCK)
                    WHERE [Date] <= @tempEndDate
                    ORDER BY [Date] DESC
                ) AS D;

                SELECT @dayCount = COUNT(1)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                IF (@dayCount < 60) CONTINUE;

                SELECT @ma60 = AVG(ClosePrice)
                FROM StockInfo WITH(NOLOCK)
                WHERE
                    [Date] BETWEEN @tempBeginDate AND @tempEndDate
                    AND CompanyId = @companyId;

                UPDATE StockInfo
                SET MA60 = @ma60
                WHERE
                    MA60 IS NULL
                    AND [Date] = @tempEndDate
                    AND CompanyId = @companyId;
            END;
            -- #endregion
        END;
    END;
END;