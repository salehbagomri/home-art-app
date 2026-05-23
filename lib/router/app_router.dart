import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/main/presentation/screens/main_shell.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/store/presentation/screens/store_screen.dart';
import '../features/store/presentation/screens/product_details_screen.dart';
import '../features/inspiration/presentation/screens/inspiration_screen.dart';
import '../features/custom_design/presentation/screens/custom_design_screen.dart';
import '../features/orders/presentation/screens/orders_list_screen.dart';
import '../features/orders/presentation/screens/order_tracking_screen.dart';
import '../features/checkout/presentation/screens/checkout_screen.dart';
import '../features/support/presentation/screens/support_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main Shell (Bottom Nav)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/store',
            builder: (context, state) => const StoreScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const OrdersListScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Detail Screens (Outside Shell - No Bottom Nav)
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailsScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/inspiration',
        builder: (context, state) => const InspirationScreen(),
      ),
      GoRoute(
        path: '/custom-design',
        builder: (context, state) => const CustomDesignScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) => OrderTrackingScreen(
          orderId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
    ],
  );
}
