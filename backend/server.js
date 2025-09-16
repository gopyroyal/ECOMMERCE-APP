import express from 'express'
import mysql from 'mysql2/promise'
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
app.use(express.json())

const PORT = process.env.PORT || 3000

// RDS creds are injected via ECS task env (from Secrets Manager)
const DB_HOST = process.env.DB_HOST
const DB_USER = process.env.DB_USER
const DB_PASS = process.env.DB_PASS
const DB_NAME = process.env.DB_NAME || 'ecommerce'

async function getConn(db = null) {
  const cfg = { host: DB_HOST, user: DB_USER, password: DB_PASS }
  if (db) cfg.database = db
  return mysql.createConnection(cfg)
}

async function ensureSchema() {
  try {
    const c = await getConn()
    // Create DB if needed and tables/seed
    const initSql = fs.readFileSync(path.join(__dirname, 'db-init.sql'), 'utf8')
    await c.query(initSql)
    await c.end()

    // Replace placeholder base path for images
    const c2 = await getConn(DB_NAME)
    const [rows] = await c2.query("SELECT COUNT(*) as cnt FROM products")
    if (rows[0].cnt > 0) {
      const base = process.env.ASSETS_BASE_URL || ''
      if (base) {
        await c2.query("UPDATE products SET image_url = REPLACE(image_url, 'PRODUCT_IMAGE_URL_PLACEHOLDER', ?)", [base])
      }
    }
    await c2.end()
    console.log("DB schema ensured/seeded.")
  } catch (e) {
    console.error("Schema ensure error:", e.message)
  }
}

app.get('/health', (req, res) => {
  res.json({ status: 'OK' })
})

app.get('/products', async (req, res) => {
  try {
    const c = await getConn(DB_NAME)
    const [rows] = await c.query("SELECT id, name, description, price, image_url FROM products ORDER BY id DESC LIMIT 50")
    await c.end()
    res.json(rows)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.listen(PORT, async () => {
  console.log(`Backend listening on ${PORT}`)
  await ensureSchema()
})
