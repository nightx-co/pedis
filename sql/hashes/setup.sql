CREATE SCHEMA IF NOT EXISTS redis;

CREATE UNLOGGED TABLE IF NOT EXISTS redis.hashes (
    key TEXT PRIMARY KEY,
    fields JSONB NOT NULL DEFAULT '{}'::jsonb,
    expires_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_hashes_fields ON redis.hashes USING gin (fields);
CREATE INDEX IF NOT EXISTS idx_hashes_expiry ON redis.hashes (expires_at) WHERE expires_at IS NOT NULL;