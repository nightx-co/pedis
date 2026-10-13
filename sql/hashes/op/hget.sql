CREATE OR REPLACE FUNCTION redis.hget(p_key TEXT, p_field TEXT) 
RETURNS TEXT AS $$
DECLARE
    v_val TEXT;
BEGIN
    DELETE FROM redis.hashes WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT fields ->> p_field INTO v_val
    FROM redis.hashes
    WHERE key = p_key;

    RETURN v_val;
END;
$$ LANGUAGE plpgsql;