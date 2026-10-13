-- ==========================================
-- LOAD TEST & THROUGHPUT BENCHMARK: HASHES
-- ==========================================

DO $$
DECLARE
    v_start_time timestamp;
    v_end_time timestamp;
    v_duration numeric;
    v_iterations integer := 10000; -- Increase or decrease as needed
    v_i integer;
    v_tps numeric;
BEGIN
    RAISE NOTICE '==================================================';
    RAISE NOTICE 'STARTING HASH EMULATION LOAD TEST (% iterations)', v_iterations;
    RAISE NOTICE '==================================================';

    -- Clean slate before testing
    DELETE FROM redis.hashes WHERE key LIKE 'bench:hash:%';

    -- ----------------------------------------------------
    -- 1. BENCHMARK: HSET (Setting Hash Fields)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.hset('bench:hash:' || v_i, 'field_1', 'val_' || v_i, 3600);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[HSET]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);

    -- ----------------------------------------------------
    -- 2. BENCHMARK: HGET (Getting a Single Field)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        -- Read randomly across the keys created above
        PERFORM redis.hget('bench:hash:' || (v_i % 1000 + 1), 'field_1');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[HGET]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);

    -- ----------------------------------------------------
    -- 3. BENCHMARK: HGETALL (Getting All Fields)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.hgetall('bench:hash:' || (v_i % 1000 + 1));
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[HGETALL]  Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);

    -- ----------------------------------------------------
    -- 4. BENCHMARK: HINCRBY (Incrementing a Hash Counter)
    -- ----------------------------------------------------
    -- Initialize a counter field first (Added missing semicolon below)
    PERFORM redis.hset('bench:hash:counter', 'hits', '0');

    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.hincrby('bench:hash:counter', 'hits', 1);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[HINCRBY]  Time: %s | Throughput: % TPS (Hot Counter)', round(v_duration, 4), round(v_tps, 2);

    -- ----------------------------------------------------
    -- 5. BENCHMARK: HDEL (Deleting a Hash Field)
    -- ----------------------------------------------------
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.hset('bench:hash:del:' || v_i, 'temp_field', 'value');
    END LOOP;

    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.hdel('bench:hash:del:' || v_i, 'temp_field');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[HDEL]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);

    RAISE NOTICE '==================================================';
    RAISE NOTICE 'HASH LOAD TEST COMPLETED SUCCESSFULLY';
    RAISE NOTICE '==================================================';
END $$;