-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

-- What was the maximum amount of people laid of in one day
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Which companies laid off their entire staff in one day and had the most funding
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC, total_laid_off DESC;

--  What is the total amount of people laid off by company;
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Which industries where the most affected by layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Which industries where the most affected by layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- What is the total number rof layoffs by year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 1 DESC;

-- Which companies had the most layoffs by stage(seed, series A, etc)
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Total number of layoffs by month and year
SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

-- Rolling total layoffs by month
WITH Rolling_Total AS
( SELECT SUBSTRING(`DATE`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- Total layoffs by companies by year

SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 2
ORDER BY 3 DESC;


-- Top 5 companies with the most layoffs by year
WITH company_year (Company, `Year`, total_laid_off ) AS
(
SELECT company, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 2
ORDER BY company ASC
) ,
Company_Ranking AS
(SELECT *, DENSE_RANK () OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE `Year` IS NOT NULL
ORDER BY RANKING ASC
)
SELECT *
FROM Company_Ranking
WHERE Ranking <= 5
ORDER BY `Year`;

-- Top 5 industry with the most layoffs by year
WITH industry_year (Industry, `Year`, total_laid_off ) AS
(
SELECT Industry, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 2
ORDER BY Industry ASC
) ,
Industry_Ranking AS
(SELECT *, DENSE_RANK () OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) AS Ranking
FROM industry_year
WHERE `Year` IS NOT NULL
ORDER BY RANKING ASC
)
SELECT *
FROM Industry_Ranking
WHERE Ranking <= 5
ORDER BY `Year`;

-- Top 5 country with the most layoffs by year
WITH country_year (Company, `Year`, total_laid_off ) AS
(
SELECT country, YEAR(`DATE`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1, 2
ORDER BY country ASC
) ,
Country_Ranking AS
(SELECT *, DENSE_RANK () OVER(PARTITION BY `Year` ORDER BY total_laid_off DESC) AS Ranking
FROM country_year
WHERE `Year` IS NOT NULL
ORDER BY RANKING ASC
)
SELECT *
FROM Country_Ranking
WHERE Ranking <= 5
ORDER BY `Year`;
