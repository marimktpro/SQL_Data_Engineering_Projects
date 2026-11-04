SELECT
    table_name,
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'job_postings_fact'
    '

*
Results:
┌───────────────────┬───────────────────────┬───────────┐
│    table_name     │      column_name      │ data_type │
│      varchar      │        varchar        │  varchar  │
├───────────────────┼───────────────────────┼───────────┤
│ job_postings_fact │ job_id                │ INTEGER   │
│ job_postings_fact │ company_id            │ INTEGER   │
│ job_postings_fact │ job_title_short       │ VARCHAR   │
│ job_postings_fact │ job_title             │ VARCHAR   │
│ job_postings_fact │ job_location          │ VARCHAR   │
│ job_postings_fact │ job_via               │ VARCHAR   │
│ job_postings_fact │ job_schedule_type     │ VARCHAR   │
│ job_postings_fact │ job_work_from_home    │ BOOLEAN   │
│ job_postings_fact │ search_location       │ VARCHAR   │
│ job_postings_fact │ job_posted_date       │ TIMESTAMP │
│ job_postings_fact │ job_no_degree_mention │ BOOLEAN   │
│ job_postings_fact │ job_health_insurance  │ BOOLEAN   │
│ job_postings_fact │ job_country           │ VARCHAR   │
│ job_postings_fact │ salary_rate           │ VARCHAR   │
│ job_postings_fact │ salary_year_avg       │ DOUBLE    │
│ job_postings_fact │ salary_hour_avg       │ DOUBLE    │
└───────────────────┴───────────────────────┴───────────┘
  16 rows                                     3 columns

  /*

-- CAST funciton

SELECT 
    CAST(job_id AS VARCHAR) || '_'|| CAST(company_id AS VARCHAR), --conctinating to get more unique identifier
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL (10,0)) AS salary_year_avg --from double to deminal places
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT
    10;

SELECT 
    CAST(job_id AS VARCHAR) || '_'|| CAST(company_id AS VARCHAR), --conctinating to get more unique identifier
    CAST(job_posted_date AS DATE) AS job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL (10,0)) AS salary_year_avg --from double to deminal places
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
LIMIT
    10;

*/

Resuts:
┌───────────────────────────────────────────────────────────────────┬─────────────────┬─────────────────┐
│ ((CAST(job_id AS VARCHAR) || '_') || CAST(company_id AS VARCHAR)) │ job_posted_date │ salary_year_avg │
│                              varchar                              │      date       │  decimal(10,0)  │
├───────────────────────────────────────────────────────────────────┼─────────────────┼─────────────────┤
│ 4651_4651                                                         │ 2023-01-01      │          110000 │
│ 4699_4699                                                         │ 2023-01-01      │           65000 │
│ 4804_4804                                                         │ 2023-01-01      │           90000 │
│ 4810_4810                                                         │ 2023-01-01      │           55000 │
│ 4833_4833                                                         │ 2023-01-01      │          120531 │
│ 4846_4846                                                         │ 2023-01-01      │          300000 │
│ 5089_5089                                                         │ 2023-01-01      │           51000 │
│ 5123_5123                                                         │ 2023-01-01      │          133500 │
│ 5321_5321                                                         │ 2023-01-01      │           77500 │
│ 5325_5321                                                         │ 2023-01-01      │          125000 │
└───────────────────────────────────────────────────────────────────┴─────────────────┴─────────────────┘
  10 rows                                                                                     3 columns
  
  /*