// ─── نظام صلاحية الأدوية ──────────────────────────────────────
// حساب حالة الصلاحية (سليم / قرب الانتهاء / منتهي) والتحقق عند الإضافة.
// المخزون والتكلفة لا علاقة لهما بهذا الملف — هذا خاص بالتواريخ فقط.

export const DEFAULT_EXPIRY_REMINDER_DAYS = 30;

/** الأيام المتبقية حتى انتهاء الصلاحية (سالب = منتهي). null لو لا يوجد تاريخ صالح. */
export function daysUntilExpiry(expiry?: string | null): number | null {
  if (!expiry) return null;
  const d = new Date(expiry);
  if (isNaN(d.getTime())) return null;
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  d.setHours(0, 0, 0, 0);
  return Math.round((d.getTime() - today.getTime()) / 86400000);
}

export type ExpiryStatus = 'none' | 'ok' | 'soon' | 'expired';

/** حالة صلاحية المنتج حسب فترة التذكير الخاصة به (أيام قبل الانتهاء). */
export function expiryStatus(expiry?: string | null, reminderDays?: number | null): ExpiryStatus {
  const days = daysUntilExpiry(expiry);
  if (days === null) return 'none';
  if (days < 0) return 'expired';
  const window = reminderDays && reminderDays > 0 ? reminderDays : DEFAULT_EXPIRY_REMINDER_DAYS;
  if (days <= window) return 'soon';
  return 'ok';
}

/**
 * التحقق من صلاحية دواء عند الإنشاء/الحفظ/الشراء:
 *  - لازم يكون فيه تاريخ صلاحية.
 *  - يُرفض لو سنة الانتهاء = السنة الحالية أو أقدم (لازم تكون السنة القادمة على الأقل).
 * يرجّع رسالة الخطأ بالعربية، أو null لو التاريخ سليم.
 */
export function validateMedicineExpiry(expiry?: string | null): string | null {
  if (!expiry) return 'تاريخ انتهاء الصلاحية مطلوب لكل دواء.';
  const d = new Date(expiry);
  if (isNaN(d.getTime())) return 'تاريخ انتهاء الصلاحية غير صالح.';
  const currentYear = new Date().getFullYear();
  if (d.getFullYear() <= currentYear) {
    return `لا يمكن إضافة دواء تنتهي صلاحيته سنة ${d.getFullYear()}. يجب أن تكون الصلاحية سنة ${currentYear + 1} على الأقل.`;
  }
  return null;
}
