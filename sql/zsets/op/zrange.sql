CREATE OR REPLACE FUNCTION redis.zrange(p_key TEXT, p_start INT, p_stop INT) 
RETURNS TEXT[] AS $$
DECLARE
    v_members TEXT[];
BEGIN
    DELETE FROM redis.zsets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT ARRAY_AGG(elem ->> 'member') INTO v_members
    FROM (
        SELECT elem 
        FROM redis.zsets, jsonb_array_elements(scored_members) elem
        WHERE key = p_key
        ORDER BY (elem ->> 'score')::DOUBLE PRECISION ASC, (elem ->> 'member') ASC
    ) sub;

    IF v_members IS NULL THEN
        RETURN ARRAY[]::TEXT[];
    END IF;

    RETURN v_members;
END;
$$ LANGUAGE plpgsql;