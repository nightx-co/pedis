import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.zcard function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/zsets/setup.sql');
        await runSqlFile('sql/zsets/op/zadd.sql');
        await runSqlFile('sql/zsets/op/zcard.sql');
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

    it('should return the total count of members in the sorted set', async () => {
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 1500.5, 'player_alice']);
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 2200.0, 'player_bob']);

        const res = await pool.query('SELECT redis.zcard($1) AS total_players;', ['leaderboard:game']);
        expect(Number(res.rows[0].total_players)).toBe(2);
    })

    it('should return 0 for non-existent sorted sets', async () => {
        const res = await pool.query('SELECT redis.zcard($1) AS total_players;', ['non_existent']);
        expect(Number(res.rows[0].total_players)).toBe(0);
    })
})