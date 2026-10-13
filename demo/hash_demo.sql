DELETE FROM redis.hashes WHERE key = 'user:1000';

--- 1. Setting Hash Fields (HSET) ---
SELECT redis.hset('user:1000', 'name', 'Alice', 3600);
SELECT redis.hset('user:1000', 'email', 'alice@example.com');
SELECT redis.hset('user:1000', 'login_count', '5');

--- 2. Getting a Single Field (HGET) ---
SELECT redis.hget('user:1000', 'name') AS user_name;

--- 3. Getting All Fields (HGETALL) ---
SELECT redis.hgetall('user:1000') AS full_user_hash;

--- 4. Incrementing a Field Counter (HINCRBY) ---
SELECT redis.hincrby('user:1000', 'login_count', 1) AS new_login_count;

--- 5. Deleting a Field (HDEL) ---
SELECT redis.hdel('user:1000', 'email') AS deleted_count;

--- 6. Final State of the Hash ---
SELECT redis.hgetall('user:1000') AS final_hash_state;