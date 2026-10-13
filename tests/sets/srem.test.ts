import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.srem function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/sets/setup.sql');
        await runSqlFile('sql/sets/op/sadd.sql');
        await runSqlFile('sql/sets/op/srem.sql');
    });

    beforeEach(async () => {
        await pool.query('BEGIN;');
        await pool.query("DELETE FROM redis.sets WHERE key = 'my:set';");
    })

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    })

    afterAll(async () => {
        await pool.end();
    })

    it('should remove a member from a set and return 1, or 0 if not found', async () => {
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);

        const res1 = await pool.query('SELECT redis.srem($1, $2);', ['my:set', 'member_a']);
        expect(Number(res1.rows[0].srem)).toBe(1);

        const res2 = await pool.query('SELECT redis.srem($1, $2);', ['my:set', 'member_b']);
        expect(Number(res2.rows[0].srem)).toBe(0);
    })
})