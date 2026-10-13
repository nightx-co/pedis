import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.zrange function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/zsets/setup.sql');
        await runSqlFile('sql/zsets/op/zadd.sql');
        await runSqlFile('sql/zsets/op/zrange.sql');
    })

    beforeEach(async () => {
        await pool.query('BEGIN;');
        await pool.query("DELETE FROM redis.zsets WHERE key = 'leaderboard:game';");
    })

    afterEach(async () => {
        await pool.query('ROLLBACK;');
    })

    afterAll(async () => {
        await pool.end();
    })

    it('should return members sorted by score ascending', async () => {
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 1500.5, 'player_alice']);
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 2200.0, 'player_bob']);
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 1850.25, 'player_charlie']);

        const res = await pool.query('SELECT redis.zrange($1, $2, $3) AS sorted_leaderboard;', ['leaderboard:game', 0, -1]);
        
        expect(res.rows[0].sorted_leaderboard).toEqual(['player_alice', 'player_charlie', 'player_bob']);
    })
})