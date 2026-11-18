-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sales.uspCategoryRevenue   -- name
    @StartDate date,                         -- parameters (always start with @)
    @EndDate   date
AS
BEGIN
    SET NOCOUNT ON;     -- stops "(n rows affected)" messages;

    -- Step 1: put the filtered lines into a temp table
    DROP TABLE IF EXISTS #lines;

    SELECT d.ProductID, d.LineTotal
    INTO #lines                              -- creates the temp table on the fly
    FROM Sales.SalesOrderHeader AS h
    JOIN Sales.SalesOrderDetail AS d ON h.SalesOrderID = d.SalesOrderID
    WHERE h.OrderDate >= @StartDate
      AND h.OrderDate <  @EndDate;           -- note the < : avoids the end-of-day bug

    -- Step 2: summarize it
    SELECT pc.Name AS category, SUM(l.LineTotal) AS revenue
    FROM #lines AS l
    JOIN Production.Product AS p             ON l.ProductID = p.ProductID
    JOIN Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory AS pc    ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name;
END;