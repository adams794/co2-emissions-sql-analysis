/*
===============================================================================
RAW Layer – Stored Procedure for Loading Source Data
===============================================================================
Purpose:
    Loads CSV source files into tables within the raw schema.

Details:
    - Truncates existing data from raw tables
    - Loads source data using BULK INSERT
    - Imports UTF-8 encoded CSV files
    - Skips header rows during import
    - Preserves source data structure without transformations

Notes:
    - Source file paths should be updated to match the local environment
    - The raw layer stores data exactly as received from source systems
    - Existing data in raw tables will be permanently removed before reload

Usage:
    EXEC raw.load_raw_layer;
===============================================================================
*/

CREATE OR ALTER PROCEDURE raw.load_raw_layer AS
BEGIN
    SET NOCOUNT ON;

    -- raw.country_codes
    TRUNCATE TABLE raw.country_codes;

    BULK INSERT raw.country_codes
    FROM '\datasets\country_codes.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- raw.annual_co2_emissions
    TRUNCATE TABLE raw.annual_co2_emissions;

    BULK INSERT raw.annual_co2_emissions
    FROM '\datasets\annual_co2_emissions.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

    -- raw.population
    TRUNCATE TABLE raw.population;

    BULK INSERT raw.population
    FROM '\datasets\population.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );

	-- raw.land_use_change
    TRUNCATE TABLE raw.land_use_change;

    BULK INSERT raw.land_use_change
    FROM '\datasets\land_use_change.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = '65001',
        TABLOCK
    );


END;
GO
