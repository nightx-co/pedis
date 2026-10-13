-- Clean slate
DELETE FROM redis.zsets WHERE key = 'leaderboard:weekly:2026-W15';

--- 1. Recording Player High Scores (ZADD) ---
SELECT redis.zadd('leaderboard:weekly:2026-W15', 4850.0, 'user_sarah') AS added_sarah;
SELECT redis.zadd('leaderboard:weekly:2026-W15', 9200.5, 'user_alex') AS added_alex;
SELECT redis.zadd('leaderboard:weekly:2026-W15', 6100.0, 'user_ken') AS added_ken;

-- Player Sarah beats her old score and updates it
SELECT redis.zadd('leaderboard:weekly:2026-W15', 9800.0, 'user_sarah') AS updated_sarah_score;

--- 2. Checking Total Competitors (ZCARD) ---
SELECT redis.zcard('leaderboard:weekly:2026-W15') AS active_players;

--- 3. Looking Up a Specific Player's Score (ZSCORE) ---
SELECT redis.zscore('leaderboard:weekly:2026-W15', 'user_ken') AS ken_score;

--- 4. Fetching the Full Ranked Leaderboard (ZRANGE) ---
SELECT redis.zrange('leaderboard:weekly:2026-W15', 0, -1) AS full_leaderboard_standings;