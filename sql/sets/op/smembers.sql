CREATE OR REPLACE FUNCTION redis.smembers(p_key TEXT) 
RETURNS TEXT[] AS $$
DECLARE
    v_members TEXT[];
BEGIN
    DELETE FROM redis.sets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT members INTO v_members
    FROM redis.sets
    WHERE key = p_key;

    RETURN COALESCE(v_members, ARRAY[]::TEXT[]);
END;
$$ LANGUAGE plpgsql;