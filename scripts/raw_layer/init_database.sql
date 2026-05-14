/*
===============================================================================
Database Initialization
===============================================================================
Purpose:
    Creates a fresh CarbonDioxideDatabase database and initializes
    the core schemas used across the CO2 emissions analysis project.

Details:
    - Drops the existing CarbonDioxideDatabase database if it exists
    - Creates a new CarbonDioxideDatabase database
    - Defines schemas for different data layers:
        raw        – stores ingested source data in its original form
        analytics  – contains cleaned, transformed, and analysis-ready datasets

Notes:
    IMPORTANT! This script will permanently remove the existing database
    if it already exists. Intended for development environments.
===============================================================================
*/

USE master;
GO

-- Drop and recreate the 'CarbonDioxideDatabase' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CarbonDioxideDatabase')
BEGIN
    ALTER DATABASE CarbonDioxideDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CarbonDioxideDatabase;
END;
GO

-- Create the 'CarbonDioxideDatabase' database
CREATE DATABASE CarbonDioxideDatabase;
GO

USE CarbonDioxideDatabase;
GO

-- Create Schemas
CREATE SCHEMA raw;
GO

CREATE SCHEMA analytics;
GO
