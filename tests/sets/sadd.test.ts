import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.sadd function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/sets/setup.sql');
        await runSqlFile('sql/sets/op/sadd.sql');
    })

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

    it('should add a new member to a set and return 1, and return 0 for duplicates', async () => {
        const res1 = await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);
        expect(Number(res1.rows[0].sadd)).toBe(1);

        const res2 = await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);
        expect(Number(res2.rows[0].sadd)).toBe(0);
    })
})