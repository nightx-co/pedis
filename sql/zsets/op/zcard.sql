CREATE OR REPLACE FUNCTION redis.zcard(p_key TEXT) 
RETURNS INT AS $$
DECLARE
    v_count INT;
BEGIN
    DELETE FROM redis.zsets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT jsonb_array_length(scored_members) INTO v_count
    FROM redis.zsets
    WHERE key = p_key;

    RETURN COALESCE(v_count, 0);
END;
$$ LANGUAGE plpgsql;