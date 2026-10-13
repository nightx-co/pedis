CREATE OR REPLACE FUNCTION redis.sismember(p_key TEXT, p_member TEXT) 
RETURNS INT AS $$
DECLARE
    v_exists BOOLEAN;
BEGIN
    DELETE FROM redis.sets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT (p_member = ANY(members)) INTO v_exists
    FROM redis.sets
    WHERE key = p_key;

    RETURN CASE WHEN COALESCE(v_exists, FALSE) THEN 1 ELSE 0 END;
END;
$$ LANGUAGE plpgsql;