import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.smembers function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/sets/setup.sql');
        await runSqlFile('sql/sets/op/sadd.sql');
        await runSqlFile('sql/sets/op/smembers.sql');
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

    it('should return all members of a set', async () => {
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_b']);

        const res = await pool.query('SELECT redis.smembers($1) AS all_members;', ['my:set']);
        expect(res.rows[0].all_members).toEqual(expect.arrayContaining(['member_a', 'member_b']));
    })

    it('should return an empty array for non-existent sets', async () => {
        const res = await pool.query('SELECT redis.smembers($1) AS all_members;', ['non_existent']);
        expect(res.rows[0].all_members).toEqual([]);
    })
})