SELECT
    jpf.*,
    cd. *
FROM
    job_postings
    
    _fact as jpf
LEFT JOIN
    company_dim as cd
ON
    jpf.company_id = cd.company_id
limit
10;

SELECT
    jpf.job_id,
    jpf.Job_title_short,
    sjd.skill_id,
    sd.skills
FROM
job_postings_fact AS jpf
LEFT JOIN skills_job_dim as sjd
ON jpf.job_id= sjd.job_id
LEFT JOIN skills_dim as sd
ON sjd.skill_id= sd.skill_id
LIMIT 10;