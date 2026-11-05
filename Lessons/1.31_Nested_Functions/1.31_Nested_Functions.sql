--Array Intro
-- Build a flat skill table for co-corkers to access job titles, salary info, and skills  in one table


SELECT

FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS skil

