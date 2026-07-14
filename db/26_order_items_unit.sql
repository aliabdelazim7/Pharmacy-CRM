-- ─────────────────────────────────────────────────────────────
-- Persist the sale unit (علبة / شريط / قطعة ...) on each sold line item.
-- The POS already writes `unit` on every order item; this column makes
-- fresh databases consistent with that behaviour and enables box/strip
-- sales reporting. Idempotent & backward compatible — existing rows
-- default to 'قطعة'.
-- Run once in Supabase → SQL Editor.
-- ─────────────────────────────────────────────────────────────
alter table order_items
  add column if not exists unit text default 'قطعة';
