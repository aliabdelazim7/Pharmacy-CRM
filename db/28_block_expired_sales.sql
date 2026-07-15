-- ─────────────────────────────────────────────────────────────
-- Server-side guard: never allow an EXPIRED medicine onto a sale.
-- A BEFORE INSERT trigger on order_items rejects any line whose product
-- expiry_date is before today — true backend enforcement independent of
-- the frontend (a medicine on its expiry day is still sellable).
-- Returns/edits UPDATE order_items (not INSERT) so they are unaffected.
-- Idempotent. Run once in Supabase → SQL Editor.
-- ─────────────────────────────────────────────────────────────
create or replace function public.block_expired_order_item()
returns trigger
language plpgsql
as $$
declare
  v_exp date;
  v_name text;
begin
  select expiry_date, name into v_exp, v_name from products where id = new.product_id;
  if v_exp is not null and v_exp < current_date then
    raise exception 'لا يمكن بيع دواء منتهي الصلاحية: %', coalesce(v_name, new.product_name);
  end if;
  return new;
end;
$$;

drop trigger if exists trg_block_expired_order_item on order_items;
create trigger trg_block_expired_order_item
  before insert on order_items
  for each row execute function public.block_expired_order_item();
