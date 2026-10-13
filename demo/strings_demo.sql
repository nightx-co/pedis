-- ==========================================
-- DEMONSTRATION & USAGE: STRINGS
-- ==========================================

-- Clean slate for the demo
DELETE FROM redis.strings WHERE key IN ('session:token', 'page:views', 'lock:resource');

--- 1. Setting String Values (SET) ---
-- Set a simple key with no TTL
SELECT redis.set_string('session:token', 'abc123xyz');

-- Set a key with a 60-second TTL
SELECT redis.set_string('user:100:status', 'active', 60);


--- 2. Getting String Values (GET) ---
SELECT redis.get_string('session:token') AS session_value;
SELECT redis.get_string('user:100:status') AS user_status;


--- 3. Incrementing Counters (INCR / INCRBY) ---
-- Initialize a new counter key and increment by 1
SELECT redis.incr_string('page:views', 1) AS views_after_1;

-- Increment the existing counter by 5
SELECT redis.incr_string('page:views', 5) AS views_after_5;


--- 4. Setting if Not Exists (SETNX) ---
-- Try setting a lock key that doesn't exist yet (should return true/1)
SELECT redis.setnx_string('lock:resource', 'process_1', 30) AS lock_acquired_first_time;

-- Try setting the same lock key again while it exists (should return false/0)
SELECT redis.setnx_string('lock:resource', 'process_2', 30) AS lock_acquired_second_time;

-- Verify who currently holds the lock
SELECT redis.get_string('lock:resource') AS current_lock_holder;