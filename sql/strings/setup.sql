CREATE SCHEMA IF NOT EXISTS redis;

CREATE UNLOGGED TABLE IF NOT EXISTS redis.strings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    expires_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_strings_expiry ON redis.strings (expires_at) WHERE expires_at IS NOT NULL;