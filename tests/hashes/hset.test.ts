import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.hset function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/hashes/setup.sql');
        await runSqlFile('sql/hashes/op/hset.sql');
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

    it('should set fields in a hash successfully with or without TTL', async () => {
        await pool.query('SELECT redis.hset($1, $2, $3, $4);', [
            'user:1000',
            'name',
            'Alice',
            3600,
        ])

        await pool.query('SELECT redis.hset($1, $2, $3);', [
            'user:1000',
            'email',
            'alice@example.com',
        ])

        const res = await pool.query(
            'SELECT fields FROM redis.hashes WHERE key = $1;',
            ['user:1000']
        )

        expect(res.rows).toHaveLength(1);
        const storedFields = res.rows[0].fields;
        
        expect(storedFields.name).toBe('Alice');
        expect(storedFields.email).toBe('alice@example.com');
    })
})