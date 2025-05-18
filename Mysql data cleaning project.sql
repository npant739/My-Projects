use world_layoffs;

-- 1. Remove duplicates
-- 2. Standardizing data
-- 3. Null/Blank values
-- 4. Remove unnecessary columns

select * from layoffs;
select * from layoffs_staging;



-- 1st. Remove duplicates



select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) row_num from layoffs_staging;

with duplicate_cte as (
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) row_num from layoffs_staging
)

select * from duplicate_cte where row_num > 1;

create table layoffs_staging2 as select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) row_num from layoffs_staging;

select * from layoffs_staging2;

select * from layoffs_staging2 where row_num > 1;

delete from layoffs_staging2 where row_num > 1;


-- 2nd Standardizing data


update layoffs_staging2 set company = trim(company);

update layoffs_staging2 set industry = "crypto" where industry like "crypto%";

update layoffs_staging2 set country = trim(trailing "." from country) where country like "United States%";

update layoffs_staging2 set date = str_to_date(date, "%m/%d/%Y");

alter table layoffs_staging2 modify column date date; 

select * from layoffs_staging2;



-- 3rd Remove Null/Blank values


select company, industry from layoffs_staging2 where company in ("airbnb", "carvana", "Juul");

select company, industry from layoffs_staging2 where industry = "";

update layoffs_staging2 set industry = null where industry = "";

select company, industry from layoffs_staging2 where industry is null;

select t1.company, t1.industry, t2.company, t2.industry from layoffs_staging2 t1 join layoffs_staging2 t2
on t1.company = t2.company where t1.industry is null and t2.industry is not null;

update layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company = t2.company set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null; 

-- 4th Remove unnecessary columns


alter table layoffs_staging2 drop column row_num;

select * from layoffs_staging2;





















