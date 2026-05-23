/*
===============================================================================
RAW Layer – Data Quality Checks
===============================================================================
Purpose:
    Performs basic data quality checks on raw source tables to identify issues
    that may affect downstream analysis.

Details:
    The checks in this script focus on:
    - detecting countries assigned to more than one continent
    - reviewing inconsistent continent mappings in raw.country_codes

    These checks support the creation of standardized analytical reference
    objects such as analytics.country_codes_standardized.

Usage:
    Run individual queries as needed during data validation and profiling.

Notes:
    - This script does not modify any data or database objects
    - The results are used to validate source data quality before building
      analytical views
===============================================================================
*/

-- Check for countries assigned to more than one continent
SELECT
    Country_Name,
    COUNT(DISTINCT Continent_Name) AS continent_count
FROM raw.country_codes
GROUP BY Country_Name
HAVING COUNT(DISTINCT Continent_Name) > 1
ORDER BY Country_Name;
GO

-- Review continent assignments for countries with inconsistent mappings
SELECT
    Country_Name,
    STRING_AGG(Continent_Name, ', ') AS Continents,
    COUNT(DISTINCT Continent_Name) AS Continent_Count
FROM raw.country_codes
GROUP BY Country_Name
HAVING COUNT(DISTINCT Continent_Name) > 1
ORDER BY Country_Name;
GO

