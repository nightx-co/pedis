CREATE SCHEMA IF NOT EXISTS redis;

CREATE UNLOGGED TABLE IF NOT EXISTS redis.zsets (
    key TEXT PRIMARY KEY,
    scored_members JSONB NOT NULL DEFAULT '[]'::jsonb,
    expires_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_zsets_members ON redis.zsets USING gin (scored_members);
CREATE INDEX IF NOT EXISTS idx_zsets_expiry ON redis.zsets (expires_at) WHERE expires_at IS NOT NULL;