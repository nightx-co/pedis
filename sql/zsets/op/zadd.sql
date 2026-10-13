CREATE OR REPLACE FUNCTION redis.zadd(
    p_key TEXT, 
    p_score DOUBLE PRECISION, 
    p_member TEXT, 
    p_ttl_seconds INT DEFAULT NULL
) 
RETURNS INT AS $$
DECLARE
    v_exists BOOLEAN;
    v_res INT;
BEGIN
    DELETE FROM redis.zsets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    LOOP
        SELECT EXISTS (
            SELECT 1 FROM redis.zsets, jsonb_array_elements(scored_members) elem 
            WHERE key = p_key AND elem ->> 'member' = p_member
        ) INTO v_exists;

        UPDATE redis.zsets 
        SET scored_members = (
            SELECT jsonb_agg(
                CASE 
                    WHEN elem ->> 'member' = p_member THEN jsonb_build_object('member', p_member, 'score', p_score)
                    ELSE elem 
                END
            )
            FROM jsonb_array_elements(scored_members) elem
        ),
        expires_at = COALESCE(CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END, expires_at)
        WHERE key = p_key;

        IF FOUND THEN
            v_res := CASE WHEN v_exists THEN 0 ELSE 1 END;
            IF NOT v_exists THEN
                UPDATE redis.zsets 
                SET scored_members = scored_members || jsonb_build_object('member', p_member, 'score', p_score)
                WHERE key = p_key;
            END IF;
            EXIT;
        END IF;

        BEGIN
            INSERT INTO redis.zsets (key, scored_members, expires_at)
            VALUES (
                p_key, 
                jsonb_build_array(jsonb_build_object('member', p_member, 'score', p_score)),
                CASE WHEN p_ttl_seconds IS NOT NULL THEN NOW() + (p_ttl_seconds || ' seconds')::INTERVAL ELSE NULL END
            );
            v_res := 1;
            EXIT;
        EXCEPTION WHEN unique_violation THEN
            CONTINUE;
        END;
    END LOOP;

    RETURN v_res;
END;
$$ LANGUAGE plpgsql;