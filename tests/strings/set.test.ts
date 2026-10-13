import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.set_string function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/strings/setup.sql');
        await runSqlFile('sql/strings/op/set.sql');
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

    it('should insert a new string key successfully without a TTL', async () => {
        await pool.query('SELECT redis.set_string($1, $2);', ['test_key_1', 'hello world']);

        const result = await pool.query('SELECT key, value, expires_at FROM redis.strings WHERE key = $1;', ['test_key_1']);

        expect(result.rows.length).toBe(1);
        expect(result.rows[0].value).toBe('hello world');
        expect(result.rows[0].expires_at).toBeNull();
    })

    it('should update an existing key and handle TTL correctly', async () => {
        await pool.query('SELECT redis.set_string($1, $2, $3);', ['test_key_2', 'first_value', 300]);

        await pool.query('SELECT redis.set_string($1, $2);', ['test_key_2', 'updated_value']);

        const result = await pool.query('SELECT value, expires_at FROM redis.strings WHERE key = $1;', ['test_key_2'])

        expect(result.rows.length).toBe(1);
        expect(result.rows[0].value).toBe('updated_value');
    })
})