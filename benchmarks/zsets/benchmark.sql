-- ==========================================
-- LOAD TEST & THROUGHPUT BENCHMARK: SORTED SETS (ZSETS)
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
    RAISE NOTICE 'STARTING ZSETS EMULATION LOAD TEST (% iterations)', v_iterations;
    RAISE NOTICE '==================================================';

    -- Clean slate before testing
    DELETE FROM redis.zsets WHERE key LIKE 'bench:zset:%';

    -- ----------------------------------------------------
    -- 1. BENCHMARK: ZADD (Adding/updating scored members)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.zadd('bench:zset:leaderboard', (v_i * 1.5)::numeric, 'player_' || v_i);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[ZADD]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 2. BENCHMARK: ZCARD (Checking sorted set size)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.zcard('bench:zset:leaderboard');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[ZCARD]    Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 3. BENCHMARK: ZSCORE (Checking member scores)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.zscore('bench:zset:leaderboard', 'player_' || (v_i % v_iterations + 1));
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[ZSCORE]   Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 4. BENCHMARK: ZRANGE (Fetching sorted ranges)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.zrange('bench:zset:leaderboard', 0, 10);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[ZRANGE]   Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 5. BENCHMARK: ZREM (Removing members)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.zrem('bench:zset:leaderboard', 'player_' || v_i);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[ZREM]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    RAISE NOTICE '==================================================';
    RAISE NOTICE 'ZSETS LOAD TEST COMPLETED SUCCESSFULLY';
    RAISE NOTICE '==================================================';
END $$;