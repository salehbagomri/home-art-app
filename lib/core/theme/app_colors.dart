import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === الألوان الرئيسية من الهوية البصرية ===
  static const Color nightBrown = Color(0xFF17130F);       // بني ليلي — Header, خلفيات داكنة
  static const Color woodBrown = Color(0xFF6B543E);        // بني خشبي — نصوص ثانوية, أيقونات
  static const Color gold = Color(0xFFBDA36D);             // ذهبي هوم آرت — اللون الرئيسي
  static const Color galleryCream = Color(0xFFF4EFE5);     // كريمي المعرض — خلفية البطاقات
  static const Color guaranteeGreen = Color(0xFF4F6F55);   // أخضر الضمان — نجاح

  // === ألوان مساعدة ===
  static const Color scaffoldBg = Color(0xFFFAF8F4);      // خلفية الصفحات الرئيسية
  static const Color white = Color(0xFFFFFFFF);            // أبيض البطاقات
  static const Color cardBorder = Color(0xFFE8E2D8);       // حدود البطاقات
  static const Color subtleText = Color(0xFF9B8E7E);       // نصوص خفيفة (وقت, مساعدة)
  static const Color divider = Color(0xFFEDE8E0);          // خطوط فاصلة
  static const Color error = Color(0xFFD4453A);            // أخطاء وتنبيهات
  static const Color inputFill = Color(0xFFF7F4EF);        // خلفية حقول الإدخال
  static const Color shadowColor = Color(0x0D17130F);      // ظل خفيف (5% opacity)
  static const Color goldLight = Color(0xFFD4C4A0);        // ذهبي فاتح — hover/pressed
  static const Color goldDark = Color(0xFFA08B5B);         // ذهبي داكن
  static const Color black = Color(0xFF1A1A1A);            // أسود النصوص

  // === ألوان حالات الطلب ===
  static const Color statusPending = Color(0xFFBDA36D);    // قيد الانتظار
  static const Color statusInProgress = Color(0xFF2196F3); // قيد التنفيذ (أزرق هادئ)
  static const Color statusCompleted = Color(0xFF4F6F55);  // مكتمل
  static const Color statusCancelled = Color(0xFFD4453A);  // ملغي
}
