SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS data,
    EXTRACT(MONTH FROM job_posted_date) AS MONTH,
    EXTRACT(YEAR FROM job_posted_date) AS YEAR
FROM
    job_postings_fact
LIMIT 5;