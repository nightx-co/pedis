CREATE OR REPLACE FUNCTION redis.hincrby(
    p_key TEXT, 
    p_field TEXT, 
    p_increment BIGINT
) 
RETURNS BIGINT AS $$
DECLARE
    v_new_val BIGINT;
BEGIN
    DELETE FROM redis.hashes WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    INSERT INTO redis.hashes (key, fields, expires_at)
    VALUES (
        p_key, 
        jsonb_build_object(p_field, p_increment::TEXT), 
        NULL
    )
    ON CONFLICT (key) DO UPDATE 
    SET fields = jsonb_set(
        redis.hashes.fields, 
        ARRAY[p_field], 
        to_jsonb(
            (COALESCE(NULLIF(redis.hashes.fields ->> p_field, '')::BIGINT, 0) + p_increment)::TEXT
        ), 
        true
    )
    RETURNING (fields ->> p_field)::BIGINT INTO v_new_val;

    RETURN v_new_val;
END;
$$ LANGUAGE plpgsql;