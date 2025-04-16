# 📄 README – Layoffs Data Cleaning

## 📌 Overview
This project focuses on cleaning and preparing a dataset containing global layoff data.  
The raw dataset contains issues like duplicates, inconsistent formatting, null/blank values, and unnecessary columns.  
The objective is to clean, standardize, and structure the data to make it ready for reliable analysis.

---

## 🧼 Key Cleaning Steps

### 1. Created a Staging Table
To avoid altering the original dataset, a duplicate table was created. All cleaning steps were performed on this staging table.

### 2. Removed Duplicate Records
Duplicates were identified using relevant columns and removed with a `ROW_NUMBER()` partitioning technique.

### 3. Standardized Data Formats
- Trimmed extra spaces in company names.
- Standardized variations of industry names (e.g., `crypto currency`, `cryptocurrency`) to `Crypto`.
- Unified country name entries (e.g., `"United States."` → `"United States"`).
- Converted date fields from text to proper `DATE` format.

### 4. Handled Null and Blank Values
- Replaced blank entries in the `industry` column with `NULL`.
- Filled missing `industry` values by referencing other non-null entries from the same company.
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were `NULL`, as they provide no value.

### 5. Dropped Unnecessary Columns
Temporary columns like `row_num`, used during cleaning, were removed after their purpose was fulfilled.

---

## ✅ Final Outcome
The final cleaned dataset is stored in the `layoffs_staging2` table.  
This table is consistent, deduplicated, and ready for analysis, reporting, or visualization.

---

## 📝 Notes
- The original raw data (`layoffs`) was preserved and not modified.
- SQL best practices were applied throughout the cleaning process to maintain data integrity.
