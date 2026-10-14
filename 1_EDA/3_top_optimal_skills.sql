/* 
What are the most optimal skills for a data engineers? balancing both demand and salary?
Create a raking column that combines demand count and median salary to identify the most valuabe skills.'
Focus only on remote Data Engineer positions with specified annual salaries.
Why?
- This approach highlights skills that balance market demand and finanacial reward.
It weights core skills appropriately, rather than letting rare, outlier skills distort the results.
*/


SELECT
  sd.skills,
  COUNT(jpf.*) AS demand_count,
  ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
  ROUND(LN(COUNT(jpf.*)),1) AS ln_demand_count,
  ROUND(MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000 AS optimal_score
  FROM
job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sd.skill_id = sjd.skill_id
WHERE
jpf.Job_title_short = 'Data Engineer'
and jpf.job_work_from_home = True
AND jpf.salary_year_avg IS NOT NULL
GROUP BY
sd.skills
HAVING
  COUNT(jpf.*)>100
ORDER BY
  optimal_score DESC
LIMIT 25;

/* results:
┌────────────┬──────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ demand_count │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    int64     │    double     │     double      │    double     │
├────────────┼──────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │          193 │      184000.0 │             5.3 │      0.968335 │
│ python     │         1133 │      135000.0 │             7.0 │      0.949404 │
│ aws        │          783 │      137320.0 │             6.7 │      0.914983 │
│ sql        │         1128 │      130000.0 │             7.0 │      0.913666 │
│ airflow    │          386 │      150000.0 │             6.0 │      0.893376 │
│ spark      │          503 │      140000.0 │             6.2 │      0.870883 │
│ snowflake  │          438 │      135500.0 │             6.1 │      0.824141 │
│ kafka      │          292 │      145000.0 │             5.7 │      0.823129 │
│ azure      │          475 │      128000.0 │             6.2 │      0.788904 │
│ java       │          303 │      135000.0 │             5.7 │      0.771354 │
│ scala      │          247 │      137290.0 │             5.5 │      0.756387 │
│ kubernetes │          147 │      150500.0 │             5.0 │       0.75106 │
│ git        │          208 │      140000.0 │             5.3 │      0.747255 │
│ databricks │          266 │      132750.0 │             5.6 │      0.741209 │
│ redshift   │          274 │      130000.0 │             5.6 │      0.729707 │
│ gcp        │          196 │      136000.0 │             5.3 │      0.717824 │
│ hadoop     │          198 │      135000.0 │             5.3 │      0.713916 │
│ nosql      │          193 │      134415.0 │             5.3 │      0.707385 │
│ pyspark    │          152 │      140000.0 │             5.0 │      0.703343 │
│ docker     │          144 │      135000.0 │             5.0 │      0.670925 │
│ mongodb    │          136 │      135750.0 │             4.9 │      0.666893 │
│ go         │          113 │      140000.0 │             4.7 │      0.661834 │
│ r          │          133 │      134775.0 │             4.9 │      0.659097 │
│ github     │          127 │      135000.0 │             4.8 │      0.653965 │
│ bigquery   │          123 │      135000.0 │             4.8 │      0.649645 │
└────────────┴──────────────┴───────────────┴─────────────────┴───────────────┘
  25 rows                                                           5 columns
data_jobs D 

*/ 