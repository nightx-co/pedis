CREATE OR REPLACE FUNCTION redis.hdel(p_key TEXT, p_field TEXT) 
RETURNS INT AS $$
DECLARE
    v_deleted INT := 0;
BEGIN
    DELETE FROM redis.hashes WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    UPDATE redis.hashes
    SET fields = fields - p_field
    WHERE key = p_key AND fields ? p_field;

    IF FOUND THEN
        v_deleted := 1;
        DELETE FROM redis.hashes WHERE key = p_key AND fields = '{}'::jsonb;
    END IF;

    RETURN v_deleted;
END;
$$ LANGUAGE plpgsql;