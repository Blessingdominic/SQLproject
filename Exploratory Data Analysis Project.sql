-- EXPLORATORY DATA ANALYSIS

SELECT * 
FROM world_layoffs.layoff_staging3;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_staging3;

SELECT *
FROM layoff_staging3
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoff_staging3
GROUP BY company
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoff_staging3
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoff_staging3
GROUP BY country
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging3;

SELECT YEAR (`date`), SUM(total_laid_off)
FROM layoff_staging3
GROUP BY YEAR (`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoff_staging3
GROUP BY stage
ORDER BY 1 DESC;

-- Rolling total of layoffs to show a month-by-month layoff progression
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoff_staging3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoff_staging3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) rolling_total
FROM Rolling_Total;

-- Layoffs per year
SELECT company, YEAR(`date`) `year`, SUM(total_laid_off) AS total_off
FROM layoff_staging3
GROUP BY company, `year`
ORDER BY 3 DESC;

WITH Comapany_Year AS
(
SELECT company, YEAR(`date`) `year`, SUM(total_laid_off) AS total_off
FROM layoff_staging3
GROUP BY company, `year`
), 
Company_Year_Rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_off DESC) `rank`
FROM Comapany_Year
WHERE `year` IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE `rank` <= 5;
































