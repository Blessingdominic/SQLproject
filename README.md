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
![`layoffs` data duplicated into `layoff_data` table](https://raw.githubusercontent.com/Blessingdominic/SQLproject/main/%60layoffs%60%20data%20duplicated%20into%20%60layoff_data%60%20table.png)



