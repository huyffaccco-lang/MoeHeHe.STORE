import { Pool } from "pg";

declare global { var __moehehePool: Pool | undefined; }

export const pool = global.__moehehePool ?? new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.DATABASE_URL?.includes("localhost") ? false : { rejectUnauthorized: false },
  max: 5,
});
if (process.env.NODE_ENV !== "production") global.__moehehePool = pool;
