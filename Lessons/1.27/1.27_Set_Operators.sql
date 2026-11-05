-- UNION query, junta as planilhas, eliminando linhas duplicadas
-- criando planilha #1:
SELECT UNNEST ([1, 1, 1, 2])

-- criando planilha #2:
SELECT UNNEST ([1, 1, 3])

--Usando a query UNION:
SELECT UNNEST ([1, 1, 1, 2])
UNION
SELECT UNNEST ([1, 1, 3]);

─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   2 │
│                                   1 │
│                                   3 │
└─────────────────────────────────────┘

--Usando a query UNION ALL, une as planilhas e preserva as duplicadas:
SELECT UNNEST ([1, 1, 1, 2])
UNION ALL
SELECT UNNEST ([1, 1, 3]);

┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
│                                   1 │
│                                   1 │
│                                   2 │
│                                   1 │
│                                   1 │
│                                   3 │
└─────────────────────────────────────┘

--INTERSECT query, tras a interserccao entre as planilhas e remove duplicacoes:

SELECT UNNEST ([1, 1, 1, 2])
INTERSECT
SELECT UNNEST ([1, 1, 3]);

┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
└─────────────────────────────────────┘
--INTERSECT ALL, retorna da interseccao e preserva as duplicac0es:
SELECT UNNEST ([1, 1, 1, 2])
    INTERSECT ALL
SELECT UNNEST ([1, 1, 3]);
┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   1 │
│                                   1 │
└─────────────────────────────────────┘

--EXCEPT , retorna o que tem somente na tabela A e remove duplicadas

SELECT UNNEST ([1, 1, 1, 2])
EXCEPT
SELECT UNNEST ([1, 1, 3]);

┌─────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2)) │
│                int32                │
├─────────────────────────────────────┤
│                                   2 │
└─────────────────────────────────────┘

--EXPECT ALL retorna itens da primeira tabela e remove duplicadas comparando as planilhas, como o 1 aparece 3 vezes na planilha A, ele vai retornar 1 como resultado:
SELECT UNNEST ([1, 1, 1, 2, 4])
EXCEPT ALL
SELECT UNNEST ([1, 1, 3]);

┌────────────────────────────────────────┐
│ unnest(main.list_value(1, 1, 1, 2, 4)) │
│                 int32                  │
├────────────────────────────────────────┤
│                                      1 │
│                                      2 │
│                                      4 │
└────────────────────────────────────────┘

-- Exemplo final:
    -- WHICH unique job postings appeared in either 2023 or 2024?
    -- WHICH job postings appeared across both years, counting duplicates?
    -- WHICH job postings appeared in both 2023 and 2024?
    -- WHICH job postings appeared in both years, preserving duplicate counts?
    -- WHICH job postings appeared in 2023 but not in 2024?
    -- WHICH job postings appeared more times in 2023 than 2024, one-for-one?

    CREATE TEMP TABLE jobs_2023 AS
    SELECT * EXCLUDE (job_id, job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT (YEAR FROM job_posted_date) = 2023;

    SELECT * FROM jobs_2023;

    CREATE TEMP TABLE jobs_2024 AS
    SELECT * EXCLUDE (job_id, job_posted_date)
    FROM job_postings_fact
    WHERE EXTRACT (YEAR FROM job_posted_date) = 2024;

    SELECT * FROM jobs_2024;


-- WHICH unique job postings appeared in either 2023 or 2024?
SELECT * FROM jobs_2023
UNION
SELECT * FROM jobs_2024;


    -- WHICH job postings appeared across both years, counting duplicates?

SELECT * FROM jobs_2023
UNION ALL
SELECT * FROM jobs_2024;

    -- WHICH job postings appeared in 2023 but not in 2024?

SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

    -- WHICH job postings appeared more times in 2023 than 2024, one-for-one?

SELECT * FROM jobs_2023
EXCEPT ALL
SELECT * FROM jobs_2024;

 -- WHICH job postings appeared in both 2023 and 2024?

 SELECT * FROM jobs_2023
INTERSECT
SELECT * FROM jobs_2024;

    -- WHICH job postings appeared in both years, preserving duplicate counts?

SELECT * FROM jobs_2023
INTERSECT ALL
SELECT * FROM jobs_2024;