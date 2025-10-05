SELECT * FROM football_db.football;
# Do minutes played and competition type influence the number of goals/assists?
SELECT
    player_id_x,
    competition_type,
    CASE  
        WHEN minutes_played BETWEEN 0 AND 30 THEN '0-30'
        WHEN minutes_played BETWEEN 31 AND 60 THEN '31-60'
        WHEN minutes_played BETWEEN 61 AND 90 THEN '61-90'
        ELSE '91-120'
    END AS minutes_bucket,
    goals,
    assists
FROM football;

SELECT
    minutes_bucket,
    competition_type,
    AVG(goals) AS avg_goals,
    AVG(assists) AS avg_assists,
    AVG(goals + assists) AS avg_goal_assists
FROM (
    SELECT
        player_id_x,
        competition_type,
        CASE  
            WHEN minutes_played BETWEEN 0 AND 30 THEN '0-30'
            WHEN minutes_played BETWEEN 31 AND 60 THEN '31-60'
            WHEN minutes_played BETWEEN 61 AND 90 THEN '61-90'
            ELSE '91-120'
        END AS minutes_bucket,
        goals,
        assists
    FROM football
) sub
GROUP BY minutes_bucket, competition_type
ORDER BY minutes_bucket, competition_type;

select * from football;

use football_db;
#Who are the top scorers and assist providers across competitions?
SELECT 
    player_id_x,
    player_name_x,
    -- Home matches
    SUM(CASE WHEN home_club_name IS NOT NULL THEN goals + assists ELSE 0 END) AS home_goals_assists,
    SUM(CASE WHEN home_club_name IS NOT NULL THEN minutes_played ELSE 0 END) AS home_minutes,
    -- Away matches
    SUM(CASE WHEN away_club_name IS NOT NULL THEN goals + assists ELSE 0 END) AS away_goals_assists,
    SUM(CASE WHEN away_club_name IS NOT NULL THEN minutes_played ELSE 0 END) AS away_minutes,
    -- Contribution per 90 minutes
    (SUM(CASE WHEN home_club_name IS NOT NULL THEN goals + assists ELSE 0 END) / NULLIF(SUM(CASE WHEN home_club_name IS NOT NULL THEN minutes_played ELSE 0 END)/90,0)) AS home_contribution_per_90,
    (SUM(CASE WHEN away_club_name IS NOT NULL THEN goals + assists ELSE 0 END) / NULLIF(SUM(CASE WHEN away_club_name IS NOT NULL THEN minutes_played ELSE 0 END)/90,0)) AS away_contribution_per_90
FROM football
GROUP BY player_id_x, player_name_x
ORDER BY (home_contribution_per_90 + away_contribution_per_90) DESC
LIMIT 10;

#Who are the top scorers and assist providers across competitions?
#Top Scorers (Goals)
SELECT 
    player_id_x,
    player_name_x,
    SUM(goals) AS total_goals
FROM football
GROUP BY player_id_x, player_name_x
ORDER BY total_goals DESC
LIMIT 10;
#Top Assist Providers
SELECT 
    player_id_x,
    player_name_x,
    SUM(assists) AS total_assists
FROM football
GROUP BY player_id_x, player_name_x
ORDER BY total_assists DESC
LIMIT 10;

#Combined Top Contributors (Goals + Assists)
SELECT 
    player_id_x,
    player_name_x,
    SUM(goals) AS total_goals,
    SUM(assists) AS total_assists,
    SUM(goals + assists) AS total_contribution
FROM football
GROUP BY player_id_x, player_name_x
ORDER BY total_contribution DESC
LIMIT 10;







