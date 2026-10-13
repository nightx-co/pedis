import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.setnx_string function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/strings/setup.sql');
        await runSqlFile('sql/strings/op/setnx.sql');
        await runSqlFile('sql/strings/op/get.sql');
    })

    beforeEach(async () => {
        await pool.query('BEGIN;');
    })

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    })

    afterAll(async () => {
        await pool.end();
    })

    it('should acquire lock when key does not exist and fail when it does', async () => {
        const firstAttempt = await pool.query(
            'SELECT redis.setnx_string($1, $2, $3) AS lock_acquired;',
            ['lock:resource', 'process_1', 30]
        )
        expect(firstAttempt.rows[0].lock_acquired).toBe(true);

        const secondAttempt = await pool.query(
            'SELECT redis.setnx_string($1, $2, $3) AS lock_acquired;',
            ['lock:resource', 'process_2', 30]
        )
        expect(secondAttempt.rows[0].lock_acquired).toBe(false);

        const holder = await pool.query('SELECT redis.get_string($1) AS current_holder;', [ 'lock:resource' ]);
        expect(holder.rows[0].current_holder).toBe('process_1');
    })
})