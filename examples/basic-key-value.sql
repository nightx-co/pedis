-- Clean slate
DELETE FROM redis.strings WHERE key IN ('rate:user:405:requests', 'auth:session:xyz987', 'lock:checkout:502');

--- 1. API Rate Limiting (Tracking requests with a TTL window) ---
-- Increment request count for user 405 (sets initial count to 1, or increments if exists)
SELECT redis.incr_string('rate:user:405:requests', 1) AS current_request_count;

-- Set a 60-second expiration window for the rate limit key if it's new
-- (In application code, you'd combine this or check TTL)
SELECT redis.set_string('rate:user:405:window', 'active', 60);

--- 2. Managing User Authentication Sessions ---
-- Store a secure session token expiring in 3600 seconds (1 hour)
SELECT redis.set_string('auth:session:xyz987', '{"user_id": 405, "role": "admin"}', 3600);

-- Retrieve and validate the session payload
SELECT redis.get_string('auth:session:xyz987') AS session_payload;

--- 3. Distributed Locking for Concurrency Control ---
-- Try to acquire a lock for processing order #502 (expires in 15 seconds)
SELECT redis.setnx_string('lock:checkout:502', 'worker_node_1', 15) AS lock_acquired;

-- Attempt a duplicate lock acquisition while order is being processed (returns 0)
SELECT redis.setnx_string('lock:checkout:502', 'worker_node_2', 15) AS lock_conflict;