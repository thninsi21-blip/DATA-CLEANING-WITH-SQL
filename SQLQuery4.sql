SELECT *
FROM dbo.bayut_selling_properties

---Spliting Address into City and Area Column---

WITH Address_CTE as (
SELECT ID, Value, ROW_NUMBER() over (partition by ID order by ID) as RowNo, count (*) over (partition by ID) as total_part
FROM dbo.bayut_selling_properties
CROSS APPLY 
string_split (address, ',')
),

Rev_address_CTE as (SELECT ID, Value, (total_part - RowNo) as ReverseRN
FROM Address_CTE
),

CleanAddress_CTE as (SELECT ID, [0] as City, [1] as Area
FROM Rev_address_CTE
Pivot
(MAX (Value) for ReverseRN in ([0], [1])) as PVT
),



---Standardiing Data : Handling Zeros, Letters,---

SilverClean_CTE as (SELECT A.*, nullif (A.average_rent, 0) as CleanRent, UPPER(A.building_name) as CAP_bldname, B.City, B.Area
FROM dbo.bayut_selling_properties A 
LEFT Join CleanAddress_CTE B
on A.ID = B.ID
Where A.total_building_area_sqft > 100
),

---Handling Duplicates-----

De_Duplicate_CTE as (SELECT *, row_number() over (partition by price, CAP_bldname, City, Area, total_building_area_sqft Order By ID) as RON
FROM SilverClean_CTE
)

SELECT *
FROM De_Duplicate_CTE
WHERE RON = 1 AND PRICE != 0

--Creating View For Further Analysis__

CREATE VIEW vw_Bayut_Properties_Cleaned AS
WITH Address_CTE as (
SELECT ID, Value, ROW_NUMBER() over (partition by ID order by ID) as RowNo, count (*) over (partition by ID) as total_part
FROM dbo.bayut_selling_properties
CROSS APPLY 
string_split (address, ',')
),

Rev_address_CTE as (SELECT ID, Value, (total_part - RowNo) as ReverseRN
FROM Address_CTE
),

CleanAddress_CTE as (SELECT ID, [0] as City, [1] as Area
FROM Rev_address_CTE
Pivot
(MAX (Value) for ReverseRN in ([0], [1])) as PVT
),

SilverClean_CTE as (SELECT A.*, nullif (A.average_rent, 0) as CleanRent, UPPER(A.building_name) as CAP_bldname, B.City, B.Area
FROM dbo.bayut_selling_properties A 
LEFT Join CleanAddress_CTE B
on A.ID = B.ID
Where A.total_building_area_sqft > 100
),

De_Duplicate_CTE as (SELECT *, row_number() over (partition by price, CAP_bldname, City, Area, total_building_area_sqft Order By ID) as RON
FROM SilverClean_CTE
)

SELECT *
FROM De_Duplicate_CTE
WHERE RON = 1 AND PRICE != 0