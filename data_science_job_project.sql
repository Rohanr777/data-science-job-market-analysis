create database project_ds_jobs;
use project_ds_jobs;
select*from data_science_job;
ALTER TABLE data_science_job
ADD COLUMN record_id INT AUTO_INCREMENT PRIMARY KEY;

-- ************************************	 Data Cleaning for project_ds_jobs	 *********************************



-- updating the experience_level column
select distinct experience_level from data_science_job;

UPDATE data_science_job
SET experience_level =
CASE
    WHEN experience_level = 'EN' THEN 'Entry Level'
    WHEN experience_level = 'MI' THEN 'Mid Level'
    WHEN experience_level = 'SE' THEN 'Senior Level'
    WHEN experience_level = 'EX' THEN 'Executive Level'
    ELSE experience_level
END;

-- updating employemnt_type
select distinct employment_type from data_science_job;
UPDATE data_science_job
SET employment_type =
CASE
    WHEN employment_type = 'FT' THEN 'Full-Time'
    WHEN employment_type = 'PT' THEN 'Part-Time'
    WHEN employment_type = 'CT' THEN 'Contract'
    WHEN employment_type = 'FL' THEN 'Freelance'
    ELSE employment_type
END;

-- updating salary currency
select distinct salary_currency from data_science_job;

ALTER TABLE data_science_job                                              -- modify datatype varchar length from 10 to 100
MODIFY salary_currency VARCHAR(100);
UPDATE data_science_job
SET salary_currency =
CASE
    WHEN salary_currency = 'EUR' THEN 'Euro'
    WHEN salary_currency = 'JPY' THEN 'Japanese Yen'
    WHEN salary_currency = 'INR' THEN 'Indian Rupee'
    WHEN salary_currency = 'GBP' THEN 'British Pound Sterling'
    WHEN salary_currency = 'USD' THEN 'United States Dollar'
    ELSE salary_currency
END;


-- Updating employee_resedence
select distinct employee_residence from data_science_job;
UPDATE data_science_job
SET employee_residence =
CASE
    WHEN employee_residence = 'US' THEN 'United States'
    WHEN employee_residence = 'JP' THEN 'Japan'
    WHEN employee_residence = 'MX' THEN 'Mexico'
    WHEN employee_residence = 'CN' THEN 'China'
    WHEN employee_residence = 'IN' THEN 'India'
    WHEN employee_residence = 'DE' THEN 'Germany'
    WHEN employee_residence = 'UK' THEN 'United Kingdom'
    ELSE employee_residence
END;

-- updating company location 
select distinct company_location from data_science_job;
UPDATE data_science_job
SET company_location =
CASE
    WHEN company_location = 'DE' THEN 'Germany'
    WHEN company_location = 'JP' THEN 'Japan'
    WHEN company_location = 'IN' THEN 'India'
    WHEN company_location = 'UK' THEN 'United Kingdom'
    WHEN company_location = 'CN' THEN 'China'
    WHEN company_location = 'MX' THEN 'Mexico'
    WHEN company_location = 'US' THEN 'United States'
    ELSE company_location
END;

-- updating company_size column

select distinct company_size from data_science_job;
UPDATE data_science_job
SET company_size =
CASE
    WHEN company_size = 'S' THEN 'Small'
    WHEN company_size = 'M' THEN 'Medium'
    WHEN company_size = 'L' THEN 'Large'
    ELSE company_size
END;

select*from data_science_job;

-- ********************** Data Analysis******************


select count(*) from data_science_job;      -- Count number of Rows

SELECT company_size, COUNT(*) as Number_of_appereance              -- Total Number of Apperence By Company
FROM data_science_job 
GROUP BY company_size; 

select company_location,count(*) as Number_of_job                  -- Number of Jobs by Country
from data_science_job
group by company_location; 

select work_year , company_location, count(*) as number_of_job     -- Number of Job by Country And Year             
from data_science_job
group by work_year, company_location
order by work_year;

select job_title , count(length(job_title))from data_science_job   -- job_titles longer than 20 characters
where length(job_title)>=20
group by job_title;

select substring(company_location,1,3) as First_three_words        -- first 3 characters of company_location
from data_science_job;

select replace(experience_level,'Level',' ') as replace_Value     -- Remove the word “Level” from experience_level
from data_science_job;

