import fs from "node:fs";
import pg from "pg";
const {Pool}=pg;
if(!process.env.DATABASE_URL){console.error("Missing DATABASE_URL");process.exit(1);}
const pool=new Pool({connectionString:process.env.DATABASE_URL,ssl:process.env.DATABASE_URL.includes("localhost")?false:{rejectUnauthorized:false}});
try{const sql=fs.readFileSync("db/schema.sql","utf8");await pool.query(sql);console.log("Database schema applied.");}
catch(e){console.error(e);process.exitCode=1;}
finally{await pool.end();}
