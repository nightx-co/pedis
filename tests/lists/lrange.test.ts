import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.lrange function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/lpush.sql');
        await runSqlFile('sql/lists/op/rpush.sql');
        await runSqlFile('sql/lists/op/lrange.sql');
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

    it('should fetch a subset or all elements using indices', async () => {
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_2']);
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_1']);
        await pool.query('SELECT redis.rpush($1, $2);', ['my:queue', 'task_3']);

        // Get all elements (0 to -1)
        const allRes = await pool.query('SELECT redis.lrange($1, $2, $3) AS entire_queue;', ['my:queue', 0, -1]);
        expect(allRes.rows[0].entire_queue).toEqual(['task_1', 'task_2', 'task_3']);

        // Get subset (0 to 1)
        const subRes = await pool.query('SELECT redis.lrange($1, $2, $3) AS subset_queue;', ['my:queue', 0, 1]);
        expect(subRes.rows[0].subset_queue).toEqual(['task_1', 'task_2']);
    })
})