-- ==========================================
-- LOAD TEST & THROUGHPUT BENCHMARK: LISTS
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
    RAISE NOTICE 'STARTING LIST EMULATION LOAD TEST (% iterations)', v_iterations;
    RAISE NOTICE '==================================================';

    -- Clean slate before testing
    DELETE FROM redis.lists WHERE key LIKE 'bench:list:%';

    -- ----------------------------------------------------
    -- 1. BENCHMARK: LPUSH (Pushing elements to the left)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.lpush('bench:list:queue', 'task_' || v_i);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[LPUSH]    Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 2. BENCHMARK: LLEN (Checking list length)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.llen('bench:list:queue');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[LLEN]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 3. BENCHMARK: LRANGE (Fetching ranges)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.lrange('bench:list:queue', 0, 10);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[LRANGE]   Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 4. BENCHMARK: LPOP / RPOP (Popping elements)
    -- ----------------------------------------------------
    -- Populate a dedicated list for pop testing
    DELETE FROM redis.lists WHERE key = 'bench:list:pop';
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.lpush('bench:list:pop', 'item_' || v_i);
    END LOOP;

    v_start_time := clock_timestamp();
    -- Split iterations evenly between left and right pops (total 10k operations)
    FOR v_i IN 1..(v_iterations / 2) LOOP
        PERFORM redis.lpop('bench:list:pop');
        PERFORM redis.rpop('bench:list:pop');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[L/RPOP]   Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    RAISE NOTICE '==================================================';
    RAISE NOTICE 'LIST LOAD TEST COMPLETED SUCCESSFULLY';
    RAISE NOTICE '==================================================';
END $$;