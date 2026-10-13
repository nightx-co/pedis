import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.scard function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/sets/setup.sql');
        await runSqlFile('sql/sets/op/sadd.sql');
        await runSqlFile('sql/sets/op/scard.sql');
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

    it('should return the correct cardinality (number of elements) of a set', async () => {
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_a']);
        await pool.query('SELECT redis.sadd($1, $2);', ['my:set', 'member_b']);

        const res = await pool.query('SELECT redis.scard($1) AS set_cardinality;', ['my:set']);
        expect(Number(res.rows[0].set_cardinality)).toBe(2);
    })

    it('should return 0 for non-existent sets', async () => {
        const res = await pool.query('SELECT redis.scard($1) AS set_cardinality;', ['non_existent']);
        expect(Number(res.rows[0].set_cardinality)).toBe(0);
    })
})