import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // === العناوين الكبيرة ===
  static TextStyle headlineLarge = GoogleFonts.notoSansArabic(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.nightBrown,
    height: 1.4,
  );

  static TextStyle headlineMedium = GoogleFonts.notoSansArabic(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.nightBrown,
    height: 1.4,
  );

  static TextStyle headlineSmall = GoogleFonts.notoSansArabic(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.nightBrown,
    height: 1.4,
  );

  // === عناوين الأقسام ===
  static TextStyle sectionTitle = GoogleFonts.notoSansArabic(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.nightBrown,
    height: 1.4,
  );

  // === النصوص العادية ===
  static TextStyle bodyLarge = GoogleFonts.notoSansArabic(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.nightBrown,
    height: 1.6,
  );

  static TextStyle bodyMedium = GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.nightBrown,
    height: 1.6,
  );

  static TextStyle bodySmall = GoogleFonts.notoSansArabic(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.subtleText,
    height: 1.5,
  );

  // === الأزرار ===
  static TextStyle buttonLarge = GoogleFonts.notoSansArabic(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.4,
  );

  static TextStyle buttonMedium = GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    height: 1.4,
  );

  // === التسمية التوضيحية ===
  static TextStyle caption = GoogleFonts.notoSansArabic(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.subtleText,
    height: 1.4,
  );

  // === السعر ===
  static TextStyle priceLarge = GoogleFonts.notoSansArabic(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.nightBrown,
    height: 1.3,
  );

  static TextStyle priceSmall = GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.nightBrown,
    height: 1.3,
  );

  // === الروابط ===
  static TextStyle link = GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.gold,
    height: 1.4,
  );

  // === شريط التنقل السفلي ===
  static TextStyle navLabel = GoogleFonts.notoSansArabic(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );
}
