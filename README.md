# Introduction
📊 Let's explore the data analytics job landscape! This project examines 💰 the highest-paying positions, 🔥 the most sought-after technical skills, and 📈 where lucrative opportunities intersect with high market demand.

🔍 SQL queries? Check them out here: [Project_sql folder](/Project_sql/)

# Background
This project started from a need to make smarter career decisions in the data analytics field. I wanted to identify which roles pay the most and what skills drive those salaries, so others can navigate the job market more strategically.

1. Which data analyst jobs offer the highest pay?
2. What technical skills do those top-paying positions require?
3. Which skills appear most frequently in data analyst job listings?
4. What skills correlate with the highest average salaries?
5. Which skills offer the best balance of demand and earning potential?

# Tools I Used
To thoroughly investigate the data analyst job market, I relied on several powerful tools:

- **SQL:** The foundation of my analysis, enabling me to extract meaningful insights from the database.
- **PostgreSQL:** My database system of choice, well-suited for managing and querying job posting data.
- **Visual Studio Code:** My primary environment for database management and running SQL scripts.
- **Git & GitHub:** Essential for version control, sharing my work, and facilitating collaboration.

# The Analysis
Each query in this project was designed to explore a different aspect of the data analyst job market. Here's my approach to each question:

### 1. Highest-Paying Data Analyst Jobs
To uncover the most lucrative roles, I filtered for data analyst positions with known annual salaries and a remote work location. This query highlights the top-paying opportunities currently available.

```sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Broad Salary Range:** Salaries for the top 10 positions span from $184,000 to $650,000, showing substantial earning potential in this field.
- **Varied Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering premium compensation, indicating widespread demand across sectors.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.


### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. Skills Required for Top-Paying Jobs

To identify the skills that employers value for premium roles, I combined job postings with skills data to see what technical expertise commands the highest compensation.

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023
- **SQL** and **Excel** remain foundational, emphasizing the continued importance of core data processing and spreadsheet skills.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are needed, reflecting the growing need for technical skills in data storytelling and decision-making.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Skills like PySpark, Couchbase, DataRobot, Jupyter, Pandas, and NumPy command top salaries, showing that employers highly value data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Familiarity with tools like GitLab, Kubernetes, and Airflow suggests a lucrative crossover with software engineering, emphasizing skills that streamline automation and data pipeline management.
- **Cloud Computing Expertise:**  Expertise in cloud and data engineering tools such as Elasticsearch, Databricks, and GCP highlights the increasing importance of cloud-based analytics
| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

*Table of the most optimal skills for data analyst sorted by salary*

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **High-Demand Programming Languages:** Python and R show strong demand with 236 and 148 mentions respectively, though their average salaries hover around $101,397 and $100,499, suggesting these skills are highly valued but widely available.
- **Cloud Tools and Technologies:** Skills like Snowflake, Azure, AWS, and BigQuery show notable demand with competitive salaries, highlighting the growing importance of cloud platforms and big data tools.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 and average salaries of $99,288 and $103,795, emphasize the critical role of data visualization and business intelligence in generating actionable insights.
- **Database Technologies:** Traditional and NoSQL databases (Oracle, SQL Server, NoSQL) remain relevant, with average salaries ranging from $97,786 to $104,534, reflecting the ongoing need for data storage and retrieval expertise.

# What I Learned

Through this project, I significantly strengthened my SQL capabilities:

- **🧩 Complex Query Crafting:** I became proficient in complex joins and using WITH clauses for creating temporary tables.
- **📊 Data Aggregation:** I gained experience with GROUP BY and aggregate functions like COUNT() and AVG() to summarize large datasets.
- **💡 Analytical Wizardry:** I sharpened my ability to translate analytical questions into effective SQL queries that generate actionable insights.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: Remote data analyst roles offer impressive salaries, with the highest reaching $650,000.
2. **Skills for Top-Paying Jobs**: Advanced SQL proficiency is a common requirement for top-paying roles, making it a crucial skill.
3. **Most In-Demand Skills**: SQL also tops the list of most requested skills overall, making it essential for any data analyst job seeker.
4. **Skills with Higher Salaries**: Niche skills like SVN and Solidity command the highest average salaries, indicating a premium on specialized expertise.
5. **Optimal Skills for Job Market Value**: SQL offers both high demand and competitive salaries, positioning it as one of the most valuable skills to master.
### Final Thoughts

This project not only enhanced my SQL skills but also provided practical insights into the data analyst job market. The findings can help guide skill development and job search strategies, enabling aspiring data analysts to better compete in the field. This experience underscores the importance of lifelong learning and staying current with evolving trends in data analytics.
