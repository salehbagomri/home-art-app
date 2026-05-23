import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';

class HomeArtApp extends StatelessWidget {
  const HomeArtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'هوم آرت',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // === فرض RTL ===
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },

      // === Router ===
      routerConfig: AppRouter.router,
    );
  }
}
