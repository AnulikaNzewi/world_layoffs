# 📊 Layoffs Data Analysis Project

## 📌 Overview

This project focuses on cleaning and analyzing a global tech layoffs dataset. The goal is to transform the raw data into a clean, structured format and extract meaningful insights through SQL-based exploratory analysis.

---

## Data Cleaning Steps

To ensure accuracy and reliability in analysis, the following cleaning steps were performed using SQL:

- **Created a Staging Table**: Duplicated the raw data into a staging table (`layoffs_staging`) to preserve the original dataset.
- **Removed Duplicates**: Used row-numbering to identify and remove duplicate records.
- **Standardized Text Formats**:
  - Trimmed extra spaces from company names.
  - Unified industry names (e.g., all “crypto” variations renamed to “Crypto”).
  - Cleaned country names (e.g., “United States of America” → “United States”).
  - Converted text-based dates to proper `DATE` format.
- **Handled Null & Blank Values**:
  - Replaced blanks in the `industry` column with `NULL`.
  - Filled missing industries based on similar entries from the same company.
  - Removed rows with missing values in both `total_laid_off` and `percentage_laid_off`.
- **Dropped Unnecessary Columns**: Removed temporary columns used during cleaning (e.g., `row_num`).

✅ **Output**: Cleaned dataset stored as `layoffs_staging2`, ready for analysis.

---

## 🔍 Exploratory Data Analysis (EDA)

SQL queries were used to uncover trends and insights:

###  General Analysis

- Maximum number of people laid off in a single day.
- Companies that laid off 100% of their workforce and had the most funding.
- Total layoffs by:
  - Company
  - Industry
  - Country

###  Temporal Trends

- Layoffs by year and month.
- Rolling total layoffs over time.
- Date range of the dataset.

###  Yearly Rankings

Using Common Table Expressions (CTEs) and `DENSE_RANK()`:

- **Top 5 Companies with the Most Layoffs per Year**
- **Top 5 Industries Affected per Year**
- **Top 5 Countries Affected per Year**

---

##  Dataset Fields

- `company`
- `industry`
- `country`
- `date`
- `stage`
- `funds_raised_millions`
- `total_laid_off`
- `percentage_laid_off`

---

##  Notes

- The raw data remains untouched for backup and reference.
- All cleaning and transformations were done using SQL best practices.
- This project supports further analysis and dashboard visualization in tools like Power BI or Tableau.

---
