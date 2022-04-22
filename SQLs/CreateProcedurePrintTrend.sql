USE PracticalDatabase
GO

CREATE PROCEDURE PrintTrend
    @companyId VARCHAR(4),
    @maType1 SMALLINT,
    @maType2 SMALLINT
AS
BEGIN
    DECLARE @isLarger BIT;
    DECLARE @endDate DATE;
    DECLARE @beginDate DATE;

    -- #region Validate MA type
    IF (@maType1 = @maType2
        OR @maType1 NOT IN (5, 10, 20, 60) 
        OR @maType2 NOT IN (5, 10, 20, 60))
    BEGIN
        PRINT('MA TYPE ERROR');
        RETURN;
    END;

    IF (@maType1 > @maType2)
    BEGIN
        DECLARE @temp SMALLINT;

        SET @temp = @maType1;
        SET @maType1 = @maType2;
        SET @maType2 = @temp;
    END;
    -- #endregion

    IF (@maType1 = 5 AND @maType2 = 10)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA05 > MA10 THEN 1
                WHEN MA05 < MA10 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA05 is not equal MA10
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 != MA10
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA05 is not larger than MA10
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 <= MA10
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA05 is not smaller than MA10
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 >= MA10
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE IF (@maType1 = 5 AND @maType2 = 20)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA05 > MA20 THEN 1
                WHEN MA05 < MA20 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA05 is not equal MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 != MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA05 is not larger than MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 <= MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA05 is not smaller than MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 >= MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE IF (@maType1 = 5 AND @maType2 = 60)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA05 > MA60 THEN 1
                WHEN MA05 < MA60 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA05 is not equal MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 != MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA05 is not larger than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 <= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA05 is not smaller than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA05 >= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE IF (@maType1 = 10 AND @maType2 = 20)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA10 > MA20 THEN 1
                WHEN MA10 < MA20 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA10 is not equal MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 != MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA10 is not larger than MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 <= MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA10 is not smaller than MA20
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 >= MA20
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE IF (@maType1 = 10 AND @maType2 = 60)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA10 > MA60 THEN 1
                WHEN MA10 < MA60 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA10 is not equal MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 != MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA10 is not larger than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 <= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA10 is not smaller than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA10 >= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE IF (@maType1 = 20 AND @maType2 = 60)
    BEGIN
        -- Get @endDate and @isLarger
        SELECT TOP 1
            @endDate = [Date],
            @isLarger = CASE
                WHEN MA20 > MA60 THEN 1
                WHEN MA20 < MA60 THEN 0
                ELSE NULL
            END
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId
        ORDER BY [Date] DESC;

        -- #region Get @beginDate
        IF (@isLarger IS NULL)
        BEGIN
            -- Find the first date of MA20 is not equal MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA20 != MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 1)
        BEGIN
            -- Find the first date of MA20 is not larger than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA20 <= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE IF (@isLarger = 0)
        BEGIN
            -- Find the first date of MA20 is not smaller than MA60
            SELECT TOP 1 @beginDate = [Date]
            FROM StockInfo WITH(NOLOCK)
            WHERE
                CompanyId = @companyId
                AND MA20 >= MA60
                AND [Date] < @endDate
            ORDER BY [Date] DESC;
        END
        ELSE
        BEGIN
            PRINT('Unknown @isLarger');
            RETURN;
        END;
        -- #endregion
    END
    ELSE
    BEGIN
        PRINT('Unknown type');
        RETURN;
    END;

    -- Plus 1 day
    SET @beginDate = DATEADD(DAY, 1, @beginDate);

    SELECT
        CASE @isLarger
            WHEN 1 THEN 'It has been over for xx days'
            WHEN 0 THEN 'It has been small for xx days'
            ELSE 'It has been equal for xx days'
        END AS MATrend,
        COUNT(1) AS DayCount
    FROM StockInfo WITH(NOLOCK)
    WHERE
        [Date] BETWEEN @beginDate AND @endDate
        AND CompanyId = @companyId;
END;
GO