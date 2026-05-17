# CO₂ Emissions SQL Analysis Project

A SQL Server analytics project focused on processing, transforming, and analyzing global CO₂ emissions data.

The project demonstrates how to build a lightweight analytical platform using raw CSV datasets, SQL-based transformations, and analytical views optimized for reporting and visualization.

The project includes:

- raw data ingestion from CSV files
- data cleansing and standardization
- multi-source data enrichment
- analytical SQL views
- data quality validation
- emissions analysis and aggregations
- visualization-ready datasets

---

## 🏗️ High Level Architecture

This project implements a layered SQL analytics platform designed to process and analyze global CO₂ emissions data from multiple source datasets.

The architecture follows a simplified layered approach consisting of a Raw Layer and an Analytics Layer.

![High Level Architecture](docs/diagrams/high_level_architecture.drawio.png)

---

## Layers of the Analytics Platform

### Raw Layer

- Stores source CSV datasets in their original form
- Uses SQL Server tables for raw data ingestion
- Loads data using BULK INSERT and stored procedures
- Applies no transformations during loading
- Serves as the staging area for analytical processing

### Analytics Layer

- Standardizes country and continent mappings
- Cleans and enriches emissions datasets
- Combines emissions, population, and land-use data
- Creates analytical SQL views for reporting and visualization
- Produces enriched datasets optimized for analysis

---
