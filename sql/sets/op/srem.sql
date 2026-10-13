CREATE OR REPLACE FUNCTION redis.srem(p_key TEXT, p_member TEXT) 
RETURNS INT AS $$
DECLARE
    v_removed INT := 0;
BEGIN
    DELETE FROM redis.sets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    UPDATE redis.sets
    SET members = array_remove(members, p_member)
    WHERE key = p_key AND p_member = ANY(members);

    IF FOUND THEN
        v_removed := 1;
        DELETE FROM redis.sets WHERE key = p_key AND cardinality(members) = 0;
    END IF;

    RETURN v_removed;
END;
$$ LANGUAGE plpgsql;