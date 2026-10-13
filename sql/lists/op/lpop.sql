CREATE OR REPLACE FUNCTION redis.lpop(p_key TEXT) 
RETURNS TEXT AS $$
DECLARE
    v_item TEXT;
    v_len INT;
BEGIN
    DELETE FROM redis.lists WHERE key = p_key AND expires_at IS NOT NULL AND expires_at <= NOW();

    SELECT items[1], cardinality(items) INTO v_item, v_len
    FROM redis.lists
    WHERE key = p_key;

    IF v_item IS NULL THEN
        RETURN NULL;
    END IF;

    IF v_len = 1 THEN
        DELETE FROM redis.lists WHERE key = p_key;
    ELSE
        UPDATE redis.lists
        SET items = items[2:v_len]
        WHERE key = p_key;
    END IF;

    RETURN v_item;
END;
$$ LANGUAGE plpgsql;