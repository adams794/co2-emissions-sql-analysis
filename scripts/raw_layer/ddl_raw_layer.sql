/*
===============================================================================
RAW Layer – Source Tables Definition
===============================================================================
Purpose:
    Creates tables in the raw schema for storing source data
    used in the CO2 emissions analysis project.

Details:
    The raw layer stores data exactly as received from source files.
    No transformations, business rules, constraints, or relationships
    are applied at this stage.

    Tables created:
    - raw.country_codes
    - raw.annual_co2_emissions
    - raw.population
    - raw.land_use_change

    These tables are populated using BULK INSERT operations
    from CSV source files.

Notes:
    - Existing tables will be dropped and recreated
    - The raw layer should always reflect the original source structure
===============================================================================
*/

-- raw.country_codes
IF OBJECT_ID('raw.country_codes', 'U') IS NOT NULL
    DROP TABLE raw.country_codes;
GO

CREATE TABLE raw.country_codes (
    Continent_Name             NVARCHAR(50),
    Continent_Code             CHAR(2),
    Country_Name               NVARCHAR(100),
    Two_Letter_Country_Code    CHAR(2),
    Three_Letter_Country_Code  CHAR(3),
    Country_Number             SMALLINT
);
GO

-- raw.annual_co2_emissions
IF OBJECT_ID('raw.annual_co2_emissions', 'U') IS NOT NULL
    DROP TABLE raw.annual_co2_emissions;
GO

CREATE TABLE raw.annual_co2_emissions (
    Entity    NVARCHAR(100),
    Code      CHAR(3),
    Year      SMALLINT,
    Emission  BIGINT
);
GO

-- raw.population
IF OBJECT_ID('raw.population', 'U') IS NOT NULL
    DROP TABLE raw.population;
GO

CREATE TABLE raw.population (
    Entity      NVARCHAR(100),
    Code        CHAR(3),
    Year        SMALLINT,
    Population  INT
);
GO

-- raw.land_use_change
IF OBJECT_ID('raw.land_use_change', 'U') IS NOT NULL
    DROP TABLE raw.land_use_change;
GO

CREATE TABLE raw.land_use_change (
    Entity           NVARCHAR(100),
    Code             CHAR(3),
    Year             SMALLINT,
	Land_Use_Change  DECIMAL(15,2)
);
GO
