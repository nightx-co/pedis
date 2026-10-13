CREATE OR REPLACE FUNCTION redis.sadd(
    p_key TEXT, 
    p_member TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS INT AS $$
DECLARE
    v_added INT := 0;
BEGIN
    DELETE FROM redis.sets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    LOOP
        UPDATE redis.sets 
        SET members = array_append(members, p_member),
            expires_at = COALESCE(CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END, expires_at)
        WHERE key = p_key AND NOT (p_member = ANY(members));

        IF FOUND THEN
            v_added := 1;
            EXIT;
        END IF;

        IF EXISTS (SELECT 1 FROM redis.sets WHERE key = p_key AND p_member = ANY(members)) THEN
            v_added := 0;
            EXIT;
        END IF;

        BEGIN
            INSERT INTO redis.sets (key, members, expires_at)
            VALUES (
                p_key, 
                ARRAY[p_member], 
                CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
            );
            v_added := 1;
            EXIT;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;

    RETURN v_added;
END;
$$ LANGUAGE plpgsql;