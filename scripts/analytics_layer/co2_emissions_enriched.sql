/*
===============================================================================
Analytics Layer – CO2 Emissions Enriched View
===============================================================================
Purpose:
    Creates an enriched analytical view combining annual CO2 emissions,
    land-use change emissions, population data, and standardized country
    and continent information.

Details:
    - Reads annual CO2 emissions data from raw.annual_co2_emissions
    - Joins standardized country and continent information
    - Adds annual population data
    - Adds land-use change emissions
    - Calculates total emissions as annual CO2 emissions plus land-use change
    - Filters out unmatched country records and Antarctica
    - Produces a clean dataset for analysis, reporting, and visualizations

Notes:
    - This view is used as the main analytical dataset for CO2 emissions analysis
    - Only records matched to standardized country codes are included
    - Antarctica is excluded from continent-level analysis

Usage:
    SELECT *
    FROM analytics.co2_emissions_enriched;
===============================================================================
*/

CREATE OR ALTER VIEW analytics.co2_emissions_enriched AS
SELECT 
    c.Continent_Name AS Continent,
    e.Entity AS Country,
    e.Code AS Code,
    e.Year AS Year,
	p.Population AS Population,
    e.Emission AS Annual_Emission,
    CAST(f.Land_Use_Change AS BIGINT) AS Land_Use_Change,
	e.Emission + CAST(f.Land_Use_Change AS BIGINT) AS Total
FROM raw.annual_co2_emissions e
LEFT JOIN analytics.country_codes_standardized c
    ON e.Code = c.Three_Letter_Country_Code
LEFT JOIN raw.population p
	ON e.Code = p.Code
	AND e.Year = p.Year
LEFT JOIN raw.land_use_change f
    ON e.Code = f.Code
    AND e.Year = f.Year
WHERE c.Three_Letter_Country_Code IS NOT NULL AND c.Continent_Name <> 'Antarctica';
GO




