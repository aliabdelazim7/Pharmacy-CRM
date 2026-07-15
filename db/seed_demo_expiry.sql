-- ─────────────────────────────────────────────────────────────
-- Adds expiry-reminder + soft-delete columns AND gives the demo
-- products realistic expiry dates (to populate the notification center).
-- Safe/idempotent. Run once in Supabase → SQL Editor (only needed if you
-- already ran the demo seed before the expiry feature was added).
-- ─────────────────────────────────────────────────────────────
alter table products add column if not exists expiry_reminder_days integer default 30;
alter table products add column if not exists is_deleted boolean not null default false;
alter table products add column if not exists deleted_at timestamptz;
create index if not exists idx_products_is_deleted on products(is_deleted);
create index if not exists idx_products_expiry_date on products(expiry_date);

update products set expiry_reminder_days = coalesce(expiry_reminder_days, 30)
  where barcode like '62210000%';
update products set expiry_date = '2028-01-01'
  where barcode like '62210000%' and expiry_date is null;
update products p set expiry_date = v.d from (values
  ('6221000000011','2026-08-05'),   -- بانادول  → قرب الانتهاء
  ('6221000000028','2026-07-25'),   -- بروفين   → قرب الانتهاء
  ('6221000000035','2026-05-10'),   -- كتافلام  → منتهي
  ('6221000000042','2026-06-01')    -- أبيمول   → منتهي
) as v(barcode, d) where p.barcode = v.barcode;
