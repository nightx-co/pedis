## [Unreleased]

### Added

- **Redis Hash Functions**: Implemented PL/pgSQL functions for PostgreSQL-backed Redis hash operations:
  - `redis.hdel`: Deletes a field from a hash and removes the hash key entirely if no fields remain.
  - `redis.hget`: Retrieves the value of a specific field from a hash.
  - `redis.hgetall`: Returns all fields and values of a hash as a JSONB object, or an empty JSONB object if the hash doesn't exist.
  - `redis.hincrby`: Increments the integer value of a hash field by a given amount, creating the hash or field if it does not already exist.
  - `redis.hset`: Sets the string value of a hash field with optional TTL support in seconds.
- **TTL & Expiration Handling (Hashes)**: Integrated automatic cleanup checks for expired keys based on `expires_at` timestamps across all hash operations.

- **Redis List Functions**: Implemented PL/pgSQL functions for PostgreSQL-backed Redis list operations:
  - `redis.llen`: Returns the length of a list, or 0 if the list does not exist.
  - `redis.lpop`: Removes and returns the first element of a list, deleting the list key if it was the last element.
  - `redis.lpush`: Inserts a member at the head of a list with optional TTL support, creating the list if it doesn't exist.
  - `redis.lrange`: Returns a specified range of elements from a list based on start and stop indices.
  - `redis.rpop`: Removes and returns the last element of a list, deleting the list key if it was the last element.
  - `redis.rpush`: Appends a member to the tail of a list with optional TTL support, creating the list if it doesn't exist.
- **TTL & Expiration Handling (Lists)**: Integrated automatic cleanup checks for expired keys based on `expires_at` timestamps across all list operations.

- **Redis Set Functions**: Implemented PL/pgSQL functions for PostgreSQL-backed Redis set operations:
  - `redis.sadd`: Adds a member to a set with optional TTL support, avoiding duplicate entries.
  - `redis.scard`: Returns the cardinality (number of members) of a set, or 0 if the set does not exist.
  - `redis.sismember`: Checks if a value is a member of a set, returning 1 if it exists or 0 otherwise.
  - `redis.smembers`: Returns all members of a set as an array, or an empty array if the set doesn't exist.
  - `redis.srem`: Removes a member from a set and deletes the set key entirely if no members remain.
- **TTL & Expiration Handling (Sets)**: Integrated automatic cleanup checks for expired keys based on `expires_at` timestamps across all set operations.

- **Redis String Functions**: Implemented PL/pgSQL functions for PostgreSQL-backed Redis string operations:
    * `redis.get_string`: Retrieves the string value of a key after cleaning up expired keys.
    * `redis.incr_string`: Increments the integer value of a string key by a specified increment amount, creating it if it does not exist.
    * `redis.set_string`: Sets the string value of a key with optional TTL support in seconds.
    * `redis.setnx_string`: Sets the string value of a key with optional TTL support only if the key does not already exist.

- **Redis Sorted Set Functions**: Implemented PL/pgSQL functions for PostgreSQL-backed Redis sorted set operations:
    * `redis.zadd`: Adds a member with a score to a sorted set with optional TTL support, updating existing members and returning 1 if added or 0 if updated.
    * `redis.zcard`: Returns the cardinality (number of elements) of a sorted set, or 0 if the sorted set does not exist.
    * `redis.zrange`: Returns a range of members from a sorted set ordered by score ascending and member name, or an empty array if not found.
    * `redis.zscore`: Returns the score of a specific member in a sorted set.