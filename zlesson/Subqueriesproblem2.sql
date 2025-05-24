SELECT
    cd.company_id,
    cd.name,
    job_count,
    CASE
        WHEN job_count BETWEEN 0 AND 9 THEN 'Small'
        WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size_category
FROM
    company_dim cd
LEFT JOIN (
    SELECT
        company_id,
        COUNT(*) AS job_count
    FROM
        job_postings_fact
    GROUP BY
        company_id

) AS job_count ON cd.company_id = job_count.company_id

ORDER BY
    job_count DESC;