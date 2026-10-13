-- Clean slate
DELETE FROM redis.sets WHERE key IN ('tags:article:101', 'active:room:lobby');

--- 1. Tagging Content (SADD) ---
-- Add descriptive category tags to an article
SELECT redis.sadd('tags:article:101', 'technology');
SELECT redis.sadd('tags:article:101', 'redis');
SELECT redis.sadd('tags:article:101', 'database');
-- Attempt adding a duplicate tag (returns 0)
SELECT redis.sadd('tags:article:101', 'redis') as duplicate_tag_added;

--- 2. Checking Total Unique Tags (SCARD) ---
SELECT redis.scard('tags:article:101') AS total_tags_count;

--- 3. Verifying Tag Association (SISMEMBER) ---
SELECT redis.sismember('tags:article:101', 'database') AS has_database_tag;
SELECT redis.sismember('tags:article:101', 'security') AS has_security_tag;

--- 4. Retrieving All Unique Tags (SMEMBERS) ---
SELECT redis.smembers('tags:article:101') AS all_article_tags;

--- 5. Removing an Obsolete Tag (SREM) ---
SELECT redis.srem('tags:article:101', 'technology') AS tag_removed;
SELECT redis.smembers('tags:article:101') AS tags_after_removal;