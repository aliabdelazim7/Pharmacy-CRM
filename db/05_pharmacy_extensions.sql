-- 1) إضافة عمود نوع فاتورة المشتريات (شراء / مرتجع)
alter table purchase_invoices add column if not exists type text default 'purchase';

-- 2) إضافة حقول الحبوب والشرائط لجدول المنتجات
alter table products add column if not exists has_strips boolean default false;
alter table products add column if not exists strips_per_box integer default 1;
alter table products add column if not exists strip_sale_price numeric default 0;

-- 3) إضافة عمود وحدة البيع الفعلية لجدول عناصر فواتير المبيعات
alter table order_items add column if not exists unit text default 'قطعة';
