class AppAssets {
  AppAssets._();

  // === Logo ===
  static const String logoDark = 'App_Assets/logo/homeart-logo-dark.png';         // خلفية كريمية
  static const String logoDarkTransparent = 'App_Assets/logo/homeart-logo-dark1.png'; // مفرّغ دارك
  static const String logoLight = 'App_Assets/logo/homeart-logo-lite.png';         // خلفية داكنة
  static const String logoLightTransparent = 'App_Assets/logo/homeart-logo-lite1.png'; // مفرّغ لايت

  // === الاختصارات حسب الاستخدام ===
  static const String appIcon = logoDark;
  static const String splashLogo = logoLight;
  static const String appBarLogo = logoLightTransparent;     // للـ AppBar الداكن
  static const String inPageLogo = logoDarkTransparent;      // داخل الصفحات الفاتحة
}
