import 'package:flutter/material.dart';
import 'package:musik/features/offline/offline_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'features/splash/splash_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/main/main_page.dart';
import 'features/subscription/subscription_page.dart';
import 'features/payment/payment_page.dart';
import 'features/payment/payment_success_page.dart';
import 'features/payment/payment_failed_page.dart';
import 'features/player/player_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Misik',
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.main: (_) => const MainPage(),
        AppRoutes.subscription: (_) => const SubscriptionPage(),
        AppRoutes.payment: (_) => const PaymentPage(),
        AppRoutes.paymentSuccess: (_) => const PaymentSuccessPage(),
        AppRoutes.paymentFailed: (_) => const PaymentFailedPage(),
        AppRoutes.offline: (_) => const OfflinePage(), // ← TAMBAH INI
      },
    );
  }
}