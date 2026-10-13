CREATE SCHEMA IF NOT EXISTS redis;

CREATE UNLOGGED TABLE IF NOT EXISTS redis.sets (
    key TEXT PRIMARY KEY,
    members TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    expires_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_sets_members ON redis.sets USING gin (members);
CREATE INDEX IF NOT EXISTS idx_sets_expiry ON redis.sets (expires_at) WHERE expires_at IS NOT NULL;