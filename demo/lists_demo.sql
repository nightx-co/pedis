-- Clean slate for the demo
DELETE FROM redis.lists WHERE key = 'my:queue';

--- 1. Pushing Elements (LPUSH / RPUSH) ---
-- Push items to the left (prepended)
SELECT redis.lpush('my:queue', 'task_2');
SELECT redis.lpush('my:queue', 'task_1'); -- list is now ['task_1', 'task_2']

-- Push items to the right (appended)
SELECT redis.rpush('my:queue', 'task_3'); -- list is now ['task_1', 'task_2', 'task_3']


--- 2. Checking List Length (LLEN) ---
SELECT redis.llen('my:queue') AS queue_length;

--- 3. Fetching Ranges (LRANGE) ---
-- Get all elements (0 to -1)
SELECT redis.lrange('my:queue', 0, -1) AS entire_queue;

-- Get subset (0 to 1)
SELECT redis.lrange('my:queue', 0, 1) AS subset_queue;


--- 4. Popping Elements (LPOP / RPOP) ---
-- Pop from left (removes 'task_1')
SELECT redis.lpop('my:queue') AS popped_left;

-- Pop from right (removes 'task_3')
SELECT redis.rpop('my:queue') AS popped_right;


--- 5. Final State of the List ---
SELECT redis.lrange('my:queue', 0, -1) AS final_queue_state;
SELECT redis.llen('my:queue') AS final_length;