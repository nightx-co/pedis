import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.hdel function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/hashes/setup.sql');
        await runSqlFile('sql/hashes/op/hset.sql');
        await runSqlFile('sql/hashes/op/hdel.sql');
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

    it('should delete a specific field from a hash and return the deleted count', async () => {
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'name', 'Alice']);
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'email', 'alice@example.com']);

        const res = await pool.query('SELECT redis.hdel($1, $2) AS deleted_count;', [
            'user:1000',
            'email',
        ])

        expect(res.rows).toHaveLength(1);
        expect(Number(res.rows[0].deleted_count)).toBe(1);

        const checkRes = await pool.query('SELECT fields FROM redis.hashes WHERE key = $1;', ['user:1000']);
        
        const storedFields = checkRes.rows[0].fields;
        expect(storedFields.email).toBeUndefined();
        expect(storedFields.name).toBe('Alice');
    })

    it('should return 0 when trying to delete a non-existent field', async () => {
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'name', 'Alice']);

        const res = await pool.query('SELECT redis.hdel($1, $2) AS deleted_count;', [
            'user:1000',
            'non_existent_field',
        ])

        expect(res.rows).toHaveLength(1);
        expect(Number(res.rows[0].deleted_count)).toBe(0);
    })
})