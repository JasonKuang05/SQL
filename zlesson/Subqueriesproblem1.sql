SELECT 
    sd.skill_id,
    sd.skills AS skill_name,
    skill_count
FROM 
    skills_dim sd
JOIN (
    -- Subquery to count skill occurrences and get top 5
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM 
        skills_job_dim
    GROUP BY 
        skill_id
    ORDER BY 
        skill_count DESC
    LIMIT 5
) AS skill_count ON sd.skill_id = skill_count.skill_id
ORDER BY 
    skill_count DESC;