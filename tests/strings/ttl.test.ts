import { pool, runSqlFile } from '../helpers/db.js';

describe('redis TTL functionality', () => {
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

    it('should set an expiration timestamp correctly when TTL is provided', async () => {
        await pool.query('SELECT redis.set_string($1, $2, $3);', [
            'user:100:status',
            'active',
            60,
        ])

        const res = await pool.query(
            'SELECT expires_at, (expires_at > NOW()) AS is_future FROM redis.strings WHERE key = $1;',
            ['user:100:status']
        )

        expect(res.rows).toHaveLength(1);
        expect(res.rows[0].expires_at).not.toBeNull();
        expect(res.rows[0].is_future).toBe(true);
    })
})