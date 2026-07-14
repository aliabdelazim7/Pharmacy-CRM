// ─── نظام وحدات المنتجات ──────────────────────────────────────
// كل منتج له وحدة (قطعة / كيلو / جرام / لتر ...). المخزون وسعر البيع
// مُخزّنان دائماً بهذه الوحدة الأساسية. الوحدات الكسرية (الوزن/الحجم/الطول)
// تسمح ببيع كميات عشرية، وبعضها له وحدة فرعية للإدخال السريع (مثل الجرام للكيلو).

export interface UnitConfig {
  value: string;        // اسم الوحدة المخزّن
  label: string;        // الاسم المعروض
  fractional: boolean;  // هل تسمح بكميات كسرية (وزن/حجم/طول)؟
  subUnit?: string;     // الوحدة الفرعية للإدخال السريع (جرام، مل، سم)
  subPerUnit?: number;  // عدد الوحدات الفرعية في الوحدة الأساسية (1000 جرام = 1 كيلو)
}

// وحدات صيدلية فقط — لا وحدات وزن/حجم/مساحة عامة (كيلو/لتر/متر/كرتونة/شيكارة).
export const UNIT_OPTIONS: UnitConfig[] = [
  { value: 'علبة', label: 'علبة', fractional: false },
  { value: 'شريط', label: 'شريط', fractional: false },
  { value: 'قطعة', label: 'قطعة', fractional: false },
  { value: 'زجاجة', label: 'زجاجة', fractional: false },
  { value: 'أنبوبة', label: 'أنبوبة (كريم/مرهم)', fractional: false },
  { value: 'أمبول', label: 'أمبول', fractional: false },
  { value: 'فيال', label: 'فيال', fractional: false },
  { value: 'كيس', label: 'كيس (ساشيه)', fractional: false },
  { value: 'كبسولة', label: 'كبسولة', fractional: false },
  { value: 'قرص', label: 'قرص', fractional: false },
  { value: 'نقط', label: 'نقط', fractional: false },
  { value: 'بخاخ', label: 'بخاخ', fractional: false },
];

const DEFAULT_UNIT: UnitConfig = UNIT_OPTIONS[0];

/** إرجاع إعدادات الوحدة (يرجّع "قطعة" لو الوحدة غير معروفة أو فارغة). */
export function getUnitConfig(unit?: string | null): UnitConfig {
  if (!unit) return DEFAULT_UNIT;
  return UNIT_OPTIONS.find((u) => u.value === unit) ?? { value: unit, label: unit, fractional: false };
}

/** هل هذه الوحدة تُباع بكميات كسرية (بالوزن)؟ */
export function isFractionalUnit(unit?: string | null): boolean {
  return getUnitConfig(unit).fractional;
}

/**
 * تنسيق كمية للعرض حسب الوحدة.
 * - وحدات صحيحة (قطعة): بدون كسور.
 * - وحدات كسرية: حتى 3 خانات عشرية مع حذف الأصفار الزائدة، متبوعة باسم الوحدة.
 */
export function formatQty(qty: number, unit?: string | null): string {
  const cfg = getUnitConfig(unit);
  if (!cfg.fractional) return `${Math.round(qty)} ${cfg.label}`;
  const rounded = Math.round(qty * 1000) / 1000;
  const text = Number.isInteger(rounded) ? String(rounded) : rounded.toFixed(3).replace(/0+$/, '');
  return `${text} ${cfg.label}`;
}

/** أقل كمية مسموحة (خطوة) حسب نوع الوحدة. */
export function unitStep(unit?: string | null): number {
  return isFractionalUnit(unit) ? 0.25 : 1;
}

/** أقل كمية يمكن أن تبقى في السلة لمنتج (تمنع الصفر للقطع). */
export function unitMinQty(unit?: string | null): number {
  return isFractionalUnit(unit) ? 0.001 : 1;
}
