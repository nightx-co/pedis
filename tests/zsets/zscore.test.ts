import { pool, runSqlFile } from '../helpers/db.js';

describe('redis.zscore function', () => {
    beforeAll(async () => {
        await runSqlFile('sql/zsets/setup.sql');
        await runSqlFile('sql/zsets/op/zadd.sql');
        await runSqlFile('sql/zsets/op/zscore.sql');
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

    it('should retrieve the score of a specified member', async () => {
        await pool.query('SELECT redis.zadd($1, $2, $3);', ['leaderboard:game', 1500.5, 'player_alice']);

        const res = await pool.query('SELECT redis.zscore($1, $2) AS alice_score;', ['leaderboard:game', 'player_alice']);
        expect(Number(res.rows[0].alice_score)).toBe(1500.5);
    })

    it('should return null for a non-existent member', async () => {
        const res = await pool.query('SELECT redis.zscore($1, $2) AS missing_score;', ['leaderboard:game', 'player_ghost']);
        expect(res.rows[0].missing_score).toBeNull();
    })
})