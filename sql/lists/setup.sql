CREATE SCHEMA IF NOT EXISTS redis;

CREATE UNLOGGED TABLE IF NOT EXISTS redis.lists (
    key TEXT PRIMARY KEY,
    items TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    expires_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_lists_expiry ON redis.lists (expires_at) WHERE expires_at IS NOT NULL;