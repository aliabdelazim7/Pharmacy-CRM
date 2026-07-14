-- ─────────────────────────────────────────────────────────────
-- Enable strip selling for the demo PILL products (tablets/capsules only —
-- not syrups, drops, gels, cosmetics or supplies).
-- After running this, these products show a "علبة كاملة / شريط" choice at
-- the POS. Stock stays counted in boxes; selling a strip deducts
-- (1 / strips_per_box) of a box automatically.
-- strip_sale_price is DERIVED here from the current box sale_price:
--   strip price = round(box sale_price / strips_per_box, 2)
-- Idempotent — safe to re-run.
-- Run once in Supabase → SQL Editor.
-- ─────────────────────────────────────────────────────────────
update products p
set
  has_strips       = true,
  unit             = 'علبة',
  strips_per_box   = v.spb,
  strip_sale_price = round(p.sale_price / v.spb, 2)
from (values
  -- barcode,        strips_per_box
  ('6221000000011', 2),   -- بانادول إكسترا 24 قرص
  ('6221000000028', 2),   -- بروفين 400 (20 قرص)
  ('6221000000035', 2),   -- كتافلام 50 (20 قرص)
  ('6221000000066', 2),   -- أوجمنتين 1جم (14 قرص)
  ('6221000000073', 2),   -- زيثروماكس 500
  ('6221000000080', 2),   -- أموكسيسيلين 500
  ('6221000000097', 2),   -- سيبروفلوكساسين 500
  ('6221000000103', 2),   -- فلاجيل 500 (20 قرص)
  ('6221000000110', 2),   -- كونجستال (20 قرص)
  ('6221000000127', 2),   -- كومتريكس (24 قرص)
  ('6221000000158', 2),   -- ستربسلس (أقراص استحلاب)
  ('6221000000196', 3),   -- كالسيوم د3 (30 قرص)
  ('6221000000226', 2),   -- بوسكوبان (20 قرص)
  ('6221000000233', 3)    -- موتيليوم (30 قرص)
) as v(barcode, spb)
where p.barcode = v.barcode;
