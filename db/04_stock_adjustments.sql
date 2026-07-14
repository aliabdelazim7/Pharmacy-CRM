-- إضافة الأعمدة اللازمة لتقسيم المخزون والموسم
alter table products add column if not exists display_quantity numeric default 0;
alter table products add column if not exists season text; -- 'summer' | 'winter' | 'annual'

-- إنشاء جدول سجل تسويات الجرد
create table if not exists stock_adjustments (
  id uuid default gen_random_uuid() primary key,
  product_id uuid references products(id) on delete set null,
  product_name text,
  system_qty numeric,
  counted_qty numeric,
  diff numeric,            -- counted - system (سالب = عجز، موجب = زيادة)
  cost numeric default 0,  -- تكلفة الوحدة وقت الجرد
  note text,
  created_at timestamptz default now()
);

alter table stock_adjustments enable row level security;
drop policy if exists "authenticated full access" on stock_adjustments;
create policy "authenticated full access" on stock_adjustments for all to authenticated using (true) with check (true);
revoke all on stock_adjustments from anon;
grant all on stock_adjustments to authenticated;
