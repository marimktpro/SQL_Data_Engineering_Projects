CREATE DATABASE IF NOT EXISTS jobs_mart

-- DROP DATABASE command to delete database 

SELECT *
FROM information_schema.schemata

USE jobs_mart
CREATE SCHEMA staging; 

-- DROP SCHEMA command to delete schema

--create tables COMMAND schema.tablename (column 1 DATA TYPE, col 2DATA TYPE);
CREATE TABLE staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT  
    *
FROM
    information_schema.tables
WHERE
    table_catalog = 'jobs_mart';

--to insert lines COMMAND schema.table_name (col1, col2,..) VALUES (value for col1, value col2'text')
INSERT INTO staging.preferred_roles (
    role_id,
    role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Engineer'),
    (3, 'Software Engineer');


SELECT*
FROM staging.priority_roles;

--to include column COMMAND schema.table_name ADD COLUMN col_name DATA TYPE;

ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

-- to update a cells specific 
UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id =1 OR role_id =2;

UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id =3;


ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles
SET priority_lvl =3
WHERE role_id =3;