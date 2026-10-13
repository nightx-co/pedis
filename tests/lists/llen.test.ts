import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.llen function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/lists/setup.sql');
        await runSqlFile('sql/lists/op/lpush.sql');
        await runSqlFile('sql/lists/op/llen.sql');
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

    it('should return the correct length of a list', async () => {
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_2']);
        await pool.query('SELECT redis.lpush($1, $2);', ['my:queue', 'task_1']);

        const res = await pool.query('SELECT redis.llen($1) AS queue_length;', ['my:queue']);
        expect(Number(res.rows[0].queue_length)).toBe(2);
    })

    it('should return 0 for non-existent lists', async () => {
        const res = await pool.query('SELECT redis.llen($1) AS queue_length;', ['non_existent']);
        expect(Number(res.rows[0].queue_length)).toBe(0);
    })
})