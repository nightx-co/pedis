CREATE OR REPLACE FUNCTION redis.setnx_string(
    p_key TEXT, 
    p_value TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS BOOLEAN AS $$
DECLARE
    v_inserted BOOLEAN := FALSE;
BEGIN
    DELETE FROM redis.strings 
    WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    INSERT INTO redis.strings (key, value, expires_at)
    VALUES (
        p_key, 
        p_value, 
        CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
    )
    ON CONFLICT (key) DO NOTHING;

    IF FOUND THEN
        v_inserted := TRUE;
    END IF;

    RETURN v_inserted;
END;
$$ LANGUAGE plpgsql;