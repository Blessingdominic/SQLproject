SELECT * 
FROM world_layoffs.layoffs;

-- Data Cleaning
-- 1. Make raw data duplicate, i.e. stage the raw data
-- 2. Remove duplicates
-- 3. Standardize the data
-- 4. Null or blank values
-- 5. Remove unnecessary columns

-- 1. Duplicate raw data
CREATE TABLE layoff_staging
LIKE layoffs;

INSERT layoff_staging
SELECT * 
FROM layoffs;

SELECT *
FROM layoff_staging;

-- 2. Remove duplicate
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper';

-- It will be impossible to delete columnns from CTE tables. So, we'll create a second staging table and add the `row_num` column
CREATE TABLE `layoff_staging3` (
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
FROM layoff_staging3;

SELECT *
FROM layoff_staging3
WHERE row_num > 1;

-- `INSERT INTO` can only be applied if the column has been created in the `CREATE TABLE` SYNTAX
 INSERT INTO layoff_staging3
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;
 
SELECT *
FROM layoff_staging3
WHERE row_num > 1;

DELETE 
FROM layoff_staging3
WHERE row_num > 1;

SELECT *
FROM layoff_staging3;

-- 3. Standardizing data
-- Trim data
SELECT company, TRIM(company)
FROM layoff_staging3;

UPDATE layoff_staging3
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoff_staging3
ORDER BY 1;

SELECT *
FROM layoff_staging3
WHERE industry LIKE 'Crypto%';

UPDATE layoff_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoff_staging3
ORDER BY 1;

SELECT *
FROM layoff_staging3
WHERE country = 'United States.';

UPDATE layoff_staging3
SET country = 'United States'
WHERE country = 'United States.';

-- Another alternative 
-- 'United States.' was used instead of 'United States%' because the error was just one. 
-- So, % can also come in thhe future in case of other unknown errors
UPDATE layoff_staging3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country = 'United States%';

SELECT `date`
FROM layoff_staging3;

UPDATE layoff_staging3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- The date column is still in text format in the schema even when it's in date format. We have to modify the table
ALTER TABLE layoff_staging3
MODIFY COLUMN `date` DATE;


-- 4. Null or blank values

SELECT *
FROM layoff_staging3;

SELECT *
FROM layoff_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging3
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoff_staging3
WHERE company = 'Carvana';

SELECT *
FROM layoff_staging3 t1
JOIN layoff_staging3 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Update the blank rows in the industry column to null values inorder to update the rows, else the following syntax won't work
UPDATE layoff_staging3
SET industry = null
WHERE industry = '';

UPDATE layoff_staging3 t1
JOIN layoff_staging3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoff_staging3
WHERE company LIKE 'Bally%';

-- 5. Remove unnecessary columns
SELECT *
FROM layoff_staging3;

SELECT *
FROM layoff_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoff_staging3
DROP COLUMN row_num;

SELECT *
FROM layoff_staging3;







