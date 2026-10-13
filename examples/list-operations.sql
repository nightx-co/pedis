-- Clean slate
DELETE FROM redis.lists WHERE key = 'queue:emails:outbound';

--- 1. Enqueueing Background Tasks (RPUSH) ---
-- Push notification payloads to the right side of the queue
SELECT redis.rpush('queue:emails:outbound', '{"to": "alice@example.com", "template": "welcome"}');
SELECT redis.rpush('queue:emails:outbound', '{"to": "bob@example.com", "template": "password_reset"}');
SELECT redis.rpush('queue:emails:outbound', '{"to": "charlie@example.com", "template": "invoice"}');

--- 2. Monitoring Queue Depth (LLEN) ---
SELECT redis.llen('queue:emails:outbound') AS pending_emails_count;

--- 3. Viewing Upcoming Jobs without Processing (LRANGE) ---
-- Inspect the next 2 jobs in line
SELECT redis.lrange('queue:emails:outbound', 0, 1) as next_jobs_batch;

--- 4. Worker Processing Jobs (LPOP) ---
-- Worker pulls the oldest job from the left of the queue
SELECT redis.lpop('queue:emails:outbound') AS processed_job;

--- 5. Checking Remaining Queue State ---
SELECT redis.lrange('queue:emails:outbound', 0, -1) AS remaining_queue;
SELECT redis.llen('queue:emails:outbound') AS updated_queue_length;