/* =========================================
   02_customer_profile.sql
   Table: Sales.Customer
   ========================================= */

-- 1. Preview
SELECT TOP 20 *
FROM Sales.Customer;

-- 2. Structure: PK, FKs, nullable columns
EXEC sp_help 'Sales.Customer';

-- 3. Grain check
SELECT
    COUNT(*)                   AS n_rows,
    COUNT(DISTINCT CustomerID) AS n_customers
FROM Sales.Customer;

-- 4. Null counts (nullable columns only)
SELECT
    COUNT(*) - COUNT(PersonID)    AS person_id_nulls,
    COUNT(*) - COUNT(StoreID)     AS store_id_nulls,
    COUNT(*) - COUNT(TerritoryID) AS territory_id_nulls
FROM Sales.Customer;

-- 5. Why null? Customer type by PersonID / StoreID combination
WITH typed AS (
    SELECT
        CASE
            WHEN PersonID IS NOT NULL AND StoreID IS NULL     THEN 'person'
            WHEN PersonID IS NULL     AND StoreID IS NOT NULL THEN 'store'
            WHEN PersonID IS NOT NULL AND StoreID IS NOT NULL THEN 'store contact'
            WHEN PersonID IS NULL     AND StoreID IS NULL     THEN 'neither'
            ELSE 'unexpected'
        END AS customer_type
    FROM Sales.Customer
)
SELECT
    customer_type,
    COUNT(*) AS n_customers
FROM typed
GROUP BY customer_type
ORDER BY n_customers DESC;


/* FINDINGS — Sales.Customer

   Grain:  1 row = 1 customer (19,820 rows = 19,820 distinct CustomerID)

   Keys:
   - PK: CustomerID (surrogate, identity)
   - Business key: AccountNumber (unique, e.g. AW00000001)
   - FKs: PersonID, StoreID, TerritoryID
   - Referenced by: Sales.SalesOrderHeader (join path orders -> customers)

   Nulls:
   - PersonID:    701
   - StoreID:     18,484
   - TerritoryID: 0

   Customer types (explains the nulls; they're expected, not errors):
   - 18,484 person         = individual buyers
   -    701 store          = resellers (bike shops)
   -    635 store contact  = person linked to a store; likely a purchasing contact
                             buying on behalf of the store (unconfirmed)
   -      0 neither        = no orphan customers

   Implication: "customers" means 3 different things here. Any customer count
   or revenue-by-customer question needs to clarify which type(s) to include.
*/