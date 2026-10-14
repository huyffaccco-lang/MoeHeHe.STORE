CREATE TABLE IF NOT EXISTS site_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT '',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS game_accounts (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  game TEXT NOT NULL,
  price_cents BIGINT NOT NULL CHECK(price_cents >= 0),
  description TEXT NOT NULL DEFAULT '',
  image_url TEXT NOT NULL DEFAULT '',
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS orders (
  id BIGSERIAL PRIMARY KEY,
  customer_name TEXT NOT NULL,
  contact TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','approved','rejected','paid','delivered','cancelled')),
  total_cents BIGINT NOT NULL CHECK(total_cents >= 0),
  note TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS order_items (
  id BIGSERIAL PRIMARY KEY,
  order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  account_id BIGINT REFERENCES game_accounts(id) ON DELETE SET NULL,
  title_snapshot TEXT NOT NULL,
  price_cents BIGINT NOT NULL CHECK(price_cents >= 0)
);
CREATE TABLE IF NOT EXISTS payments (
  id BIGSERIAL PRIMARY KEY,
  order_id BIGINT REFERENCES orders(id) ON DELETE SET NULL,
  provider TEXT NOT NULL CHECK(provider IN ('bank_transfer','topup_provider','manual')),
  provider_reference TEXT UNIQUE,
  amount_cents BIGINT NOT NULL CHECK(amount_cents >= 0),
  status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','confirmed','failed','refunded')),
  idempotency_key TEXT UNIQUE,
  raw_event JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS wallet_transactions (
  id BIGSERIAL PRIMARY KEY,
  user_ref TEXT NOT NULL,
  amount_cents BIGINT NOT NULL CHECK(amount_cents <> 0),
  reason TEXT NOT NULL,
  provider_reference TEXT UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS admin_audit_logs (
  id BIGSERIAL PRIMARY KEY,
  admin_email TEXT NOT NULL,
  action TEXT NOT NULL,
  target_type TEXT NOT NULL DEFAULT '',
  target_id TEXT NOT NULL DEFAULT '',
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
INSERT INTO site_settings(key,value) VALUES
 ('store_name','MoeHeHe STORE'),
 ('facebook_url','https://facebook.com/your-page')
ON CONFLICT(key) DO NOTHING;

INSERT INTO game_accounts(title,game,price_cents,description,active)
SELECT 'ACC Free Fire mẫu','Free Fire',25000000,'Sản phẩm ví dụ — hãy thay bằng hàng thật.',TRUE
WHERE NOT EXISTS (SELECT 1 FROM game_accounts);
