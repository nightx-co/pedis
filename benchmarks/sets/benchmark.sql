-- ==========================================
-- LOAD TEST & THROUGHPUT BENCHMARK: SETS
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
    RAISE NOTICE 'STARTING SETS EMULATION LOAD TEST (% iterations)', v_iterations;
    RAISE NOTICE '==================================================';

    -- Clean slate before testing
    DELETE FROM redis.sets WHERE key LIKE 'bench:set:%';

    -- ----------------------------------------------------
    -- 1. BENCHMARK: SADD (Adding members to a set)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.sadd('bench:set:users', 'user_' || v_i);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[SADD]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 2. BENCHMARK: SCARD (Checking set cardinality/size)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.scard('bench:set:users');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[SCARD]    Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 3. BENCHMARK: SISMEMBER (Checking membership)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        -- Check half existing, half non-existing members
        PERFORM redis.sismember('bench:set:users', 'user_' || (v_i % (v_iterations + 500)));
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[SISMEMBER] Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 4. BENCHMARK: SMEMBERS (Fetching all members)
    -- ----------------------------------------------------
    -- Note: SMEMBERS on a large set can be heavy, adjust iterations if necessary
    v_start_time := clock_timestamp();
    FOR v_i IN 1..1000 LOOP -- Using 1000 iterations for broader payload queries
        PERFORM redis.smembers('bench:set:users');
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := 1000 / NULLIF(v_duration, 0);
    RAISE NOTICE '[SMEMBERS] Time: %s (1k iter) | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    -- ----------------------------------------------------
    -- 5. BENCHMARK: SREM (Removing members)
    -- ----------------------------------------------------
    v_start_time := clock_timestamp();
    FOR v_i IN 1..v_iterations LOOP
        PERFORM redis.srem('bench:set:users', 'user_' || v_i);
    END LOOP;
    v_end_time := clock_timestamp();
    v_duration := EXTRACT(EPOCH FROM (v_end_time - v_start_time));
    v_tps := v_iterations / NULLIF(v_duration, 0);
    RAISE NOTICE '[SREM]     Time: %s | Throughput: % TPS', round(v_duration, 4), round(v_tps, 2);


    RAISE NOTICE '==================================================';
    RAISE NOTICE 'SETS LOAD TEST COMPLETED SUCCESSFULLY';
    RAISE NOTICE '==================================================';
END $$;