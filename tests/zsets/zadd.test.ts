import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.zadd function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/zsets/setup.sql');
        await runSqlFile('sql/zsets/op/zadd.sql');
    });

    beforeEach(async () => {
        await pool.query('BEGIN;');
        await pool.query("DELETE FROM redis.zsets WHERE key = 'leaderboard:game';");
    });

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    });

    afterAll(async () => {
        await pool.end();
    });

    it('should return 1 for new members and 0 when updating an existing member score', async () => {
        const res1 = await pool.query('SELECT redis.zadd($1, $2, $3) AS added_alice;', ['leaderboard:game', 1500.5, 'player_alice']);
        expect(Number(res1.rows[0].added_alice)).toBe(1);

        const res2 = await pool.query('SELECT redis.zadd($1, $2, $3) AS updated_alice_score;', ['leaderboard:game', 2500.0, 'player_alice']);
        expect(Number(res2.rows[0].updated_alice_score)).toBe(0);
    });
});