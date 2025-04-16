-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank Values
-- 4. Remove Any Columns
-- NB: If data is sourced from different places, the best practice is to create a new table with the info i it so you don't change the raw data 

-- create table - This will create a table with the same column names as the raw data 
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

-- Insert the information from the raw data into the new table 
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Check for duplicates 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Create CTE to check which rows have duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Check duplicate rows to confirm they are duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- Create a new table so that we are able to deet the duplicate rows. RightClick on the layoff_staging table and select 'Copy to Clipboard Create table)
-- Paste this and change the table name to layoffs_staging2, then add a new column for row number
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
wHERE row_num > 1;


-- insert  data from CTE previously created. The CTE is where we created the row_num column using the row_num and partition by statements
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


-- Delete rows with duplicates
DELETE
FROM layoffs_staging2
wHERE row_num > 1;

-- Confirm that the duplicate rows have been deleted
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing Data
-- Trim and Update the Company column
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize the industry column
SELECT  *
FROM layoffs_staging2
WHERE industry like 'crypto%';

-- Standardize all the different variations of Crypto (i.e crypto currency, cryptocurrency) to the most used classification which is crypto

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Standardize Location and country
SELECT DISTINCT(location)
FROM layoffs_staging2
order by 1;

SELECT DISTINCT(country)
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Standardize the date column. we are doing this because our date column is in text format. Also, since date is a command, we will use bacticks to differntiate it
SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

 -- Work on NULL values and BLANK cells
 SELECT *
 FROM layoffs_staging2
 WHERE total_laid_off IS NULL
 AND percentage_laid_off IS NULL;
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry IS NULL
 OR INDUSTRY = '';
 
 SELECT *
 FROM layoffs_staging2
 WHERE company = 'Airbnb';
 
 -- We have confirmed that there are companies with multiple listings that we can use too update the industry columns
 -- We need to change the blanks to nulls
 UPDATE layoffs_staging2
 SET industry = NULL
 WHERE industry = '';
 
 
 SELECT T1.industry, T2.industry
 FROM layoffs_staging2 AS T1
 JOIN layoffs_staging2 AS T2
	ON T1.company = T2.company
WHERE T1.industry IS NULL 
AND T2.industry IS NOT NULL;

UPDATE layoffs_staging2 T1
JOIN layoffs_staging2 T2
	ON T1.company = T2.company
SET T1.industry = T2.industry
WHERE T1.industry IS NULL 
AND T2.industry IS NOT NULL;
 
-- Delete NULL Values where totallaid off and percentage laid off is null. NB DELETING NULL VALUES REQUIRES A CERTAIN DEGREE OF CONFIDENCE AND 
-- THE USE CASE FOR YOUR ANALYSIS

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
  
-- REMOVE columns that are not useful
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;