# Architecture & Data Design

## 🔄 Data Flow

The following diagram illustrates the movement and transformation flow of CO₂ emissions data from raw CSV source files through the analytics platform layers.

![Data Flow](docs/diagrams/data_flow.drawio.png)

The pipeline follows a structured analytical process:

- **Source Files** – Public CO₂ emissions datasets are provided as CSV files.
- **Raw Layer** – Source data is loaded into SQL Server tables without transformations, preserving the original structure of the datasets.
- **Analytics Layer** – Data is standardized, enriched, and combined into analytical SQL views used for reporting and visualization.

Key transformations performed in the Analytics Layer include:

- standardization of country and continent mappings
- enrichment of emissions data with population and land-use information
- multi-source joins across datasets
- creation of derived analytical columns
- preparation of visualization-ready datasets

---

# Data Catalog

## Overview

The analytics platform is organized into two layers:

- **Raw Layer** – stores raw source datasets imported from CSV files
- **Analytics Layer** – contains cleaned, standardized, and enriched analytical views

The platform is designed to support:

- CO₂ emissions analysis
- continent-level aggregations
- reporting and visualization
- analytical SQL queries

---

# Raw Layer

## raw.country_codes

**Purpose:** Stores country and continent reference information used for geographical standardization and analytical joins.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Continent_Name | NVARCHAR(50) | Name of the continent associated with the country |
| Continent_Code | CHAR(2) | Short continent identifier code |
| Country_Name | NVARCHAR(100) | Official country name |
| Two_Letter_Country_Code | CHAR(2) | ISO two-letter country code |
| Three_Letter_Country_Code | CHAR(3) | ISO three-letter country code |
| Country_Number | INT | Numeric country identifier |

---

## raw.annual_co2_emissions

**Purpose:** Stores annual CO₂ emissions data by country and year.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Entity | NVARCHAR(100) | Country or region name |
| Code | CHAR(3) | ISO three-letter country code |
| Year | SMALLINT | Reporting year |
| Annual_Emission | BIGINT | Annual CO₂ emissions measured in tonnes |

---

## raw.population

**Purpose:** Stores annual population statistics by country and year.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Entity | NVARCHAR(100) | Country or region name |
| Code | CHAR(3) | ISO three-letter country code |
| Year | SMALLINT | Reporting year |
| Population | BIGINT | Total annual population |

---

## raw.land_use_change

**Purpose:** Stores annual CO₂ emissions generated from land-use changes.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Entity | NVARCHAR(100) | Country or region name |
| Code | CHAR(3) | ISO three-letter country code |
| Year | SMALLINT | Reporting year |
| Land_Use_Change | DECIMAL(15,2) | Annual emissions related to land-use change |

---

# Analytics Layer

## analytics.country_codes_standardized

**Purpose:** Provides a standardized country reference view with corrected continent mappings for analytical consistency.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Continent_Name | NVARCHAR(50) | Standardized continent name |
| Continent_Code | CHAR(2) | Standardized continent code |
| Country_Name | NVARCHAR(100) | Country name |
| Two_Letter_Country_Code | CHAR(2) | ISO two-letter country code |
| Three_Letter_Country_Code | CHAR(3) | ISO three-letter country code |
| Country_Number | INT | Numeric country identifier |

---

## analytics.co2_emissions_enriched

**Purpose:** Creates an enriched analytical dataset combining CO₂ emissions, land-use change emissions, population statistics, and standardized geographical information.

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| Entity | NVARCHAR(100) | Country or region name |
| Code | CHAR(3) | ISO three-letter country code |
| Year | SMALLINT | Reporting year |
| Continent | NVARCHAR(50) | Standardized continent name |
| Annual_Emission | BIGINT | Annual CO₂ emissions measured in tonnes |
| Land_Use_Change | DECIMAL(15,2) | Annual emissions generated from land-use change |
| Total_Emission | DECIMAL(20,2) | Combined emissions from annual CO₂ and land-use change |
| Population | BIGINT | Total annual population |

