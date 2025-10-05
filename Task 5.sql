use football_db;
#Which referees issue the most yellow/red cards?
SELECT 
    referee,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards,
    COUNT(DISTINCT game_id) AS games_officiated
FROM football
GROUP BY referee
ORDER BY total_yellow_cards DESC, total_red_cards DESC;

#Do referees favor home or away teams in fouls or cards?
SELECT 
    referee,
    SUM(CASE WHEN player_name_x IN (
        SELECT player_name_x FROM football WHERE home_club_name IS NOT NULL
    ) AND home_club_name = home_club_name THEN yellow_cards ELSE 0 END) AS home_yellow_cards,
    SUM(CASE WHEN away_club_name IS NOT NULL AND away_club_name = away_club_name THEN yellow_cards ELSE 0 END) AS away_yellow_cards,
    SUM(CASE WHEN player_name_x IN (
        SELECT player_name_x FROM football WHERE home_club_name IS NOT NULL
    ) AND home_club_name = home_club_name THEN red_cards ELSE 0 END) AS home_red_cards,
    SUM(CASE WHEN away_club_name IS NOT NULL AND away_club_name = away_club_name THEN red_cards ELSE 0 END) AS away_red_cards
FROM football
GROUP BY referee;

#Is there a significant difference between referees’ decisions across leagues?
SELECT 
    referee,
    competition_type,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards,
    COUNT(DISTINCT game_id) AS games_officiated
FROM football
GROUP BY referee, competition_type
ORDER BY referee, competition_type;

