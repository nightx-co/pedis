CREATE OR REPLACE FUNCTION redis.zscore(p_key TEXT, p_member TEXT) 
RETURNS DOUBLE PRECISION AS $$
DECLARE
    v_score DOUBLE PRECISION;
BEGIN
    DELETE FROM redis.zsets WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT (elem ->> 'score')::DOUBLE PRECISION INTO v_score
    FROM redis.zsets, jsonb_array_elements(scored_members) elem
    WHERE key = p_key AND elem ->> 'member' = p_member;

    RETURN v_score;
END;
$$ LANGUAGE plpgsql;