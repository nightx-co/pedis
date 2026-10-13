import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.sismember function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/sets/setup.sql');
        await runSqlFile('sql/sets/op/sadd.sql');
        await runSqlFile('sql/sets/op/sismember.sql');
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

    it('should verify if a value is a member of the set', async () => {
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);

        const resExists = await pool.query('SELECT redis.sismember($1, $2) AS is_member;', ['my:set', 'member_a']);
        expect(Number(resExists.rows[0].is_member)).toBe(1);

        const resMissing = await pool.query('SELECT redis.sismember($1, $2) AS is_member;', ['my:set', 'member_b']);
        expect(Number(resMissing.rows[0].is_member)).toBe(0);
    })
})