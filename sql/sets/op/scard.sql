CREATE OR REPLACE FUNCTION redis.scard(p_key TEXT) 
RETURNS INT AS $$
DECLARE
    v_count INT;
BEGIN
    DELETE FROM redis.sets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT cardinality(members) INTO v_count
    FROM redis.sets
    WHERE key = p_key;

    RETURN COALESCE(v_count, 0);
END;
$$ LANGUAGE plpgsql;