CREATE OR REPLACE FUNCTION redis.hset(
    p_key TEXT, 
    p_field TEXT, 
    p_value TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS VOID AS $$
BEGIN
    DELETE FROM redis.hashes WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    INSERT INTO redis.hashes (key, fields, expires_at)
    VALUES (
        p_key, 
        jsonb_build_object(p_field, p_value), 
        CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
    )
    ON CONFLICT (key) DO UPDATE 
    SET fields = jsonb_set(redis.hashes.fields, ARRAY[p_field], to_jsonb(p_value), true),
        expires_at = COALESCE(EXCLUDED.expires_at, redis.hashes.expires_at);
END;
$$ LANGUAGE plpgsql;