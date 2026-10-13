CREATE OR REPLACE FUNCTION redis.incr_string(
    p_key TEXT, 
    p_increment BIGINT DEFAULT 1
) 
RETURNS BIGINT AS $$
DECLARE
    v_new_val BIGINT;
BEGIN
    INSERT INTO redis.strings (key, value, expires_at)
    VALUES (p_key, p_increment::TEXT, NULL)
    ON CONFLICT (key) DO UPDATE 
    SET value = (
        COALESCE(NULLIF(redis.strings.value, '')::BIGINT, 0) + p_increment
    )::TEXT
    RETURNING value::BIGINT INTO v_new_val;

    RETURN v_new_val;
END;
$$ LANGUAGE plpgsql;