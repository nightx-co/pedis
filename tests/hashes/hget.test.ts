import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.hget function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/hashes/setup.sql');
        await runSqlFile('sql/hashes/op/hset.sql');
        await runSqlFile('sql/hashes/op/hget.sql');
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

    it('should retrieve a specific field value from a hash', async () => {
        // Setup initial hash data using hset
        await pool.query('SELECT redis.hset($1, $2, $3);', [
            'user:1000',
            'name',
            'Alice',
        ])

        // Test hget function
        const res = await pool.query('SELECT redis.hget($1, $2) AS user_name;', [
            'user:1000',
            'name',
        ])

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].user_name).toBe('Alice');
    });

    it('should return null for non-existent fields or keys', async () => {
        const res = await pool.query('SELECT redis.hget($1, $2) AS missing_val;', [
            'user:1000',
            'non_existent_field',
        ])

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].missing_val).toBeNull();
    })
})