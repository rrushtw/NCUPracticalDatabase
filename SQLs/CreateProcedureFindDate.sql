USE [PracticalDatabase]
GO

CREATE PROCEDURE find_date
    @endDate DATE, --起始日期
    @dayCount INT --天數
AS
BEGIN
    CREATE TABLE #resultDateList(
        [Date] DATE
    );

    DECLARE @tempDate DATE;
    SET @tempDate = @endDate;

    DECLARE @i INT;
    SET @i = 0;
    WHILE(@i < @dayCount)
    BEGIN
        IF (DATEPART(WEEKDAY, @tempDate) = 1 OR DATEPART(WEEKDAY, @tempDate) = 7)
        BEGIN
            SET @tempDate = DATEADD(DAY, -1, @tempDate);
            CONTINUE;
        END;

        IF EXISTS(SELECT TOP 1 1 FROM Holiday WHERE [Date] = @tempDate)
        BEGIN
            SET @tempDate = DATEADD(DAY, -1, @tempDate);
            CONTINUE;
        END;

        --ELSE
        INSERT INTO #resultDateList
        SELECT @tempDate;

        SET @i = @i + 1;
        SET @tempDate = DATEADD(DAY, -1, @tempDate);
    END;

    SELECT * FROM #resultDateList;

    DROP TABLE #resultDateList;
END;
GO