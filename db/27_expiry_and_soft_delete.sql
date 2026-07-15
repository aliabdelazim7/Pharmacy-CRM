-- ─────────────────────────────────────────────────────────────
-- Expiry reminder (per product) + safe/soft product deletion.
-- Idempotent & backward compatible. Run once in Supabase → SQL Editor.
-- ─────────────────────────────────────────────────────────────

-- فترة التذكير قبل انتهاء الصلاحية (أيام) — لكل منتج على حدة.
alter table products add column if not exists expiry_reminder_days integer default 30;

-- الحذف الآمن (soft delete): يختفي المنتج من كل الشاشات لكن الفواتير القديمة تبقى.
alter table products add column if not exists is_deleted boolean not null default false;
alter table products add column if not exists deleted_at timestamptz;

-- فهارس تسريع الاستعلامات.
create index if not exists idx_products_is_deleted on products(is_deleted);
create index if not exists idx_products_expiry_date on products(expiry_date);
