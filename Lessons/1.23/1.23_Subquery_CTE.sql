-- Scenario 1 - Subquery in SELECT
-- Show each job's salary next to the overall market median:
SELECT
job_title_short,
salary_year_avg,
(
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
)   AS market_median_fact
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

┌───────────────────────────┬─────────────────────────┬────────────────────┐
│      job_title_short      │ median(salary_year_avg) │ market_median_fact │
│          varchar          │         double          │       double       │
├───────────────────────────┼─────────────────────────┼────────────────────┤
│ Senior Data Analyst       │                110000.0 │           116950.0 │
│ Machine Learning Engineer │                135000.0 │           116950.0 │
│ Cloud Engineer            │                120000.0 │           116950.0 │
│ Senior Data Engineer      │                147500.0 │           116950.0 │
│ Senior Data Scientist     │                156500.0 │           116950.0 │
│ Data Engineer             │                130000.0 │           116950.0 │
│ Data Analyst              │                 90000.0 │           116950.0 │
│ Software Engineer         │                144000.0 │           116950.0 │
│ Data Scientist            │                125320.0 │           116950.0 │
│ Business Analyst          │                 91575.0 │           116950.0 │
└───────────────────────────┴─────────────────────────┴────────────────────┘
  10 rows                                                        3 columns


--Scenario 2 - Subquery in FROM
-- Stage only jobs that are remote before aggregating to determine the remote median salary per job;
SELECT
job_title_short,
MEDIAN (salary_year_avg) AS median_salary,
(
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)   AS market_remote_median_fact
FROM (
    SELECT
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home = TRUE
) AS clean_jobs
Group By job_title_short
LIMIT 10;

┌───────────────────────────┬───────────────┬───────────────────────────┐
│      job_title_short      │ median_salary │ market_remote_median_fact │
│          varchar          │    double     │          double           │
├───────────────────────────┼───────────────┼───────────────────────────┤
│ Cloud Engineer            │      132000.0 │                  130000.0 │
│ Senior Data Analyst       │      105000.0 │                  130000.0 │
│ Machine Learning Engineer │      138433.5 │                  130000.0 │
│ Senior Data Engineer      │      145000.0 │                  130000.0 │
│ Data Engineer             │      135000.0 │                  130000.0 │
│ Data Analyst              │       87500.0 │                  130000.0 │
│ Software Engineer         │      180000.0 │                  130000.0 │
│ Senior Data Scientist     │      160000.0 │                  130000.0 │
│ Data Scientist            │      132500.0 │                  130000.0 │
│ Business Analyst          │       90000.0 │                  130000.0 │
└───────────────────────────┴───────────────┴───────────────────────────┘
  10 rows                                                     3 columns

--Scenario 3 - Subquery in HAVING
-- Keep only job titles whose median salary is above the overall median:

SELECT
job_title_short,
MEDIAN (salary_year_avg) AS median_salary,
(
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)   AS market_remote_median_fact
FROM (
    SELECT
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_work_from_home = TRUE
) AS clean_jobs
Group By job_title_short
HAVING MEDIAN (salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
)
LIMIT 10;

┌───────────────────────────┬───────────────┬───────────────────────────┐
│      job_title_short      │ median_salary │ market_remote_median_fact │
│          varchar          │    double     │          double           │
├───────────────────────────┼───────────────┼───────────────────────────┤
│ Senior Data Engineer      │      145000.0 │                  130000.0 │
│ Cloud Engineer            │      132000.0 │                  130000.0 │
│ Machine Learning Engineer │      138433.5 │                  130000.0 │
│ Software Engineer         │      180000.0 │                  130000.0 │
│ Data Engineer             │      135000.0 │                  130000.0 │
│ Data Scientist            │      132500.0 │                  130000.0 │
│ Senior Data Scientist     │      160000.0 │                  130000.0 │
└───────────────────────────┴───────────────┴───────────────────────────┘

--CTE A temporary result set that you can reference within:
    --FROM : used like a table
    --Join to it like any other table
    --Other CTEs: later CTE can reference earlier ones
    -- SELECT/INSERT/UPDATE/DELETE: main statement

--CTE Example
--Compare how much (or less) remote roles pay compared to onsite roles for each job title.
-- Use a CTE to calculate the median salary by title and work arrangement, then compare those medians.

WITH title_median AS (
SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg)::INT AS median_salary
FROM
    job_postings_fact
WHERE job_country = 'United States'
GROUP By 
    job_title_short,
    job_work_from_home
)

SELECT
r.job_title_short,
r.median_salary AS remote_median_salary,
o.median_salary AS onsite_median_salary,
(r.median_salary - o.median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
ON r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = TRUE
AND o.job_work_from_home = FALSE
ORDER BY remote_premium DESC;

┌───────────────────────────┬──────────────────────┬──────────────────────┬────────────────┐
│      job_title_short      │ remote_median_salary │ onsite_median_salary │ remote_premium │
│          varchar          │        int32         │        int32         │     int32      │
├───────────────────────────┼──────────────────────┼──────────────────────┼────────────────┤
│ Machine Learning Engineer │               168500 │               151250 │          17250 │
│ Data Scientist            │               135000 │               127266 │           7734 │
│ Data Engineer             │               135000 │               130000 │           5000 │
│ Senior Data Scientist     │               160000 │               157500 │           2500 │
│ Data Analyst              │                90000 │                90000 │              0 │
│ Senior Data Analyst       │               107913 │               110400 │          -2487 │
│ Senior Data Engineer      │               145000 │               150000 │          -5000 │
│ Business Analyst          │                90000 │                95160 │          -5160 │
│ Software Engineer         │               122500 │               150000 │         -27500 │
│ Cloud Engineer            │                51250 │               135000 │         -83750 │
└───────────────────────────┴──────────────────────┴──────────────────────┴────────────────┘
  10 rows                                                                        4 columns