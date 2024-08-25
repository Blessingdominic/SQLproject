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
![screenshot of layoff_data table created](https://onedrive.live.com/?cid=2CC54BB9DEC5CE43&id=2CC54BB9DEC5CE43%21sa1050ba37146454db0da9a944f4ee504&parId=2CC54BB9DEC5CE43%21s2c54ba3b1fd74bfc96a79f2d5f308c04&o=OneUp)
