CREATE OR REPLACE FUNCTION redis.hgetall(p_key TEXT) 
RETURNS JSONB AS $$
DECLARE
    v_fields JSONB;
BEGIN
    DELETE FROM redis.hashes WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT fields INTO v_fields
    FROM redis.hashes
    WHERE key = p_key;

    RETURN COALESCE(v_fields, '{}'::jsonb);
END;
$$ LANGUAGE plpgsql;