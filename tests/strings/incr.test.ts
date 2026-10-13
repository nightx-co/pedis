import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.incr_string function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/strings/setup.sql');
        await runSqlFile('sql/strings/op/incr-decr.sql');
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

    it('should initialize a new counter and increment it', async () => {
        const res1 = await pool.query('SELECT redis.incr_string($1, $2) AS views_after_1;', [
            'page:views',
            1
        ])

        expect(res1.rows[0].views_after_1).toBe('1');

        const res2 = await pool.query('SELECT redis.incr_string($1, $2) AS views_after_5;', [
            'page:views',
            5
        ])

        expect(res2.rows[0].views_after_5).toBe('6');
    })
})