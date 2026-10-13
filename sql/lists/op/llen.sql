CREATE OR REPLACE FUNCTION redis.llen(p_key TEXT) 
RETURNS INT AS $$
DECLARE
    v_len INT;
BEGIN
    DELETE FROM redis.lists WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT cardinality(items) INTO v_len
    FROM redis.lists
    WHERE key = p_key;

    RETURN COALESCE(v_len, 0);
END;
$$ LANGUAGE plpgsql;