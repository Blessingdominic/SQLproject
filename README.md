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












