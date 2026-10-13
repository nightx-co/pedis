-- Clean slate for the demo
DELETE FROM redis.sets WHERE key IN ('online:users', 'tags:post:42');

--- 1. Adding Members to a Set (SADD) ---
-- Add unique users (returns 1 because they are new)
SELECT redis.sadd('online:users', 'alice') AS added_alice;
SELECT redis.sadd('online:users', 'bob') AS added_bob;
SELECT redis.sadd('online:users', 'charlie') AS added_charlie;

-- Try adding 'alice' again (should return 0 because she is already in the set)
SELECT redis.sadd('online:users', 'alice') AS added_alice_duplicate;


--- 2. Checking Set Size / Cardinality (SCARD) ---
SELECT redis.scard('online:users') AS total_online_users;


--- 3. Checking Membership (SISMEMBER) ---
-- Check if bob is online (returns 1)
SELECT redis.sismember('online:users', 'bob') AS is_bob_online;

-- Check if dave is online (returns 0)
SELECT redis.sismember('online:users', 'dave') AS is_dave_online;


--- 4. Fetching All Members (SMEMBERS) ---
SELECT redis.smembers('online:users') AS all_online_users;


--- 5. Removing a Member (SREM) ---
-- Remove charlie (returns 1)
SELECT redis.srem('online:users', 'charlie') AS removed_charlie;

-- Check updated member list
SELECT redis.smembers('online:users') AS users_after_removal;
SELECT redis.scard('online:users') AS updated_cardinality;