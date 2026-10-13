import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.lpop function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/lpush.sql');
        await runSqlFile('sql/lists/op/lpop.sql');
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

    it('should pop the leftmost element from the list', async () => {
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_2']);
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_1']);

        const res = await pool.query('SELECT redis.lpop($1) AS popped_left;', ['my:queue']);
        expect(res.rows[0].popped_left).toBe('task_1');
    })
})