USE [PracticalDatabase]
GO

CREATE PROCEDURE GetStockUp
    @endDate DATE,
    @dayCount INT
AS
BEGIN
    CREATE TABLE #companyList (
        CompanyId VARCHAR(4)
    );

    DECLARE @tempDate DATE;
    SET @tempDate = @endDate;

    DECLARE @i INT;
    SET @i = 0;
    WHILE (@i < @dayCount)
    BEGIN
        --略過周末
        IF (DATEPART(WEEKDAY, @tempDate) = 1 OR DATEPART(WEEKDAY, @tempDate) = 7)
        BEGIN
            SET @tempDate = DATEADD(DAY, -1, @tempDate);
            CONTINUE;
        END;

        --略過假日
        IF EXISTS(SELECT TOP 1 1 FROM Holiday WHERE [Date] = @tempDate)
        BEGIN
            SET @tempDate = DATEADD(DAY, -1, @tempDate);
            CONTINUE;
        END;

        --ELSE
        IF (@i = 0)
        BEGIN
            INSERT INTO #companyList
            SELECT CompanyId
            FROM StockInfo WITH(NOLOCK)
            WHERE Change > 0;
        END;

        --刪除跌
        DELETE FROM #companyList
        WHERE CompanyId IN (
            SELECT CompanyId
            FROM StockInfo WITH(NOLOCK)
            WHERE
                [Date] = @tempDate
                AND Change <= 0
        );

        SET @i = @i + 1;
        SET @tempDate = DATEADD(DAY, -1, @tempDate);
    END;

    SELECT DISTINCT CompanyId FROM #companyList;

    DROP TABLE #companyList;
END;
GO