import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.hincrby function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/hashes/setup.sql');
        await runSqlFile('sql/hashes/op/hset.sql');
        await runSqlFile('sql/hashes/op/hincrby.sql');
    });

    beforeEach(async () => {
        await pool.query('BEGIN;');
    });

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    });

    afterAll(async () => {
        await pool.end();
    });

    it('should initialize a new counter field and increment it correctly', async () => {
        // 1. Initialize / increment a non-existent field (starts from 0 + increment)
        const res1 = await pool.query(
            'SELECT redis.hincrby($1, $2, $3) AS new_login_count;',
            ['user:1000', 'login_count', 5]
        );

        expect(res1.rows).toHaveLength(1);
        expect(Number(res1.rows[0].new_login_count)).toBe(5);

        // 2. Increment the existing counter further
        const res2 = await pool.query(
            'SELECT redis.hincrby($1, $2, $3) AS new_login_count;',
            ['user:1000', 'login_count', 1]
        );

        expect(res2.rows).toHaveLength(1);
        expect(Number(res2.rows[0].new_login_count)).toBe(6); //[cite: 3]
    });
});