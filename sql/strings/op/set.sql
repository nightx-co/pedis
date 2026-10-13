CREATE OR REPLACE FUNCTION redis.set_string(
    p_key TEXT, 
    p_value TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS VOID AS $$
BEGIN
    INSERT INTO redis.strings (key, value, expires_at)
    VALUES (
        p_key, 
        p_value, 
        CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
    )
    ON CONFLICT (key) DO UPDATE 
    SET value = EXCLUDED.value,
        expires_at = EXCLUDED.expires_at;
END;
$$ LANGUAGE plpgsql;