import express from "express";
import cors from "cors";
import mysql from "mysql2/promise";

const app = express();
app.use(cors());
app.use(express.json());

const cfg = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME
};

app.get("/health", async (_req, res) => {
  try {
    const conn = await mysql.createConnection({ ...cfg });
    await conn.query("SELECT 1");
    await conn.end();
    res.json({ status: "OK" });
  } catch (e) {
    res.status(503).json({ status: "DOWN", error: e.message });
  }
});

app.get("/products", async (_req, res) => {
  try {
    const conn = await mysql.createConnection({ ...cfg });
    const [rows] = await conn.query("SELECT id, name, description, price, image_url FROM products ORDER BY id DESC");
    await conn.end();
    res.json(rows);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API listening on ${PORT}`));
