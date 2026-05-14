/*
===============================================================================
Analytics Layer – Standardized Country Codes View
===============================================================================
Purpose:
    Creates a standardized country reference view based on raw country codes data.
    The view corrects continent assignments for selected countries to improve
    analytical consistency.

Details:
    - Reads source data from raw.country_codes
    - Reassigns selected countries to corrected continents
    - Recalculates continent codes based on corrected continent names
    - Returns a cleaned reference dataset for analytical joins and reporting

Notes:
    - The source dataset contains countries assigned to multiple continents
    - Selected mappings were standardized for analytical consistency
    - The view is intended for reporting and aggregation purposes

Usage:
    SELECT *
    FROM analytics.country_codes_standardized;
===============================================================================
*/

CREATE OR ALTER VIEW analytics.country_codes_standardized AS
WITH mapped_countries AS (
    SELECT
        CASE
            WHEN c.Country_Name = 'Armenia, Republic of' THEN 'Asia'
            WHEN c.Country_Name = 'Azerbaijan, Republic of' THEN 'Asia'
            WHEN c.Country_Name = 'Cyprus, Republic of' THEN 'Europe'
            WHEN c.Country_Name = 'Georgia' THEN 'Asia'
            WHEN c.Country_Name = 'Kazakhstan, Republic of' THEN 'Asia'
            WHEN c.Country_Name = 'Russian Federation' THEN 'Asia'
            WHEN c.Country_Name = 'Turkey, Republic of' THEN 'Asia'
            WHEN c.Country_Name = 'United States Minor Outlying Islands' THEN 'Oceania'
            ELSE c.Continent_Name
        END AS Corrected_Continent_Name,
        c.Continent_Name,
        c.Continent_Code,
        c.Country_Name,
        c.Two_Letter_Country_Code,
        c.Three_Letter_Country_Code,
        c.Country_Number
    FROM raw.country_codes c
)
SELECT DISTINCT
    Corrected_Continent_Name AS Continent_Name,
    CASE
        WHEN Corrected_Continent_Name = 'Africa' THEN 'AF'
        WHEN Corrected_Continent_Name = 'Asia' THEN 'AS'
        WHEN Corrected_Continent_Name = 'Europe' THEN 'EU'
        WHEN Corrected_Continent_Name = 'North America' THEN 'NA'
        WHEN Corrected_Continent_Name = 'Oceania' THEN 'OC'
        WHEN Corrected_Continent_Name = 'South America' THEN 'SA'
        ELSE Continent_Code
    END AS Continent_Code,
    Country_Name,
    Two_Letter_Country_Code,
    Three_Letter_Country_Code,
    Country_Number
FROM mapped_countries;
GO
