CREATE OR REPLACE FUNCTION redis.lrange(p_key TEXT, p_start INT, p_stop INT) 
RETURNS TEXT[] AS $$
DECLARE
    v_items TEXT[];
    v_len INT;
    v_pg_start INT;
    v_pg_stop INT;
BEGIN
    DELETE FROM redis.lists WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT items, cardinality(items) INTO v_items, v_len
    FROM redis.lists
    WHERE key = p_key;

    IF v_items IS NULL OR v_len = 0 THEN
        RETURN ARRAY[]::TEXT[];
    END IF;

    IF p_start < 0 THEN p_start := v_len + p_start; END IF;
    IF p_stop < 0 THEN p_stop := v_len + p_stop; END IF;

    IF p_start < 0 THEN p_start := 0; END IF;
    IF p_stop >= v_len THEN p_stop := v_len - 1; END IF;

    IF p_start > p_stop OR p_start >= v_len THEN
        RETURN ARRAY[]::TEXT[];
    END IF;

    v_pg_start := p_start + 1;
    v_pg_stop := p_stop + 1;

    RETURN v_items[v_pg_start:v_pg_stop];
END;
$$ LANGUAGE plpgsql;