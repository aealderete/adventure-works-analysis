/* =========================================
   01_order_grain.sql
   Tables: Sales.SalesOrderHeader, Sales.SalesOrderDetail
   ========================================= */

-- 1. Preview
SELECT TOP 20 * FROM Sales.SalesOrderHeader;
SELECT TOP 20 * FROM Sales.SalesOrderDetail;

-- 2. Structure: PK, FKs, nullable columns
EXEC sp_help 'Sales.SalesOrderHeader';
EXEC sp_help 'Sales.SalesOrderDetail';

-- 3. Confirm PK columns (detail has a composite key)
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME IN ('SalesOrderHeader', 'SalesOrderDetail')
  AND CONSTRAINT_NAME LIKE 'PK%'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 4. Grain check: rows vs distinct orders in each table
SELECT
    'header'                     AS tbl,
    COUNT(*)                     AS n_rows,
    COUNT(DISTINCT SalesOrderID) AS n_orders
FROM Sales.SalesOrderHeader
UNION ALL
SELECT
    'detail',
    COUNT(*),
    COUNT(DISTINCT SalesOrderID)
FROM Sales.SalesOrderDetail;


/* FINDINGS — Order tables

   Grain:
   - SalesOrderHeader: 1 row = 1 sales order
     (31,465 rows = 31,465 distinct SalesOrderID)
   - SalesOrderDetail: 1 row = 1 line item (product) within an order
     (121,317 rows, 31,465 distinct SalesOrderID)

   Keys:
   - Header PK: SalesOrderID (surrogate, identity)
   - Header business key: SalesOrderNumber (unique, computed, e.g. SO43659)
   - Detail PK: composite (SalesOrderID, SalesOrderDetailID)
   - Detail FK -> Header on SalesOrderID (ON DELETE CASCADE:
     deleting an order deletes its lines)
   - Detail FK -> SpecialOfferProduct on (SpecialOfferID, ProductID)

   Relationship:
   - Header 1 : many Detail
   - Every order has at least 1 line (distinct orders in detail = header count)
   - Avg ~3.9 lines per order (121,317 / 31,465)

   Implication: joining Header to Detail repeats header values once per line.
   Summing header columns (SubTotal, TotalDue, Freight) after that join
   will overcount by ~3.9x. Sum line-level values (LineTotal) instead,
   or aggregate Detail to one row per order before joining.

   Lesson learned:
   - DISTINCT(COUNT(*)) does not count distinct values.
     Use COUNT(DISTINCT col).
   - COUNT(col) counts non-nulls, not distinct values.
*/