select company_location,                                          -- Create a new column combining company_location + ' - ' + company_size
	company_size,
    concat(company_location,'-', company_size) as  combining
from data_science_job;

select distinct company_location from data_science_job            -- company_locations ending with ‘a’
where company_location like '%a';

select job_title, experience_level from data_science_job        -- Find roles where experience_level contains “Senior”
where experience_level like '%Senior%';

select max(salary) as maximum_saalry,
		min(salary) as Minimum_salary,
        avg(salary) as Average_salary
from data_science_job;

select job_category,                             -- max,min,avg salary by Job  Category
		avg(salary) as average_salary , 
        max(salary) as maximum_saalry,
		min(salary) as Minimum_salary
from data_science_job
group by job_category
order by average_salary desc;

select experience_level , avg(salary) as average_salary      -- average salary by experience_level
from data_science_job
group by experience_level
order by average_salary desc;

select company_location , avg(salary) as average_salary     -- average salary by company_location
from data_science_job
group by company_location
order by average_salary desc;

select company_size , avg(salary) as average_salary         -- average salary by company_size
from data_science_job
group by company_size
order by average_salary desc;

select job_title , avg(salary) as average_salary            -- Top 3 highest paying job_titles
from data_science_job
group by job_title
order by average_salary desc 
limit 3;

SELECT job_category, COUNT(*) AS total_roles               -- job_category has the highest_number_of roles
FROM data_science_job
GROUP BY job_category
ORDER BY total_roles DESC;

SELECT job_category, COUNT(*) AS total_roles               -- job category  most common in Small companies
FROM data_science_job
WHERE company_size = 'Small'
GROUP BY job_category
ORDER BY total_roles DESC;

select experience_level , avg(salary)                      -- experience_levels with average salary above 120,000
from data_science_job
group by experience_level
having avg(salary)>100000;

SELECT job_title,experience_level,                                                      -- Senior vs Junior upon experience_level
    CASE
        WHEN experience_level IN ('Entry Level', 'Mid Level') THEN 'Junior'
        WHEN experience_level IN ('Senior Level', 'Executive Level') THEN 'Senior'
        ELSE 'Other'
    END AS experience_group
FROM data_science_job;

select company_location , salary,                                                       -- Categorize countries into High-Paying and Moderate-Paying based on avg salary
case
	when salary>(select avg(salary)from data_science_job) then 'High-Paying'
    when salary<(select avg(salary)from data_science_job) then 'Moderate_paying'
    else 'Other'
end as Category
from data_science_job;

select distinct job_title from data_science_job                -- Job Title earning above overall average salary
where salary>
(select avg(salary) from data_science_job);

select job_title from data_science_job                         -- Job title that earn more than average salary of Large companies
where salary >
(select avg(salary) from data_science_job
where company_size='Large');

select job_category from data_science_job                       -- job_category with highest total salary payout
where salary=
(select max(salary) from data_science_job);

select job_title,job_category,salary from                     -- Find second highest salary for job title.category
data_science_job
where salary =
(select salary from data_science_job
order by salary desc limit 1 offset 1);

## second-highest salary by limit-offset
select job_title,salary from data_science_job order by salary desc limit 1 offset 1;   # 199914

select max(salary) from data_science_job;

## Second-highest salary by subquery
select max(salary) from data_science_job where salary<(select max(salary) from data_science_job);

