SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' ) AS Month,
    COUNT(job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')AS job_posting_count
FROM
    job_postings_fact
WHERE
    job_posted_date >= '2023-01-01' AND
    job_posted_date < '2024-01-01'
GROUP BY
    Month
ORDER BY
    MONTH;
