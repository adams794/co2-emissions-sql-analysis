/*
===============================================================================
Analytics Layer – Analysis Queries
===============================================================================
Purpose:
    Contains analytical queries used to generate datasets for exploratory
    analysis and visualizations.

Details:
    These queries aggregate and transform analytical views into time series
    datasets used for charts and reporting in external visualization tools
    such as Flourish.

    The queries do not create database objects and are intended for
    analysis, export, and visualization purposes only.

Usage:
    Run individual queries as needed and export results for visualization.
===============================================================================
*/



-- ============================================================================
-- Query 1: Annual CO₂ Emissions by Continent
-- ============================================================================
-- Purpose:
--     Aggregate annual CO₂ emissions by continent and year.
--
-- Details:
--     - Uses country-level annual emissions data
--     - Aggregates emissions to continent level
--     - Converts emissions to billions of tonnes
--     - Calculates each continent's share of global annual emissions
--     - Returns data in wide format suitable for line charts
--     - Share columns are included for interactive chart tooltips/popups
--
-- Output:
--     Year | Africa | Asia | Europe | North America
--          | South America | Oceania
--          | Africa_share | Asia_share | ...
-- ============================================================================

WITH continent_emissions AS (
    SELECT
        Year,
        Continent,
        SUM(Annual_Emission) / 1000000000.0 AS total_continent_emission
    FROM analytics.co2_emissions_enriched
    GROUP BY Year, Continent
),
continent_with_share AS (
    SELECT
        Year,
        Continent,
        total_continent_emission,
        total_continent_emission * 100.0
            / SUM(total_continent_emission) OVER (PARTITION BY Year) AS share_of_global_year
    FROM continent_emissions
)
SELECT
    Year,

    NULLIF(ROUND(SUM(CASE WHEN Continent = 'Africa' THEN total_continent_emission END), 2), 0) AS [Africa],
    NULLIF(ROUND(SUM(CASE WHEN Continent = 'Asia' THEN total_continent_emission END), 2), 0) AS [Asia],
    NULLIF(ROUND(SUM(CASE WHEN Continent = 'Europe' THEN total_continent_emission END), 2), 0) AS [Europe],
    NULLIF(ROUND(SUM(CASE WHEN Continent = 'North America' THEN total_continent_emission END), 2), 0) AS [North America],
    NULLIF(ROUND(SUM(CASE WHEN Continent = 'South America' THEN total_continent_emission END), 2), 0) AS [South America],
    NULLIF(ROUND(SUM(CASE WHEN Continent = 'Oceania' THEN total_continent_emission END), 2), 0) AS [Oceania],

    ROUND(NULLIF(SUM(CASE WHEN Continent = 'Africa' THEN share_of_global_year END), 0), 2) AS [Africa_share],
    ROUND(NULLIF(SUM(CASE WHEN Continent = 'Asia' THEN share_of_global_year END), 0), 2) AS [Asia_share],
    ROUND(NULLIF(SUM(CASE WHEN Continent = 'Europe' THEN share_of_global_year END), 0), 2) AS [Europe_share],
    ROUND(NULLIF(SUM(CASE WHEN Continent = 'North America' THEN share_of_global_year END), 0), 2) AS [North America_share],
    ROUND(NULLIF(SUM(CASE WHEN Continent = 'South America' THEN share_of_global_year END), 0), 2) AS [South America_share],
    ROUND(NULLIF(SUM(CASE WHEN Continent = 'Oceania' THEN share_of_global_year END), 0), 2) AS [Oceania_share]

FROM continent_with_share
GROUP BY Year
ORDER BY Year;



-- ============================================================================
-- Query 2: Share of Global CO₂ Emissions by Continent
-- ============================================================================
-- Purpose:
--     Calculate each continent's percentage share of global annual
--     CO₂ emissions over time.
--
-- Details:
--     - Aggregates country-level emissions to continent level
--     - Calculates each continent's contribution to total global emissions
--     - Returns percentage values in wide format for visualization
--
-- Output:
--     Year | Africa | Asia | Europe | North America
--          | South America | Oceania
-- ============================================================================

WITH continent_emissions AS (
    SELECT
        Year,
        Continent,
        SUM(Annual_Emission) AS continent_emission
    FROM analytics.co2_emissions_enriched
    WHERE Annual_Emission IS NOT NULL
    GROUP BY
        Year,
        Continent
),

global_emissions AS (
    SELECT
        Year,
        SUM(continent_emission) AS global_emission
    FROM continent_emissions
    GROUP BY
        Year
),

emission_share AS (
    SELECT
        ce.Year,
        ce.Continent,
        CAST(
            ce.continent_emission * 100.0 / NULLIF(ge.global_emission, 0)
            AS DECIMAL(10, 2)
        ) AS emission_share_percent
    FROM continent_emissions ce
    INNER JOIN global_emissions ge
        ON ce.Year = ge.Year
)

SELECT
    Year,
    [Africa],
    [Asia],
    [Europe],
    [North America],
    [South America],
    [Oceania]
FROM emission_share
PIVOT (
    SUM(emission_share_percent)
    FOR Continent IN (
        [Africa],
        [Asia],
        [Europe],
        [North America],
        [South America],
        [Oceania]
    )
) AS pivot_table
ORDER BY Year;



-- ============================================================================
-- Query 3: CO₂ Emissions per Capita by Continent
-- ============================================================================
-- Purpose:
--     Calculate annual CO₂ emissions per capita for each continent.
--
-- Details:
--     - Aggregates annual emissions and population by continent
--     - Calculates emissions per capita using:
--           total emissions / total population
--     - Returns results in wide format suitable for line charts
--
-- Output:
--     Year | Africa | Asia | Europe | North America
--          | South America | Oceania
-- ============================================================================

WITH continent_totals AS (
    SELECT
        Year,
        Continent,
        SUM(CAST(Annual_Emission AS DECIMAL(38, 4))) AS total_emissions,
        SUM(CAST(Population AS DECIMAL(38, 4))) AS total_population
    FROM analytics.co2_emissions_enriched
    WHERE 
        Annual_Emission IS NOT NULL
        AND Population IS NOT NULL
        AND Population > 0
    GROUP BY
        Year,
        Continent
),

emissions_per_capita AS (
    SELECT
        Year,
        Continent,
        CAST(
            total_emissions / NULLIF(total_population, 0)
            AS DECIMAL(10, 2)
        ) AS co2_emissions_per_capita
    FROM continent_totals
)

SELECT
    Year,
    [Africa],
    [Asia],
    [Europe],
    [North America],
    [South America],
    [Oceania]
FROM emissions_per_capita
PIVOT (
    SUM(co2_emissions_per_capita)
    FOR Continent IN (
        [Africa],
        [Asia],
        [Europe],
        [North America],
        [South America],
        [Oceania]
    )
) AS pivot_table
ORDER BY Year;
