import { Pool } from 'pg';
import * as fs from 'fs';
import * as path from 'path';

export const pool = new Pool({
    connectionString: 'postgresql://postgres:password@localhost:5433/postgres'
})

// Helper to execute SQL script files
export async function runSqlFile(relativePath : string) {
    const filePath = path.join(__dirname, '../../', relativePath);
    const sql = fs.readFileSync(filePath, 'utf8');
    await pool.query(sql);
}