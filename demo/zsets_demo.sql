-- Clean slate for the demo
DELETE FROM redis.zsets WHERE key = 'leaderboard:game';

--- 1. Adding Scored Members (ZADD) ---
-- Add players with scores (returns 1 for new entries)
SELECT redis.zadd('leaderboard:game', 1500.5, 'player_alice') AS added_alice;
SELECT redis.zadd('leaderboard:game', 2200.0, 'player_bob') AS added_bob;
SELECT redis.zadd('leaderboard:game', 1850.25, 'player_charlie') AS added_charlie;

-- Update existing player's score (returns 0 because member already existed)
SELECT redis.zadd('leaderboard:game', 2500.0, 'player_alice') AS updated_alice_score;


--- 2. Checking ZSet Size (ZCARD) ---
SELECT redis.zcard('leaderboard:game') AS total_players;


--- 3. Checking Member Score (ZSCORE) ---
SELECT redis.zscore('leaderboard:game', 'player_alice') AS alice_score;


--- 4. Fetching Sorted Members (ZRANGE) ---
SELECT redis.zrange('leaderboard:game', 0, -1) AS sorted_leaderboard;