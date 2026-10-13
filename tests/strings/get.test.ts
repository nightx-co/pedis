import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.get_string function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/strings/setup.sql');
        await runSqlFile('sql/strings/op/set.sql');
        await runSqlFile('sql/strings/op/get.sql');
    })

    beforeEach(async () => {
        await pool.query('BEGIN;');
    })

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    })

    afterAll(async () => {
        await pool.end();
    })

    it('should retrieve a string value successfully', async () => {
        await pool.query('SELECT redis.set_string($1, $2);', [
            'session:token',
            'abc123xyz',
        ])

        const res = await pool.query('SELECT redis.get_string($1) AS session_value;', [ 'session:token' ]);

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].session_value).toBe('abc123xyz');
    })

    it('should return null for non-existent keys', async () => {
        const res = await pool.query('SELECT redis.get_string($1) AS missing_value;', [
            'non_existent_key',
        ])

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].missing_value).toBeNull();
    })
})