import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.lpush function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/lpush.sql');
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

    it('should prepend elements to a list and return the new length', async () => {
        const res1 = await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_2']);
        expect(Number(res1.rows[0].lpush)).toBe(1);

        const res2 = await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_1']);
        expect(Number(res2.rows[0].lpush)).toBe(2);
    })
})