import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.hgetall function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/hashes/setup.sql');
        await runSqlFile('sql/hashes/op/hset.sql');
        await runSqlFile('sql/hashes/op/hgetall.sql');
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

    it('should return all fields and values for a given hash key', async () => {
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'name', 'Alice']);
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'email', 'alice@example.com']);
        await pool.query('SELECT redis.hset($1, $2, $3);', ['user:1000', 'login_count', '5']);

        const res = await pool.query('SELECT redis.hgetall($1) AS full_user_hash;', [ 'user:1000' ]);

        expect(res.rows).toHaveLength(1);
        
        const hashResult = res.rows[0].full_user_hash;
        expect(hashResult).toBeDefined();
        expect(hashResult.name).toBe('Alice');
        expect(hashResult.email).toBe('alice@example.com');
        expect(hashResult.login_count).toBe('5');
    })

    it('should return null or empty for non-existent hash keys', async () => {
        const res = await pool.query('SELECT redis.hgetall($1) AS missing_hash;', [
            'non_existent_user',
        ])

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].missing_hash).toEqual({});
    })
})