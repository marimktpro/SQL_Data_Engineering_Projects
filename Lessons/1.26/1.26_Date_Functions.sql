SELECT
    job_posted_date,
    EXTRACT (YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT (MONTH FROM job_posted_date) AS job_posted_month,
    EXTRACT (DAY FROM job_posted_date) AS job_posted_day
FROM
job_postings_fact
LIMIT
10;

┌─────────────────────┬─────────────────┬──────────────────┬────────────────┐
│   job_posted_date   │ job_posted_year │ job_posted_month │ job_posted_day │
│      timestamp      │      int64      │      int64       │     int64      │
├─────────────────────┼─────────────────┼──────────────────┼────────────────┤
│ 2023-01-01 00:00:04 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:22 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:24 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:27 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:38 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:38 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:43 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:51 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:57 │            2023 │                1 │              1 │
│ 2023-01-01 00:00:57 │            2023 │                1 │              1 │
└─────────────────────┴─────────────────┴──────────────────┴────────────────┘
  10 rows                                                         4 columns


SELECT
    EXTRACT (YEAR FROM job_posted_date) AS job_posted_year,
    EXTRACT (MONTH FROM job_posted_date) AS job_posted_month,
    COUNT(job_id) AS job_count
FROM
job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY
    EXTRACT (YEAR FROM job_posted_date),
    EXTRACT (MONTH FROM job_posted_date)
ORDER BY 
    job_posted_year,
    job_posted_month;

┌─────────────────┬──────────────────┬───────────┐
│ job_posted_year │ job_posted_month │ job_count │
│      int64      │      int64       │   int64   │
├─────────────────┼──────────────────┼───────────┤
│            2023 │                1 │     21448 │
│            2023 │                2 │     15886 │
│            2023 │                3 │     16123 │
│            2023 │                4 │     14859 │
│            2023 │                5 │     13593 │
│            2023 │                6 │     15503 │
│            2023 │                7 │     14521 │
│            2023 │                8 │     15691 │
│            2023 │                9 │     14918 │
│            2023 │               10 │     15459 │
│            2023 │               11 │     15003 │
│            2023 │               12 │     13623 │
│            2024 │                1 │     14119 │
│            2024 │                2 │     14571 │
│            2024 │                3 │     13120 │
│            2024 │                4 │     11979 │
│            2024 │                5 │     12151 │
│            2024 │                6 │     11085 │
│            2024 │                7 │     13636 │
│            2024 │                8 │     12826 │
│            2024 │                9 │      8197 │
│            2024 │               10 │      5057 │
│            2024 │               11 │      3852 │
│            2024 │               12 │      8464 │
│            2025 │                1 │     15296 │
│            2025 │                2 │     17676 │
│            2025 │                3 │     15648 │
│            2025 │                4 │      9542 │
│            2025 │                5 │      9269 │
│            2025 │                6 │      8842 │
└─────────────────┴──────────────────┴───────────┘
  30 rows                              3 columns


-- Date Truncates - primeiro dia ou horario do periodo, consolidando os resultados do periodo

SELECT
    job_posted_date,
    DATE_TRUNC('month', job_posted_date) AS job_posted_month
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

┌─────────────────────┬─────────────────────┐
│   job_posted_date   │  job_posted_month   │
│      timestamp      │      timestamp      │
├─────────────────────┼─────────────────────┤
│ 2023-02-09 10:23:48 │ 2023-02-01 00:00:00 │
│ 2023-10-26 11:26:22 │ 2023-10-01 00:00:00 │
│ 2024-06-23 13:08:32 │ 2024-06-01 00:00:00 │
│ 2024-07-06 13:06:51 │ 2024-07-01 00:00:00 │
│ 2023-12-14 16:24:59 │ 2023-12-01 00:00:00 │
│ 2025-03-17 06:03:53 │ 2025-03-01 00:00:00 │
│ 2024-07-23 09:17:16 │ 2024-07-01 00:00:00 │
│ 2024-12-31 00:59:54 │ 2024-12-01 00:00:00 │
│ 2024-02-26 00:03:02 │ 2024-02-01 00:00:00 │
│ 2023-11-19 08:19:41 │ 2023-11-01 00:00:00 │
└─────────────────────┴─────────────────────┘
  10 rows                         2 columns