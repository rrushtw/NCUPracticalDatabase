USE PracticalDatabase
GO

CREATE OR ALTER PROCEDURE CalculateMA
    @beginDate DATE,
    @endDate DATE
AS
BEGIN
    DECLARE MyCursor CURSOR FOR
    SELECT [Date], CompanyId
    FROM StockInfo WITH(NOLOCK)
    WHERE [Date] BETWEEN @beginDate AND @endDate
    ORDER BY [Date] DESC;

    OPEN MyCursor;

    --定義ID變數
    DECLARE @date DATE;
    DECLARE @companyId VARCHAR(25);
    DECLARE @average REAL;

    --開始迴圈跑Cursor Start
    FETCH NEXT FROM MyCursor
    INTO @date, @companyId;

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        -- #region MA05
        SELECT TOP 5 1
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId AND [Date] <= @date;

        IF (@@ROWCOUNT = 5)
        BEGIN
            SELECT @average = AVG(ClosePrice) FROM (
                SELECT TOP 5 ClosePrice
                FROM StockInfo WITH(NOLOCK)
                WHERE CompanyId = @companyId AND [Date] <= @date
                ORDER BY [Date] DESC
            ) AS MA05;

            UPDATE StockInfo
            SET MA05 = @average
            WHERE
                CompanyId = @companyId
                AND [Date] = @date;
        END;
        -- #endregion
        -- #region MA10
        SELECT TOP 10 1
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId AND [Date] <= @date;

        IF (@@ROWCOUNT = 10)
        BEGIN
            SELECT @average = AVG(ClosePrice) FROM (
                SELECT TOP 10 ClosePrice
                FROM StockInfo WITH(NOLOCK)
                WHERE CompanyId = @companyId AND [Date] <= @date
                ORDER BY [Date] DESC
            ) AS MA10;

            UPDATE StockInfo
            SET MA10 = @average
            WHERE
                CompanyId = @companyId
                AND [Date] = @date;
        END;
        -- #endregion
        -- #region MA20
        SELECT TOP 20 1
        FROM StockInfo WITH(NOLOCK)
        WHERE CompanyId = @companyId AND [Date] <= @date;

        IF (@@ROWCOUNT = 20)
        BEGIN
            SELECT @average = AVG(ClosePrice) FROM (
                SELECT TOP 20 ClosePrice
                FROM StockInfo WITH(NOLOCK)
                WHERE CompanyId = @companyId AND [Date] <= @date
                ORDER BY [Date] DESC
            ) AS MA20;

            UPDATE StockInfo
            SET MA20 = @average
            WHERE
                CompanyId = @companyId
                AND [Date] = @date;
        END;
        -- #endregion

        FETCH NEXT FROM MyCursor
        INTO @date, @companyId;
    END

    --關閉&釋放cursor
    CLOSE MyCursor
    DEALLOCATE MyCursor
END;