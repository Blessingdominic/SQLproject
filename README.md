# Data Cleaning Project on MySQL
## Data Cleaning Techniques
1. Make raw data duplicate, i.e. stage the raw data
2. Remove duplicates
3. Standardize the data
4. Null or blank values
5. Remove unnecessary columns

Let's look at the `world_layoffs` dataset
```
SELECT * 
FROM world_layoffs.layoffs;
```

### Duplicate raw data
```
CREATE TABLE layoff_staging
LIKE layoffs;
```

```
INSERT layoff_staging
SELECT * 
FROM layoffs;
```
```
SELECT *
FROM layoff_data;
```
![`layoffs` data duplicated into `layoff_data` table](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/%60layoffs%60%20data%20duplicated%20into%20%60layoff_data%60%20table.png)

### Remove Duplicates
First, assign row numbers to each record to know which row is duplicated, i.e., >1
```
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_data;
```
![Screenshot showing row numbers assigned to each record](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/Screenshot%20showing%20row%20numbers%20assigned%20to%20each%20record.png)

We'll look at the rows that are duplicated (row_num > 1)
```
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_data
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
```
![Screenshot showing duplicate rows](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/Screenshot%20showing%20duplicate%20rows.png)

It would be impossible to delete columns from CTE tables. So, we'll create a second staging table and add the `row_num` column
```
CREATE TABLE `layoff_data1` (
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
```
`INSERT INTO` can only be applied if the column has been created in the `CREATE TABLE` SYNTAX
```
INSERT INTO layoff_data1
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_data;
```
```
SELECT *
FROM layoff_data1
WHERE row_num > 1;
```
The above query will return the same image result showing the duplicate rows


Now, we can delete the duplicate rows
```
DELETE 
FROM layoff_data1
WHERE row_num > 1;
```
```
SELECT *
FROM layoff_data1
WHERE row_num > 1;
```
![Screenshot showing duplicate rows deleted](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/Screenshot%20showing%20duplicate%20rows%20deleted.png)

### Standardizing data
#### Trim data
```
SELECT company, TRIM(company)
FROM layoff_data1;
```
![Screenshot showing TRIMMED data](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/Screenshot%20showing%20TRIMMED%20data.png)

```
UPDATE layoff_data1
SET company = TRIM(company);
```

#### Distinct Names
```
SELECT DISTINCT industry
FROM layoff_data1
ORDER BY 1;
```
![Screenshot showing distinct industries](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/Screenshot%20showing%20distinct%20industries.png)

The above screenshot shows that there are different variations of Crypto%. We'll update it to one name, Crypto.

Here is a simple footnote[^1].

A footnote can also have multiple lines[^2].

[^1]: My reference.
[^2]: To add line breaks within a footnote, prefix new lines with 2 spaces.
  This is a second line.








