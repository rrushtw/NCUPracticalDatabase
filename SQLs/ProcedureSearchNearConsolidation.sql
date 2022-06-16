USE PracticalDatabase
GO

CREATE OR ALTER PROCEDURE SearchNearConsolidation
    @companyId VARCHAR(4)
AS
BEGIN
    DECLARE @currentPrice REAL;

    SELECT TOP 1 @currentPrice = ClosePrice
    FROM StockInfo WITH(NOLOCK)
    WHERE CompanyId = @companyId
    ORDER BY [Date] DESC;

    SELECT *
    FROM (
        -- Get the nearest price which is bigger than current
        SELECT TOP 1
            N'HIGH' AS HighOrLow,
            CompanyId,
            BeginDate,
            EndDate,
            AveragePrice
        FROM Consolidation WITH(NOLOCK)
        WHERE
            CompanyId = @companyId
            AND AveragePrice >= @currentPrice
        ORDER BY AveragePrice ASC
        UNION ALL
        -- Get the nearest price which is smaller than current
        SELECT TOP 1
             N'LOW' AS HighOrLow,
            CompanyId,
            BeginDate,
            EndDate,
            AveragePrice
        FROm Consolidation WITH(NOLOCK)
        WHERE
            CompanyId = @companyId
            AND AveragePrice <= @currentPrice
        ORDER BY AveragePrice DESC
    ) AS UnionTable
    ORDER BY AveragePrice ASC;
END;
GO