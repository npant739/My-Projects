use world_layoffs;


-- Exploratory Data Analysis (EDA) Project



select * from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off) from layoffs_staging2;

select * from layoffs_staging2 where percentage_laid_off = 1 order by total_laid_off desc;

select * from layoffs_staging2 where percentage_laid_off = 1 order by funds_raised_millions desc;

select company, sum(total_laid_off) from layoffs_staging2 group by company order by sum(total_laid_off) desc;

select industry, sum(total_laid_off) from layoffs_staging2 group by industry order by 2 desc;

select country, sum(total_laid_off) from layoffs_staging2 group by country order by 2 desc;

select min(date), max(date) from layoffs_staging2; 

select substring(date, 1,7) month, sum(total_laid_off) total_off from layoffs_staging2 where substring(date, 1,7) is not null
group by 1 order by 1;

with rolling_sum_cte as (
select substring(date, 1,7) month, sum(total_laid_off)  total_off from layoffs_staging2 where substring(date, 1,7) is not null
group by 1 order by 1)

select month, total_off, sum(total_off) over(order by month) rolling_total from rolling_sum_cte;

select company, sum(total_laid_off) from layoffs_staging2 group by company order by 2 desc;

select company, year(date), sum(total_laid_off) from layoffs_staging2 group by company, year(date) order by 3 desc;

with company_cte as (
select company, year(date) years, sum(total_laid_off) total_off from layoffs_staging2 group by company, years order by 3 desc
), 
company_ranking as (
select company, years, total_off, dense_rank() over(partition by years order by total_off desc) ranking
from company_cte where years is not null
)

select * from company_ranking where ranking <= 5;