select job_category  from                                                                        -- Rank all records based on salary_in_usd (highest first
	(select  
max(salary_in_usd) over (partition by job_category order by salary_in_usd desc) as max_salary
from data_science_job
)t;                             

SELECT *                                                                         -- top 3 highest paying roles in each company_location.
FROM (
    SELECT 
        job_title,
        company_location,
        salary_in_usd,
        ROW_NUMBER() OVER (
            PARTITION BY company_location
            ORDER BY salary_in_usd DESC
        ) AS rank_number
    FROM data_science_job
) t
WHERE rank_number <= 3;

select*from                                                                                  -- Top 3 highest paid role in each company_size
(
select 
	job_title , 
    company_size,
    salary_in_usd ,
rank() over (partition by company_size order by salary_in_usd desc  ) as Highest_Paid
from data_science_job
)t
where Highest_paid <=3;




-- ************************** JOINS *******************

CREATE TABLE job_info (
    record_id INT PRIMARY KEY,
    job_title VARCHAR(150),
    job_category VARCHAR(100),
    experience_level VARCHAR(50),
    employment_type VARCHAR(50),
    employee_residence VARCHAR(100)
);

CREATE TABLE salary_company_info (
    record_id INT,
    salary_currency VARCHAR(100),
    salary DECIMAL(12,2),
    salary_in_usd DECIMAL(12,2),
    work_setting VARCHAR(50),
    company_location VARCHAR(100),
    company_size VARCHAR(50),
    FOREIGN KEY (record_id) REFERENCES job_info(record_id)
);

INSERT INTO job_info
SELECT
    record_id,
    job_title,
    job_category,
    experience_level,
    employment_type,
    employee_residence
FROM data_science_job;

INSERT INTO salary_company_info
SELECT
    record_id,
    salary_currency,
    salary,
    salary_in_usd,
    work_setting,
    company_location,
    company_size
FROM data_science_job;

select JI.job_title,                                             -- Basic Join Retrive job_title,company_location,salary_in_usd 
	SCI.company_location,
    SCI.salary_in_usd
from job_info as JI inner join salary_company_info as SCI
on JI.record_id=SCI.record_id;

select JI.experience_level,                                                   -- Find Senior-Level roles in Large companies
SCI.company_size
from job_info as JI inner join salary_company_info as SCI
on JI.record_id=SCI.record_id
where JI.experience_level='Senior Level' and SCI.company_size='Large' ;

select JI.job_title,                                             -- Show all job_titles and their salary
		SCI.salary
from job_info as JI left join salary_company_info SCI
on JI.record_id=SCI.record_id;

SELECT                                                            -- Show all job_categories and the number of salary records for each
    JI.job_category,
    COUNT(SCI.salary_in_usd) AS salary_count
FROM job_info JI LEFT JOIN salary_company_info SCI
ON JI.record_id = SCI.record_id
GROUP BY JI.job_category;

select *                                                        -- Keep all rows from salary_company_info
from job_info as JI right join salary_company_info as SCI
on JI.record_id=SCI.record_id;

select SCI.salary_in_usd,                                      -- Basic Right Join
		JI.job_category
from job_info as JI right join salary_company_info as SCI
on JI.record_id=SCI.record_id;

SELECT                                        -- Show all job categories, experience levels, salaries, and company locations from both tables  
    JI.job_category,
    JI.experience_level,
    SCI.salary_in_usd,
    SCI.company_location
FROM job_info JI
LEFT JOIN salary_company_info SCI
ON JI.record_id = SCI.record_id
UNION
SELECT 
    JI.job_category,
    JI.experience_level,
    SCI.salary_in_usd,
    SCI.company_location
FROM job_info JI
RIGHT JOIN salary_company_info SCI
ON JI.record_id = SCI.record_id;

UPDATE data_science_job
SET job_category = 'Unknown'
WHERE job_category IS NULL OR job_category = '';

UPDATE data_science_job
SET experience_level = 'Unknown'
WHERE experience_level IS NULL OR experience_level = '';

UPDATE data_science_job
SET company_size = 'Unknown'
WHERE company_size IS NULL OR company_size = '';

UPDATE data_science_job
SET salary_currency = 'Unknown'
WHERE salary_currency IS NULL OR salary_currency = '';




UPDATE job_info
SET job_category = 'Unknown'
WHERE job_category IS NULL OR job_category = '';

UPDATE job_info
SET experience_level = 'Unknown'
WHERE experience_level IS NULL OR experience_level = '';

UPDATE job_info
SET employment_type = 'Unknown'
WHERE employment_type IS NULL OR employment_type = '';

UPDATE job_info
SET employee_residence = 'Unknown'
WHERE employee_residence IS NULL OR employee_residence = '';






UPDATE salary_company_info
SET salary_currency = 'Unknown'
WHERE salary_currency IS NULL OR salary_currency = '';

UPDATE salary_company_info
SET work_setting = 'Unknown'
WHERE work_setting IS NULL OR work_setting = '';

UPDATE salary_company_info
SET company_location = 'Unknown'
WHERE company_location IS NULL OR company_location = '';

UPDATE salary_company_info
SET company_size = 'Unknown'
WHERE company_size IS NULL OR company_size = '';