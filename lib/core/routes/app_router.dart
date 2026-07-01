import 'package:uts_catalog_helm/features/cart/presentation/pages/cart_pages.dart';
import 'package:uts_catalog_helm/features/order/data/models/order_model.dart';
import 'package:uts_catalog_helm/features/order/presentation/pages/checkout_pages.dart';
import 'package:uts_catalog_helm/features/order/presentation/pages/order_success_page.dart';
import 'package:uts_catalog_helm/features/order/presentation/pages/my_orders_page.dart';
import 'package:uts_catalog_helm/features/order/presentation/pages/payment_pending_page.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/register_page.dart';
import '../../../features/auth/presentation/pages/verify_email_page.dart';
import '../../../features/dashboard/presentation/pages/main_page.dart';
import '../guards/authguard.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static String get cart => '/cart';
  static String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String myOrders = '/my-orders';
  static const String paymentPending = '/payment-pending';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    verifyEmail: (_) => const VerifyEmailPage(),
    dashboard: (_) => const AuthGuard(child: MainPage()),
    cart: (_) => const CartPage(),
    checkout: (_) => const CheckoutPage(),
    orderSuccess: (context) {
      final order = ModalRoute.of(context)!.settings.arguments as OrderModel;
      return OrderSuccessPage(order: order);
    },
    AppRouter.paymentPending: (context) {
      final order = ModalRoute.of(context)!.settings.arguments as OrderModel;

      return PaymentPendingPage(order: order);
    },
    myOrders: (_) => const MyOrdersPage(),
  };
}
