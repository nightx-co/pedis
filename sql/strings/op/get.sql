CREATE OR REPLACE FUNCTION redis.get_string(p_key TEXT) 
RETURNS TEXT AS $$
DECLARE
    v_value TEXT;
BEGIN
    DELETE FROM redis.strings 
    WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT value INTO v_value
    FROM redis.strings
    WHERE key = p_key;

    RETURN v_value;
END;
$$ LANGUAGE plpgsql;