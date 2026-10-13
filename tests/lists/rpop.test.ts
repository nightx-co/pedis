import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.rpop function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/lpush.sql');
        await runSqlFile('sql/lists/op/rpop.sql');
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

    it('should pop the rightmost element from the list', async () => {
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_2']);
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_1']);

        const res = await pool.query('SELECT redis.rpop($1) AS popped_right;', ['my:queue']);
        expect(res.rows[0].popped_right).toBe('task_2');
    })
})