import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.rpush function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/rpush.sql');
    })

    beforeEach(async () => {
        await pool.query('BEGIN;');
        await pool.query("DELETE FROM redis.lists WHERE key = 'my:queue';");
    })

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    })

    afterAll(async () => {
        await pool.end();
    })

    it('should append elements to the right of a list and return the new length', async () => {
        const res = await pool.query('SELECT redis.rpush($1, $2);', ['my:queue', 'task_3']);
        expect(Number(res.rows[0].rpush)).toBe(1);
    })
})