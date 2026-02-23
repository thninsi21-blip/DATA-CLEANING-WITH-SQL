# DATA-CLEANING-WITH-SQL
DATA-CLEANING-WITH-SQL
🏢 Bayut Real Estate Data Cleaning (SQL)

📌 Project Overview

This project focuses on cleaning and structuring a raw dataset of property listings from Bayut, one of the leading real estate portals in the UAE. The goal was to transform a messy, "flat" dataset into a refined, high-quality version suitable for market analysis and price trend modeling.

📊 Data Source

Source: Kaggle

Dataset: Bayut Selling Properties (Raw)

Region: UAE Real Estate Market

🛠️ Procedures & Technical Implementation

I used SQL Server (T-SQL) to perform the cleaning. The process was broken down into several logical steps using CTEs for readability and efficiency:

Address Parsing (String Manipulation): * Used CROSS APPLY and STRING_SPLIT to break down the full address string.

Implemented a Reverse Row Numbering logic to ensure that the "City" and "Area" were consistently extracted from the end of the string, regardless of address length.
Data Standardisation: * Converted building names to UPPER case for consistency.

Used NULLIF to handle zero-values in financial columns (like average_rent).
Data Filtering & Quality Control: * Filtered out unrealistic listings (e.g., properties with less than 100 sqft) to ensure data integrity.

Excluded listings with a price of 0.
Deduplication: * Utilized ROW_NUMBER() partitioned by key attributes (Price, Building, Area, and Sqft) to identify and remove duplicate entries.

View Creation: * Wrapped the entire logic into a SQL View (vw_Bayut_Properties_Cleaned) to provide a clean, "ready-to-use" table for BI tools like Power BI or Tableau.

✅ Key Outcomes

Normalized Address Data: Separated long address strings into distinct City and Area columns.

Reduced Noise: Removed duplicate listings and "trash" data points that would skew averages.

Analysis Ready: The output is a clean, standardized view that allows for immediate grouping by location and price per square foot.
