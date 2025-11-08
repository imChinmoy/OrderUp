import 'package:client/features/admin/presentation/screens/admin_profile_screen.dart';
import 'package:client/features/admin/presentation/screens/admin_screen.dart';
import 'package:client/features/auth/presentation/screens/login_screen.dart';
import 'package:client/features/auth/presentation/screens/signup_screen.dart';
import 'package:client/features/menu/presentation/screens/main_navigation_screen.dart';
import 'package:client/features/menu/presentation/screens/search_screen.dart';
import 'package:client/features/order/presentation/screens/cart_screen.dart';
import 'package:client/features/menu/presentation/screens/food_detail_screen.dart';
import 'package:client/features/order/presentation/screens/order_success_screen.dart';
import 'package:client/features/order/presentation/screens/order_summary_screen.dart';
import 'package:client/features/payment/presentation/screens/razorpay_screen.dart';
import 'package:client/features/recommendations/presentation/screens/recommendation_screen.dart';
import 'package:client/features/menu/domain/entities/menu_item_entity.dart';
import 'package:client/features/recommendations/presentation/screens/recommendations_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../../features/auth/data/models/session_model.dart';

// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if user is logged in
      final box = Hive.box<SessionModel>('sessionBox');
      final session = box.get('current_session');

      final isLoggedIn = session != null && session.token.isNotEmpty;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSigningUp = state.matchedLocation == '/signup';

      // If not logged in and trying to access protected routes
      if (!isLoggedIn &&
          !isLoggingIn &&
          !isSigningUp &&
          state.matchedLocation == '/') {
        return '/login';
      }

      // If logged in, check role for initial redirect
      if (isLoggedIn && state.matchedLocation == '/') {
        try {
          final userMap = jsonDecode(session.user);
          final role = userMap['role'] ?? '';

          if (role == 'admin') {
            return '/admin';
          } else {
            return '/home';
          }
        } catch (e) {
          return '/login';
        }
      }

      return null; // No redirect needed
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Home Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainNavigationScreen(),
      ),

      // Search
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),

      // Cart
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),

      // Food Detail (with parameter)
      GoRoute(
        path: '/food-detail',
        name: 'food-detail',
        builder: (context, state) {
          final item = state.extra as MenuItemEntity;
          return FoodDetailScreen(item: item);
        },
      ),

      // Recommendations
      GoRoute(
        path: '/recommendations',
        name: 'recommendations',
        builder: (context, state) => const RecommendationScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminScreen(),
      ),

      // Default/Root Route
      GoRoute(
        path: '/',
        redirect: (context, state) => null, // Handled by global redirect
      ),
      GoRoute(
        path: '/admin-profile',
        name: 'admin-profile',
        builder: (context, state) => AdminProfileScreen(),
      ),
      GoRoute(
        path: '/order-summary',
        name: 'order-summary',
        builder: (context, state) {
          final totalAmount = state.extra as double;
          return OrderSummaryScreen(totalAmount: totalAmount);
        },
      ),
      GoRoute(
        path: '/order-success',
        name: 'order-success',
        builder: (context, state) {
          final totalAmount = state.extra as double;
          return OrderSuccessScreen(totalAmount: totalAmount);
        },
      ),

      GoRoute(
        path: '/razorpay',
        name: 'razorpay',
        builder: (context, state) {
          final totalAmount = state.extra as double;
          return RazorpayScreen(totalAmount: totalAmount);
        },
      ),
      GoRoute(
        path: '/recommendations-result',
        name: 'recommendations-result',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return RecommendationsResultScreen(params: params);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});
