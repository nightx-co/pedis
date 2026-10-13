CREATE OR REPLACE FUNCTION redis.rpush(
    p_key TEXT, 
    p_member TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS INT AS $$
DECLARE
    v_new_len INT;
BEGIN
    DELETE FROM redis.lists WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    LOOP
        UPDATE redis.lists 
        SET items = array_append(items, p_member),
            expires_at = COALESCE(CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END, expires_at)
        WHERE key = p_key
        RETURNING cardinality(items) INTO v_new_len;

        IF FOUND THEN
            EXIT;
        END IF;

        BEGIN
            INSERT INTO redis.lists (key, items, expires_at)
            VALUES (
                p_key, 
                ARRAY[p_member], 
                CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
            )
            RETURNING cardinality(items) INTO v_new_len;
            EXIT;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;

    RETURN v_new_len;
END;
$$ LANGUAGE plpgsql;